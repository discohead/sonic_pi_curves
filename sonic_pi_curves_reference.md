# SonicPiCurves - Quick Reference Guide

## Overview
A Ruby library for generating modulation curves, envelopes, and control signals in Sonic Pi.
All curve functions return lambdas that map position (0-1) to output values (typically 0-1).

## Basic Usage
```ruby
load "~/sonic_pi_curves.rb"
include SonicPiCurves  # or SPCurves for short

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