# SonicPiCurves - Quick Reference Guide

## Overview
A Ruby library for generating modulation curves, envelopes, and control signals in Sonic Pi.
All curve functions return lambdas that map position (0-1) to output values (typically 0-1).

## Basic Usage
```ruby
load "~/sonic_pi_curves.rb"
# All functions available immediately (no include needed)

# Create a curve
my_curve = sine(rate: 2, amp: 0.5)

# Use it to modulate parameters
value = my_curve.call(0.5)  # Get value at position 0.5
```

## Common Parameters
Most curve generators accept these optional parameters:
- `amp:` - Amplitude scaling (multiplier)
- `rate:` - Frequency/rate (number of cycles in 0-1 range)
- `phase:` - Phase offset
- `bias:` - DC offset (added after amplitude scaling)

Parameters can be numbers OR functions:
```ruby
# Static parameter
sine(amp: 0.5)

# Dynamic parameter
sine(amp: lambda { |pos| pos * 0.5 })
```

## Curve Generators

### Basic Shapes
```ruby
ramp(...)           # Linear 0→1
saw(...)            # Linear 1→0  
triangle(symmetry:) # Triangle wave (symmetry: 0=saw, 0.5=triangle, 1=ramp)
sine(...)           # Sine wave (0.5±0.5)
pulse(width:)       # Square wave (width: 0-1 duty cycle)
const(value:, mod:) # Constant value, optionally modulated
```

### Easing Curves
```ruby
ease_in(exp:)      # Exponential (slow start, fast end)
ease_out(exp:)     # Logarithmic (fast start, slow end)
ease_in_out(exp:)  # S-curve (slow-fast-slow)
ease_out_in(exp:)  # Inverse S-curve
```

### Random/Noise
```ruby
noise(low:, high:, mode:)  # Random values
# mode: nil = uniform distribution
# mode: 0-1 = triangular distribution peak
```

### Complex Envelopes
```ruby
# Multi-segment envelope with breakpoints
breakpoints(
  [time, value],              # Simple point
  [time, value, curve_func],  # Point with curve to next
  ...
)

# ADSR envelope (Sonic Pi style)
adsr(
  attack:, decay:, sustain:, release:,
  sustain_level:,  # Height of sustain (0-1)
  curve:           # :linear, :exponential, :sine, etc.
)

# Create curve from array of values
timeseries([0, 0.5, 1, 0.3, 0])  # Interpolates between points
```

### Probability & Selection (New!)
```ruby
# Boolean gate based on probability curve (0-1)
# Returns 1.0 or 0.0, uses position-seeded randomness
bernoulli_gate(prob_curve)

# Schmitt trigger with hysteresis (prevents jitter)
# State maintained between calls
schmitt_gate(curve, threshold_low: 0.3, threshold_high: 0.7)

# Select element from array based on curve value (0-1)
categorical_sample(curve, [:option1, :option2, :option3])

# Map curve to sample index (useful for sample morphing)
sample_selector(curve, num_samples: 128)
```

### Temporal Structure (New!)
```ruby
# Control event density based on curve
# Returns 1.0 when event should fire, 0.0 otherwise
density_curve(base_rate, density_curve)

# Sequence through events with curve-controlled timing
# Returns [event, position_in_event]
temporal_sequence(timing_curve, [:event1, :event2, :event3])

# Crossfade between two curves/behaviors
# transition_curve: 0 = start, 1 = end
behavior_transition(start_curve, end_curve, transition_curve)
```

## Utility Functions

### Sampling & Conversion
```ruby
# Convert curve to array of samples
to_array(curve, num_samples, map_func: nil)

# Normalize array to 0-1 range
normalize([1, 5, 10])  # → [0, 0.4, 1]
```

### Composition
```ruby
# Chain curves (output of one feeds into next)
chain(curve1, curve2, curve3)

# Mix curves with weights
mix(
  curve1, weight1,
  curve2, weight2,
  curve3, weight3
)
```

## Sonic Pi Specific

### LFO Helper
```ruby
lfo(shape: :sine, rate: 1, depth: 1, offset: 0)
# shape: :sine, :triangle, :saw, :pulse, :noise
```

### Sequencer
```ruby
# Step through values
sequencer([0, 0.5, 1], smooth: false)  # Stepped
sequencer([0, 0.5, 1], smooth: true)   # Interpolated
```

## Examples

### Modulate synth cutoff with LFO
```ruby
lfo_curve = lfo(shape: :sine, rate: 4)
live_loop :example do
  16.times do |i|
    cutoff = 40 + lfo_curve.call(i/16.0) * 80
    play 60, cutoff: cutoff
    sleep 0.25
  end
end
```

### Create custom envelope
```ruby
env = breakpoints(
  [0, 0],
  [0.1, 1, ease_in(exp: 2)],
  [0.7, 0.3, ease_out],
  [1, 0]
)
```

### Pre-calculate for efficiency
```ruby
# Calculate once outside loop
curve_values = to_array(sine(rate: 2), 64)

live_loop :efficient do
  value = curve_values[tick % 64]
  play 60, amp: value
  sleep 0.125
end
```

### Modulate curve parameters
```ruby
# Rate that changes over time
dynamic_sine = sine(
  rate: lambda { |pos| 1 + pos * 3 },  # Speed up
  amp: lambda { |pos| 1 - pos * 0.5 }  # Fade out
)
```

### Complex modulation chains
```ruby
# Wobble bass: sine through easing
wobble = chain(
  sine(rate: 4),
  ease_in_out(exp: 2)
)

# Multi-layered modulation
complex_mod = mix(
  sine(rate: 1), 0.5,      # Slow base
  triangle(rate: 7), 0.3,  # Fast flutter  
  noise, 0.2               # Random texture
)
```

## Performance Tips

1. **Pre-calculate curves outside loops** for better performance
2. **Use to_array()** to cache values when curve won't change
3. **Combine with Sonic Pi's tick** for easy position tracking
4. **Use with control** for smooth parameter changes
5. **Keep position normalized** (0-1) for predictable behavior

## Integration with Sonic Pi

```ruby
# With control for smooth changes
s = play 60, sustain: 4, note_slide: 0.05
curve = adsr(attack: 1, decay: 0.5, sustain: 2, release: 0.5)

32.times do |i|
  control s, note: 60 + curve.call(i/32.0) * 12
  sleep 0.125
end

# With set/get for global modulation
live_loop :mod_source do
  set :global_cutoff, sine(rate: 0.25).call(tick/64.0)
  sleep 0.125
end

live_loop :consumer do
  sync :mod_source
  play 60, cutoff: 40 + get[:global_cutoff] * 80
end
```

## Advanced Composition: Multiscalar Time & Pattern Synthesis

### Curtis Roads - Micro/Meso/Macro Time Scales

The new probability and temporal functions enable composition across multiple time scales simultaneously:

```ruby
# MACRO: Overall form (slow evolution)
macro_form = adsr(attack: 4, decay: 2, sustain: 8, release: 2)

# MESO: Phrase-level density (medium speed)
meso_density = pulse(width: 0.6, rate: 2)

# MICRO: Sample-level modulation (fast)
micro_rate = sine(rate: 8)

64.times do |i|
  pos = i / 64.0

  # Intensity at macro scale
  intensity = macro_form.call(pos)

  # Event probability at meso scale
  trigger = bernoulli_gate(meso_density).call(pos)

  # Playback modulation at micro scale
  rate_mod = 0.8 + micro_rate.call(pos) * 0.4

  if trigger > 0.5
    sample :drum_heavy_kick,
           amp: intensity * 0.8,
           rate: rate_mod
  end
  sleep 0.125
end
```

### Mark Fell - Pattern Synthesis with Non-Linear Time

Create emergent patterns through rule-based composition:

```ruby
# Nested temporal structures
outer = sine(rate: 0.25)  # Slow evolution

# Inner rate modulated by outer (non-linear time)
inner = lambda do |pos|
  rate = 1 + outer.call(pos) * 8  # Rate varies 1-9
  sine(rate: rate).call(pos)
end

# Probability modulated by both scales
prob = lambda do |pos|
  (outer.call(pos) + inner.call(pos)) / 2.0
end

# Stochastic but deterministic triggering
gate = bernoulli_gate(prob)

64.times do |i|
  pos = i / 64.0
  play :c3, amp: 0.5 if gate.call(pos) > 0.5
  sleep 0.0625
end
```

### Sample Morphing & Selection

Use curves to control sample selection for timbral evolution:

```ruby
# Morph through 128 samples in a directory
morph = ease_in_out(exp: 2)
selector = sample_selector(morph, num_samples: 128)

16.times do |i|
  pos = i / 16.0
  idx = selector.call(pos)  # Returns 0-127

  # Use idx to select sample file
  sample "path/to/samples_#{idx.to_s.rjust(3, '0')}.wav"
  sleep 0.25
end

# Select between different sample categories
categories = [:kick, :snare, :hat, :clap]
cat_curve = sequencer([0, 0.33, 0.66, 1.0])
cat_selector = categorical_sample(cat_curve, categories)

16.times do |i|
  pos = i / 16.0
  category = cat_selector.call(pos)  # Returns :kick, :snare, etc.
  sample category  # Play the selected category
  sleep 0.25
end
```

### Probability-Driven Composition

Create evolving rhythmic patterns with deterministic randomness:

```ruby
# Density increases over time
density = ramp  # 0 to 1
gate = bernoulli_gate(density)

32.times do |i|
  pos = i / 32.0

  # Position-seeded: same pos always gives same result
  if gate.call(pos) > 0.5
    sample :bd_haus, amp: 0.8
  end
  sleep 0.125
end

# Schmitt gate prevents jittery triggering
wobbly = mix(sine(rate: 1), 0.7, noise, 0.3)
stable = schmitt_gate(wobbly, threshold_low: 0.4, threshold_high: 0.6)

32.times do |i|
  pos = i / 32.0

  if stable.call(pos) > 0.5
    sample :sn_dolf  # Clean on/off, no double triggers
  end
  sleep 0.125
end
```

### Behavior Transition & Pattern Morphing

Smoothly morph between different compositional behaviors:

```ruby
# Two different rhythmic patterns
pattern_a = pulse(width: 0.25, rate: 4)
pattern_b = pulse(width: 0.15, rate: 6, phase: 0.1)

# Transition curve (linear crossfade)
transition = ramp

# Hybrid pattern that morphs from A to B
hybrid = behavior_transition(pattern_a, pattern_b, transition)

32.times do |i|
  pos = i / 32.0

  if hybrid.call(pos) > 0.5
    sample :bd_tek
  end
  sleep 0.125
end
```

### Temporal Sequence Control

Let curves control which events play and when:

```ruby
# Events progress through array based on curve
events = [:bd_haus, :sn_dolf, :drum_cymbal_closed, :elec_blip]
timing = ease_in(exp: 2)  # Accelerating progression
seq = temporal_sequence(timing, events)

16.times do |i|
  pos = i / 16.0
  event, time_in_event = seq.call(pos)

  # Play event with modulation based on position within event
  sample event,
         amp: 0.5 + time_in_event * 0.3,
         rate: 0.9 + time_in_event * 0.2
  sleep 0.25
end
```

## Theoretical Framework

### Curtis Roads - Sound Objects & Time Scales

**Micro Time (1-100ms):** Individual sample manipulation
- Use `sample_selector()` for timbral morphing
- Modulate rate, pitch, filters with fast curves (`rate: 8-32`)

**Meso Time (100ms-10s):** Phrase and pattern structure
- Use `bernoulli_gate()` and `density_curve()` for event patterns
- Control with medium-speed curves (`rate: 1-4`)

**Macro Time (10s+):** Overall compositional form
- Use `breakpoints()` and `adsr()` for structural envelopes
- Control with slow curves (`rate: 0.1-0.5`)

### Mark Fell - Pattern Synthesis

**Deterministic Rules + Stochasticity + Feedback = Emergent Patterns**

- **Rules:** Define curves that control parameters
- **Stochasticity:** Use `bernoulli_gate()` with position-seeded randomness
- **Feedback:** Nest curves (curves calling curves) for self-similar structures
- **Non-Linear Time:** Variable event density, state-dependent durations

**Key Principle:** Patterns emerge from simple rules applied across multiple time scales with controlled randomness.