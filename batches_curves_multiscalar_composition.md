# Batches + Curves: Multiscalar Composition with Sonic Pi

*Exploring Curtis Roads' Time Scales and Mark Fell's Pattern Synthesis Through Algorithmic Sample Manipulation*

---

## Table of Contents

1. [Theoretical Foundations](#i-theoretical-foundations)
2. [Curve Functions: Theoretical Mapping](#ii-curve-functions-theoretical-mapping)
3. [Compositional Workflows: Theory to Practice](#iii-compositional-workflows-theory-to-practice)
4. [Compositional Strategies & Techniques](#iv-compositional-strategies--techniques)
5. [Creative Exercises & Experiments](#v-creative-exercises--experiments)
6. [Technical Reference](#vi-technical-reference)
7. [Philosophical Reflections](#vii-philosophical-reflections)
8. [Further Exploration](#viii-further-exploration)

---

## I. Theoretical Foundations

### A. Curtis Roads: The Architecture of Time

Curtis Roads' work fundamentally challenges how we think about musical time. Rather than conceiving music as a linear sequence of discrete notes on a grid, Roads proposes a **multiscalar model** where musical events exist simultaneously across multiple time scales, each with its own organizational principles.

#### The Nine Time Scales

In *Microsound* (2001), Roads identifies nine distinct time scales from the infinitesimal to the infinite:

1. **Infinite** (years to centuries)
2. **Supra** (hours to days)
3. **Macro** (minutes to hours) - *Overall compositional form*
4. **Meso** (seconds to minutes) - *Phrase structure, sound objects*
5. **Micro** (milliseconds to seconds) - *Sound particles, grains*
6. **Sample** (microseconds) - *Individual samples at sampling rate*
7. **Subsample** (nanoseconds) - *Between samples*
8. **Infinitesimal** (below quantum level)

For composition with batches + curves, we focus on the **triad** of macro, meso, and micro time:

**Macro Time (10 seconds - minutes)**
- **Musical function**: Overall compositional form, sections, large-scale dynamics
- **Curve rates**: 0.1-0.5× (slow evolution)
- **Example**: A sine wave at `rate: 0.25` completes one cycle over four sections
- **Perception**: Sense of arrival, departure, narrative arc

**Meso Time (100 milliseconds - 10 seconds)**
- **Musical function**: Phrase structure, rhythmic patterns, sound objects
- **Curve rates**: 1-4× (medium speed)
- **Example**: A pulse at `rate: 2` creates phrase-level rhythm
- **Perception**: Groove, pattern, musical "events"

**Micro Time (1-100 milliseconds)**
- **Musical function**: Sound particles, timbral modulation, grain manipulation
- **Curve rates**: 8-32× (fast modulation)
- **Example**: A sine at `rate: 16` creates tremolo/vibrato
- **Perception**: Timbre, texture, "sound color"

#### Sound Objects & Transformation

Roads introduces the concept of the **sound object** - a heterogeneous collection of acoustic properties that forms a perceptual unit. Unlike traditional notes (which have pitch, duration, and volume), sound objects can have:

- Multiple spectral components
- Complex amplitude envelopes
- Internal temporal structure
- Spatial location and movement
- Textural qualities

The key compositional insight: **transformation** becomes a primary compositional strategy. Rather than developing themes (repetition + variation), we transform sound objects continuously through parameter space.

With batches + curves, each of the 128 samples in a category represents a point in timbral space. A curve like `ease_in_out(exp: 2)` applied via `sample_selector()` creates a transformation path through this space.

#### Granular/Quantum Perspective

Roads draws on Gabor's concept of "sound quanta" - the idea that sound can be conceived as particles (grains) rather than continuous waves. Key concepts:

- **Grain**: Micro-scale sound particle (typically 1-100ms)
- **Grain cloud**: Collection of grains with statistical distribution
- **Density**: Number of grains per second
- **Distribution**: Spatial and temporal arrangement of grains

In batches + curves composition, high-density event triggering (e.g., 32 events/second with `bernoulli_gate`) creates grain-cloud-like textures without traditional granular synthesis DSP.

**Compositional implication**: Music is not made of notes; it's made of sound particles organized across time scales.

### B. Mark Fell: Pattern Synthesis & Emergent Structure

Mark Fell's compositional practice centers on **pattern synthesis** - the generation of complex rhythmic and timbral patterns from simple algorithmic rules. His work, rooted in house and techno, explores how minimal systems can produce rich, evolving musical structures.

#### Core Compositional Formula

```
Deterministic Rules + Stochasticity + Feedback = Emergent Patterns
```

**Deterministic Rules**: Algorithms that produce predictable output
- In curves: Functions like `sine()`, `pulse()`, `ramp()`
- Create foundation for pattern generation

**Stochasticity**: Controlled randomness
- In curves: `noise()`, `bernoulli_gate()` with position-seeded randomness
- Introduces variation without chaos

**Feedback**: Systems where output influences future input
- In curves: Nested lambdas where one curve modulates another's rate/phase
- Creates self-similar, evolving structures

#### Key Principles

**1. Pattern Synthesis**
Patterns emerge from rule application, not pre-composition. The composer designs the system; the system generates the pattern.

Example: A pulse wave with slowly changing width doesn't sound like "pulse wave" - it sounds like an evolving rhythmic pattern.

**2. Non-Linear Time**
Time doesn't flow uniformly. Key characteristics:
- **Variable event density**: Events cluster and disperse
- **State-dependent durations**: How long something lasts depends on what happened before
- **Nested temporal structures**: Fast patterns modulated by slow patterns

Example: A curve controlling the rate of another curve creates temporal feedback - the pattern speeds up and slows down based on its own history.

**3. Microtemporal Works**
Fell's interest in "short, irregular temporal intervals" as primary rhythmic material. Not traditional grooves, but:
- Rotational micro-patterns
- Non-metric rhythmic structures
- Emphasis on detail over traditional rhythm/meter

**4. Anti-Energy Aesthetic**
Rejecting conventional musical "excitement" - instead, music that "sits at one level and goes on." Characteristics:
- Constant dynamic level
- Slow evolution rather than dramatic change
- Meditation on subtle variation
- Clarity over complexity

**5. House Music Foundation**
All of Fell's work is grounded in house/techno vocabulary:
- 4/4 time signatures (usually)
- Kick drum as anchor
- Synthesized sounds
- Repetitive structures

But explored through unusual rhythmic approaches and microtemporal structures.

#### Algorithmic Practice

Fell typically works in Max/MSP creating:
- Generative systems with changing parameters
- No timeline/grid construction (in solo work)
- Mathematical algorithms + synthesized textures
- Rotational micro-patterns

**Translation to batches + curves**:
- Curves = generative systems
- Position-based (not time-based) = no grid
- Mathematical functions (sine, exponential) = algorithms
- Sample manipulation + curve modulation = texture + pattern

### C. Theoretical Integration: Why Batches + Curves?

The batches sample system + sonic_pi_curves library creates a unique environment for exploring Roads' and Fell's theories. Here's why this combination is theoretically powerful:

#### 1. Functional Composition Matches Theory

**Curves as pure functions** (lambdas mapping position 0-1 → output values):
- Embody Fell's "deterministic rules"
- Enable Roads' transformation chains
- Create predictable yet complex systems

**Position-based design** (all curves accept `pos` 0-1):
- Maps directly to macro/meso/micro via rate parameter
- Enables multiscalar thinking
- Separates time-scale from clock time

**Lambda composition** (curves calling curves):
- Mirrors Roads' nested time scales
- Implements Fell's feedback loops
- Creates self-similar structures

#### 2. Sample System Affordances

**27 categories × 128 samples = rich timbral palette**:
- Each category represents a sound object family
- 128 samples provide continuous morphing space
- Categorical switching = discrete timbral jumps

**Ordered indices enable transformation**:
- `sample_selector(curve)` creates transformation paths
- Linear morphing: `ramp` sweeps through all samples
- Targeted subsets: `sine(amp: 0.3, bias: 0.7)` focuses on bright samples

**High sample count = granular-density operations**:
- Rapid triggering (32+ events/second) simulates grain clouds
- Density control via `bernoulli_gate()` and `density_curve()`
- Statistical distribution through curve shapes

#### 3. Pedagogical Power

**Code makes theory tangible**:
- Abstract concepts (macro/meso/micro) become concrete parameters (rate: 0.25/2/16)
- Immediate sonic feedback reinforces understanding
- Tweak curve, hear result instantly

**Composable functions mirror compositional thinking**:
- `chain(sine, ease_in_out)` = transformation pipeline
- `mix(curve1, 0.5, curve2, 0.5)` = layering/blending
- `behavior_transition(a, b, ramp)` = morphing between states

**Beginner-accessible, expert-scalable**:
- Single curve controlling single parameter = entry point
- Multi-curve, multi-scale composition = advanced territory
- Theory provides roadmap for exploration

---

## II. Curve Functions: Theoretical Mapping

### A. Foundation: Understanding Curves as Time-Scale Controllers

Every curve generator in sonic_pi_curves accepts a `rate` parameter. This parameter is your **time-scale selector**:

| Rate Range | Time Scale | Musical Function | Example |
|------------|-----------|------------------|---------|
| **0.1 - 0.5** | **Macro** | Overall form, section changes | `sine(rate: 0.25)` = 1 cycle per 4-bar section |
| **1 - 4** | **Meso** | Phrase structure, pattern evolution | `pulse(rate: 2)` = 2 on/off cycles per phrase |
| **8 - 32** | **Micro** | Timbral modulation, tremolo | `sine(rate: 16)` = 16 vibrato cycles |

**Key insight**: The same mathematical function (`sine`) operates at different time scales simply by changing one parameter.

### B. Core Curve Generators Mapped to Theory

#### 1. Periodic Waveforms (Meso → Micro)

**Functions**: `sine()`, `triangle()`, `saw()`, `ramp()`, `pulse()`

**Curtis Roads perspective**:
- **Meso scale** (rate: 1-4): Create repeating sound object patterns
  - `pulse(width: 0.25, rate: 4)` = rhythmic gate, 4 cycles per phrase
  - `sine(rate: 2)` = phrase-level swell/fade, 2 cycles per phrase
- **Micro scale** (rate: 8-32): Timbral modulation
  - `sine(rate: 16)` = amplitude tremolo
  - `triangle(rate: 12)` = filter sweep

**Mark Fell perspective**:
- Foundation for deterministic rhythmic patterns
- Pulse waves = binary rhythmic gates
- Sine/triangle = smooth probability evolution
- Phase parameter = polyrhythmic offsets

**Usage examples**:

```ruby
# Meso: Phrase-level rhythmic gate
phrase_gate = pulse(width: 0.3, rate: 2)

# Micro: Fast timbral modulation
tremolo = sine(rate: 16, amp: 0.3, bias: 0.7)  # Amplitude varies 0.4-1.0

# Polyrhythm via phase offsets
kick_pattern = pulse(width: 0.25, rate: 4, phase: 0.0)
snare_pattern = pulse(width: 0.25, rate: 2, phase: 0.5)  # Offset by half
```

**What to listen for**:
- Meso rates (1-4): Perceivable rhythm and pattern
- Micro rates (8-32): Timbral color, texture, "shimmer"
- Phase offsets: Interlocking rhythmic layers

#### 2. Easing Curves (Macro → Meso)

**Functions**: `ease_in(exp:)`, `ease_out(exp:)`, `ease_in_out(exp:)`, `ease_out_in(exp:)`

**Curtis Roads perspective**:
- **Macro scale**: Shape overall compositional form
  - `ease_in(exp: 3)` over 2 minutes = slow build to climax
  - `ease_out(exp: 4)` = quick attack, long decay
- **Meso scale**: Phrase contours and section transitions
  - `ease_in_out(exp: 2)` over 8 bars = phrase arc

**Mark Fell perspective**:
- Non-linear time - accelerating/decelerating event density
- Smooth state transitions
- Natural-feeling parameter evolution

**Usage examples**:

```ruby
# Macro: Overall compositional arc
macro_form = ease_in_out(exp: 2)  # S-curve: quiet → loud → quiet

# Meso: Section transition
section_transition = ease_in(exp: 3)  # Slowly accelerating

# Controlling event density
density = ease_in(exp: 2)
gate = bernoulli_gate(density)  # Events become more frequent
```

**Exponent parameter effects**:
- `exp: 1` = linear (sounds like it accelerates due to perception)
- `exp: 2` = moderate curve (natural feeling)
- `exp: 3-4` = strong curve (dramatic acceleration/deceleration)
- Higher exponents = more extreme curves

**What to listen for**:
- Ease-in: Gradual emergence, building tension
- Ease-out: Quick arrival, long settling
- Ease-in-out: Natural phrase shape (like a breath)

#### 3. Stochastic Generators (All Scales)

**Function**: `noise(low:, high:, mode:)`

**Curtis Roads perspective**:
- Introduces quantum uncertainty at any time scale
- **Macro** (slow rate): Formal drift and long-term variation
- **Meso** (medium rate): Pattern irregularity
- **Micro** (fast rate): Timbral roughness, grain cloud scatter

**Mark Fell perspective**:
- Stochastic element in otherwise deterministic systems
- Creates variation without losing pattern coherence
- Mode parameter (triangular distribution) biases randomness

**Usage examples**:

```ruby
# Macro: Slow drift of overall intensity
macro_drift = noise(low: 0.3, high: 0.8, mode: 0.5)  # Centered distribution

# Meso: Irregular pattern variation
pattern_variation = noise(low: 0, high: 1, mode: 0.2)  # Biased toward low

# Micro: Sample selection with slight randomness
sample_scatter = noise(low: 0.45, high: 0.55)  # ±5% around midpoint

# Combined with deterministic curve
complex_prob = mix(
  sine(rate: 1), 0.7,     # 70% deterministic swell
  noise(mode: 0.3), 0.3   # 30% random variation
)
```

**Mode parameter** (triangular distribution):
- `mode: nil` = uniform distribution (equal probability)
- `mode: 0.0` = biased toward `low` value
- `mode: 0.5` = centered (most values near middle)
- `mode: 1.0` = biased toward `high` value

**What to listen for**:
- Uniform noise: Unpredictable, scattered
- Triangular (mode: 0.5): More coherent, centered around middle
- Mixed with sine: Organic variation on cyclic pattern

#### 4. Envelopes (Macro Scale)

**Functions**: `adsr(attack:, decay:, sustain:, release:)`, `breakpoints(...)`

**Curtis Roads perspective**:
- Define macro-scale formal architecture
- Multi-section compositions with clear boundaries
- Narrative structures (beginning → middle → end)

**Mark Fell perspective**:
- Structural containers for pattern evolution
- Overall dynamic envelope within which patterns unfold
- Anti-energy: Often flat sustain with subtle variations

**Usage examples**:

```ruby
# ADSR: Classic envelope shape
envelope = adsr(
  attack: 2,           # 2-beat build
  decay: 1,            # 1-beat decay
  sustain: 4,          # 4-beat sustain
  release: 1,          # 1-beat release
  sustain_level: 0.8   # Sustain at 80%
)

# Breakpoints: Custom multi-section form
form = breakpoints(
  [0.0, 0.1],                    # Section 1: Sparse (10% intensity)
  [0.2, 0.8, ease_in(exp: 2)],   # Section 2: Build (ease in to 80%)
  [0.5, 1.0],                    # Section 3: Peak (100% intensity)
  [0.7, 0.6, ease_out(exp: 3)],  # Section 4: Breakdown (ease out to 60%)
  [1.0, 0.2]                     # Section 5: Outro (20%)
)

# Use envelope to scale all other parameters
64.times do |i|
  pos = i / 64.0
  intensity = form.call(pos)

  # Everything follows the form
  sample :bd_haus,
         amp: intensity * 0.8,
         rate: 0.8 + intensity * 0.4
  sleep 0.25
end
```

**Breakpoints curve functions**:
Each breakpoint can specify a curve function for transition to next point:
- No function = linear interpolation
- `ease_in` = slow start, fast arrival
- `ease_out` = fast departure, slow arrival
- `sine` = smooth, wave-like transition

**What to listen for**:
- Clear sectional boundaries
- Sense of narrative (intro → development → conclusion)
- Parameters following envelope shape

### C. New Functions: Pattern Synthesis Tools

#### 1. Probability & Gating (Meso Time - Event Structure)

##### bernoulli_gate(prob_curve)

**Returns**: `1.0` when event should fire, `0.0` otherwise
**Randomness**: Position-seeded (deterministic - same position always gives same result)

**Curtis Roads perspective**:
- Controls grain cloud density
- Probability of sound object occurrence
- Statistical distribution of micro-events

**Mark Fell perspective**:
- Core tool for stochastic pattern synthesis
- Deterministic randomness = repeatable "chance"
- Non-metronomic rhythms from smooth curves

**Key insight**: Position-seeded randomness means the pattern is deterministic (run the code twice, get the same pattern) but feels random. This is Fell's "deterministic + stochastic" formula in action.

**Usage examples**:

```ruby
# Simple: Increasing probability
gate = bernoulli_gate(ramp)  # Probability increases from 0 to 1

32.times do |i|
  pos = i / 32.0
  if gate.call(pos) > 0.5
    sample :bd_haus
  end
  sleep 0.125
end
# Result: Events become more frequent over time

# Breathing rhythm: Swell and fade
density = sine(rate: 0.5, amp: 0.5, bias: 0.5)  # 0-1 range
gate = bernoulli_gate(density)

64.times do |i|
  pos = i / 64.0
  if gate.call(pos) > 0.5
    sample :drum_heavy_kick, amp: 0.7
  end
  sleep 0.125
end
# Result: Organic, breathing pattern

# Complex: Multi-curve probability
prob_curve = mix(
  pulse(width: 0.6, rate: 2), 0.6,      # 60% regular pulse
  noise(low: 0, high: 0.4), 0.4         # 40% random scatter
)
gate = bernoulli_gate(prob_curve)
# Result: Pulsing pattern with organic variation
```

**What to listen for**:
- How curve shape creates rhythmic character
- Same position = same trigger (determinism)
- Non-grid-based feel (human-like timing)

##### schmitt_gate(curve, threshold_low:, threshold_high:)

**Returns**: `1.0` or `0.0` with hysteresis
**State**: Maintained between calls (not purely functional)

**Purpose**: Prevents jittery triggering when curve hovers near a threshold.

**How hysteresis works**:
- Gate turns ON when curve crosses `threshold_high`
- Gate turns OFF when curve crosses `threshold_low`
- Between thresholds: maintains previous state

**Usage example**:

```ruby
# Problem: wobbly curve crosses threshold multiple times
wobbly = mix(sine(rate: 1), 0.7, noise, 0.3)

# Without schmitt gate - jittery triggers
32.times do |i|
  pos = i / 32.0
  if wobbly.call(pos) > 0.5  # Might trigger multiple times near 0.5
    sample :bd_tek
  end
  sleep 0.125
end

# With schmitt gate - clean on/off
stable_gate = schmitt_gate(wobbly, threshold_low: 0.4, threshold_high: 0.6)

32.times do |i|
  pos = i / 32.0
  if stable_gate.call(pos) > 0.5
    sample :bd_tek  # Clean, no double-triggers
  end
  sleep 0.125
end
```

**When to use**:
- Curves with noise components
- Slow-moving curves near thresholds
- Preventing rapid on/off switching

#### 2. Categorical Selection (Meso Time - Timbral Categories)

##### categorical_sample(curve, options)

**Returns**: Element from `options` array based on curve value (0-1)

**Curtis Roads perspective**:
- Select between discrete sound object types
- Jump between timbral categories
- Categorical rather than continuous transformation

**Mark Fell perspective**:
- Deterministic switching between pattern vocabularies
- Discrete state changes in pattern synthesis

**Usage examples**:

```ruby
# Simple: Linear progression through categories
categories = [:kck, :snr, :hat, :clp]
selector = categorical_sample(ramp, categories)

16.times do |i|
  pos = i / 16.0
  category = selector.call(pos)  # Returns :kck, then :snr, then :hat, then :clp
  sample category
  sleep 0.25
end

# Sequencer-based selection
cat_sequence = sequencer([0, 0.33, 0.66, 1.0])  # Stepped progression
selector = categorical_sample(cat_sequence, [:bd_haus, :sn_dolf, :drum_cymbal_closed, :elec_blip])

# With batches - category sequencing
categories = [:kck, :snr, :hat]
cat_curve = pulse(width: 0.33, rate: 3)  # 3 states cycling
selector = categorical_sample(cat_curve, categories)

16.times do |i|
  pos = i / 16.0
  cat = selector.call(pos)

  # Play sample from selected category
  sample "#{batches_path(cat)}#{cat}_064.wav", amp: 0.7
  sleep 0.25
end
```

**Curve shape effects**:
- `ramp`: Linear progression through options
- `sequencer()`: Stepped selection (abrupt changes)
- `sine()`: Smooth cycling through options
- `pulse()`: Binary switching between two options (if 2 elements)

**What to listen for**:
- Discrete vs. smooth transitions
- Rhythmic pattern of category changes
- Timbral jumps vs. morphing

#### 3. Sample Morphing (Micro Time - Continuous Timbre)

##### sample_selector(curve, num_samples: 128)

**Returns**: Integer index (0 to num_samples-1) for sample selection

**Curtis Roads perspective**:
- Sound transformation through timbral continuum
- 128 samples perceived as continuous morphing space
- Quantum (discrete samples) perceived as continuous

**Mark Fell perspective**:
- Smooth parameter evolution
- Timbral exploration through deterministic path

**Key insight**: With 128 samples, index changes are small enough that morphing feels continuous, not discrete.

**Usage examples**:

```ruby
# Linear sweep through all samples
morph = ramp
selector = sample_selector(morph, num_samples: 128)

16.times do |i|
  pos = i / 16.0
  idx = selector.call(pos)  # Returns 0→127 linearly

  sample "#{batches_path(:kck)}kck_#{idx.to_s.rjust(3, '0')}.wav"
  sleep 0.25
end
# Result: Smooth timbral evolution through entire kick library

# S-curve morph (natural feeling)
morph = ease_in_out(exp: 2)
selector = sample_selector(morph, num_samples: 128)
# Result: Slow start, fast middle, slow end - feels organic

# Focus on subset (bright samples only)
bright_curve = ramp(amp: 0.3, bias: 0.7)  # Output range: 0.7-1.0
selector = sample_selector(bright_curve, num_samples: 128)
# Result: Only plays samples 90-127 (brightest)

# Oscillating timbre
oscillate = sine(rate: 2)
selector = sample_selector(oscillate, num_samples: 128)
# Result: Timbre swells and fades, 2 cycles
```

**Amp/bias for range control**:
```ruby
# Target specific sample range
selector = sample_selector(
  ramp(amp: 0.5, bias: 0.5),  # Output: 0.5-1.0
  num_samples: 128
)
# Result: Samples 64-127 only
```

**What to listen for**:
- Smooth timbral evolution (not discrete jumps)
- Curve shape affects perception of transformation
- Fast rates (micro scale) create timbral vibrato

#### 4. Density Control (Meso Time - Event Probability)

##### density_curve(base_rate, density_curve)

**Returns**: `1.0` when event should fire, `0.0` otherwise
**Parameters**:
- `base_rate`: Maximum events per cycle (e.g., 4 = up to 4 events)
- `density_curve`: 0-1 curve controlling density

**Curtis Roads perspective**:
- Grain cloud density control
- Statistical distribution of sound particles
- Density as compositional parameter

**Mark Fell perspective**:
- Event density as primary pattern parameter
- Fills and breaks through density modulation

**Usage examples**:

```ruby
# Increasing density over time
density = ramp  # 0 to 1
events = density_curve(4, density)  # Up to 4 events, modulated by ramp

32.times do |i|
  pos = i / 32.0
  if events.call(pos) > 0.5
    sample :bd_haus
  end
  sleep 0.125
end
# Result: Starts sparse, becomes dense (approaching 4 events per cycle)

# Breathing density (swelling and fading)
breath = sine(rate: 0.5, amp: 0.5, bias: 0.5)
events = density_curve(8, breath)

64.times do |i|
  pos = i / 64.0
  if events.call(pos) > 0.5
    sample :drum_cymbal_closed, amp: 0.4
  end
  sleep 0.0625  # Fast (16 potential events/second)
end
# Result: Shimmering hi-hat texture that breathes

# Grain cloud texture
cloud_density = mix(
  sine(rate: 0.5), 0.6,        # Slow swell
  noise(low: 0, high: 0.3), 0.4  # Random variation
)
events = density_curve(32, cloud_density)  # Very high potential density

128.times do |i|
  pos = i / 128.0
  if events.call(pos) > 0.5
    sample "#{batches_path(:atm)}atm_#{(pos * 127).round.to_s.rjust(3, '0')}.wav",
           amp: 0.2,
           rate: rand(0.5..1.5),
           pan: rand(2) - 1
  end
  sleep 0.03125  # 32 events/second
end
# Result: Granular-style cloud texture
```

**What to listen for**:
- Relationship between density and texture
- High density (>16 events/sec) = grain cloud
- Medium density (4-8 events/sec) = rhythmic fills
- Low density (<2 events/sec) = sparse pattern

#### 5. Temporal Sequencing (Meso → Macro Transition)

##### temporal_sequence(timing_curve, events)

**Returns**: `[event, position_in_event]` tuple
**Parameters**:
- `timing_curve`: Controls progression through events (0-1)
- `events`: Array of event values

**Curtis Roads perspective**:
- Organize sound objects into larger structures
- Meso-scale (individual events) → Macro-scale (sequence)
- Time-stretching/compressing via curve shape

**Mark Fell perspective**:
- Non-linear event progression
- Accelerating/decelerating through sequence

**Usage examples**:

```ruby
# Linear progression through events
events = [:bd_haus, :sn_dolf, :drum_cymbal_closed, :elec_blip]
timing = ramp
seq = temporal_sequence(timing, events)

16.times do |i|
  pos = i / 16.0
  event, time_in_event = seq.call(pos)

  sample event, amp: 0.5 + time_in_event * 0.3
  sleep 0.25
end
# Result: Plays each event for 4 beats

# Accelerating through events
timing = ease_in(exp: 2)  # Slow start, fast end
seq = temporal_sequence(timing, events)
# Result: First event lasts longer, last event shorter

# With batches categories
categories = [:kck, :snr, :hat, :clp]
timing = sine(rate: 0.5)  # Oscillate through sequence
seq = temporal_sequence(timing, categories)

32.times do |i|
  pos = i / 32.0
  cat, time_in_cat = seq.call(pos)

  # Sample index based on position within category
  idx = (time_in_cat * 127).round

  sample "#{batches_path(cat)}#{cat}_#{idx.to_s.rjust(3, '0')}.wav"
  sleep 0.125
end
# Result: Cycles through categories, morphing within each
```

**What to listen for**:
- `time_in_event` progresses 0→1 while in each event
- Curve shape determines event duration distribution
- Can use `time_in_event` to modulate parameters within event

#### 6. Behavior Transition (All Scales)

##### behavior_transition(start_behavior, end_behavior, transition_curve)

**Returns**: Crossfaded value between start and end
**Parameters**:
- `start_behavior`: Curve or static value (active when transition=0)
- `end_behavior`: Curve or static value (active when transition=1)
- `transition_curve`: Controls crossfade (0=start, 1=end)

**Curtis Roads perspective**:
- Sound transformation between states
- Morphing between different organizational principles
- Meso→Macro: Pattern evolution over time

**Mark Fell perspective**:
- Pattern morphing
- Smooth state changes
- Combining multiple pattern vocabularies

**Key insight**: Can crossfade between ANY curves or values - not just static numbers.

**Usage examples**:

```ruby
# Morph between two rhythmic patterns
pattern_a = pulse(width: 0.25, rate: 4)       # Regular house kick
pattern_b = pulse(width: 0.15, rate: 6, phase: 0.1)  # Syncopated breaks

transition = ramp  # Linear morph
hybrid = behavior_transition(pattern_a, pattern_b, transition)

32.times do |i|
  pos = i / 32.0
  if hybrid.call(pos) > 0.5
    sample :bd_tek
  end
  sleep 0.125
end
# Result: Smoothly morphs from pattern A to pattern B

# Morph between sample selection strategies
select_a = const(value: 0.3)  # Always sample 38
select_b = ramp                # Sweep through samples
transition = ease_in_out(exp: 2)

hybrid_select = behavior_transition(select_a, select_b, transition)
selector = sample_selector(hybrid_select, num_samples: 128)

16.times do |i|
  pos = i / 16.0
  idx = selector.call(pos)
  sample "#{batches_path(:kck)}kck_#{idx.to_s.rjust(3, '0')}.wav"
  sleep 0.25
end
# Result: Starts on one sample, then begins morphing

# Morph between densities
sparse = const(value: 0.2)
dense = const(value: 0.9)
transition = sine(rate: 0.25)  # Cycle between sparse and dense

density_morph = behavior_transition(sparse, dense, transition)
gate = bernoulli_gate(density_morph)
# Result: Density oscillates between 20% and 90%
```

**What to listen for**:
- Smooth vs. abrupt transitions (depends on transition curve)
- How different behaviors blend in the middle
- Pattern identity emerging from combination

### D. Composition Tools (Cross-Scale)

#### 1. Curve Chaining

##### chain(curve1, curve2, curve3, ...)

**Function**: Serial curve composition - output of one curve becomes input to next

**Curtis Roads perspective**:
- Nested time-scale operations
- Fast curve shaped by slow curve
- Multi-level transformation

**Mark Fell perspective**:
- Feedback loops in pattern synthesis
- Self-modulating systems

**Usage examples**:

```ruby
# Simple: Sine shaped by easing
wobble = chain(
  sine(rate: 4),        # Fast oscillation (output 0-1)
  ease_in_out(exp: 2)   # S-curve shaping
)
# Result: Sine wave with emphasized center, de-emphasized edges

# Complex: Multi-stage transformation
complex = chain(
  sine(rate: 8),           # Fast micro-scale oscillation
  ease_out(exp: 3),        # Shape the oscillation
  lambda { |v| v * 0.6 + 0.2 }  # Scale to 0.2-0.8 range
)

# Nested time scales
micro = sine(rate: 16)
meso = pulse(width: 0.5, rate: 2)
nested = chain(micro, meso)
# Result: Fast sine only appears during pulse-on periods
```

**What to listen for**:
- How later curves shape earlier curves
- Can create complex modulation from simple components
- Order matters: `chain(a, b)` ≠ `chain(b, a)`

#### 2. Curve Mixing

##### mix(curve1, weight1, curve2, weight2, ...)

**Function**: Weighted sum of multiple curves

**Curtis Roads perspective**:
- Multi-scale superposition
- Layering time scales
- Complex modulation from simple components

**Mark Fell perspective**:
- Layered pattern complexity
- Combining deterministic + stochastic

**Usage examples**:

```ruby
# Deterministic + stochastic
organic = mix(
  sine(rate: 1), 0.7,      # 70% smooth swell
  noise(mode: 0.3), 0.3    # 30% random scatter
)
# Result: Mostly predictable with organic variation

# Multi-scale layering
complex_mod = mix(
  sine(rate: 0.5), 0.4,    # Slow macro swell (40%)
  triangle(rate: 4), 0.3,  # Fast meso pulse (30%)
  noise, 0.3               # Micro variation (30%)
)

# Equal mix (weights default to 1.0 each)
balanced = mix(sine(rate: 1), triangle(rate: 2), saw(rate: 4))
# Result: 33% each, sum to 1.0
```

**Weight normalization**:
Weights are automatically normalized to sum to 1.0:
```ruby
mix(a, 2, b, 3, c, 5)  # Weights: 2+3+5 = 10
# Actual weights: a=0.2, b=0.3, c=0.5
```

**What to listen for**:
- How curves blend (additive, not multiplicative)
- Weight balance affects character
- High-frequency components add texture to low-frequency base

---

## III. Compositional Workflows: Theory to Practice

This section provides a progressive learning path from single time-scale explorations (beginner) through expert-level multi-scale composition. Each level builds on the previous, introducing new theoretical concepts and compositional techniques.

### A. Beginner Level: Single Time-Scale Explorations

**Learning goal**: Understand curve behavior at one time scale before composing across scales.

---

#### Exercise 1: Micro Time - Sample Morphing

**Concept**: Continuous timbral transformation (Roads' sound object transformation)

**Theory**: At the micro time scale (1-100ms), we're concerned with timbral quality - the "color" of sound. By morphing through samples continuously, we experience Roads' concept of sound transformation: a single sound object evolving through parameter space.

##### Exercise 1.1: Linear Sample Sweep

```ruby
# Load library
load "~/sonic_pi_curves.rb"
include SonicPiCurves

# Define batches path helper
define :batches_path do |category|
  "/Users/jaredmcfarland/Music/Samples/batches_dirt/#{category}/"
end

# Linear morph through all 128 kicks
morph = ramp  # 0→1 linear progression
selector = sample_selector(morph, num_samples: 128)

16.times do |i|
  pos = i / 16.0
  idx = selector.call(pos)  # Returns 0→127

  sample "#{batches_path(:kck)}kck_#{idx.to_s.rjust(3, '0')}.wav",
         amp: 0.7,
         rate: 1.0

  sleep 0.25
end
```

**What to listen for**:
- Smooth timbral evolution (not discrete jumps)
- Perceive sample library as a continuum
- 128 samples feel "continuous"

**Theory connection**: Roads' quantum/continuous duality - discrete samples (quantum) perceived as continuous transformation when changes are small enough.

##### Exercise 1.2: Curved Sample Sweep

```ruby
# Try different curve shapes to hear transformation character

# S-curve: natural feeling (slow→fast→slow)
morph_s = ease_in_out(exp: 2)
selector_s = sample_selector(morph_s, num_samples: 128)

# Exponential: accelerating transformation
morph_exp = ease_in(exp: 3)
selector_exp = sample_selector(morph_exp, num_samples: 128)

# Logarithmic: quick change then settling
morph_log = ease_out(exp: 3)
selector_log = sample_selector(morph_log, num_samples: 128)

# Compare all three
[selector_s, selector_exp, selector_log].each do |selector|
  16.times do |i|
    pos = i / 16.0
    idx = selector.call(pos)
    sample "#{batches_path(:snr)}snr_#{idx.to_s.rjust(3, '0')}.wav"
    sleep 0.25
  end
  sleep 1  # Pause between curves
end
```

**Learning**: Curve shape dramatically affects perception of transformation rate. Linear ramp (mathematically linear) feels like it accelerates. S-curve (ease_in_out) feels natural.

##### Exercise 1.3: Oscillating Timbre

```ruby
# Micro-scale modulation: fast timbral vibrato
oscillate = sine(rate: 2)  # 2 complete cycles
selector = sample_selector(oscillate, num_samples: 128)

live_loop :timbral_vibrato do
  32.times do |i|
    pos = i / 32.0
    idx = selector.call(pos)

    sample "#{batches_path(:atm)}atm_#{idx.to_s.rjust(3, '0')}.wav",
           amp: 0.5,
           rate: 1.0,
           attack: 0.01,
           release: 0.2

    sleep 0.125
  end
end
```

**What to listen for**:
- Timbre oscillates (bright→dark→bright)
- Creates textural variation
- 2 complete cycles per loop

---

#### Exercise 2: Meso Time - Rhythmic Pattern Control

**Concept**: Probability-based pattern synthesis (Fell's stochastic rules)

**Theory**: At the meso time scale (100ms-10s), we're concerned with phrase structure and rhythmic patterns. Using `bernoulli_gate` with evolving curves, we create non-metronomic rhythms that feel organic yet are deterministic.

##### Exercise 2.1: Breathing Rhythm

```ruby
# Density swells and fades like breathing
density = sine(rate: 0.5, amp: 0.5, bias: 0.5)  # Output: 0-1
gate = bernoulli_gate(density)

live_loop :breathing do
  32.times do |i|
    pos = i / 32.0

    if gate.call(pos) > 0.5
      sample :bd_haus, amp: 0.8
    end

    sleep 0.125
  end
end
```

**What to listen for**:
- Organic, non-metronomic feel
- Pattern never exactly repeats (stochastic)
- But pattern IS repeatable (deterministic - same pos = same result)
- Swells and fades like breath

**Theory connection**: Fell's deterministic randomness - the pattern is generated by a rule, feels random, but is actually repeatable. This is the "stochastic + deterministic" formula in action.

##### Exercise 2.2: Pattern Vocabulary Comparison

```ruby
# Try different density curves, notice rhythmic character

densities = {
  pulse_pattern: pulse(width: 0.25, rate: 2),
  breathing: sine(rate: 0.5, amp: 0.5, bias: 0.5),
  building: ramp,
  decaying: saw,
  chaotic: noise(mode: 0.3)
}

densities.each do |name, curve|
  puts "Pattern: #{name}"
  gate = bernoulli_gate(curve)

  32.times do |i|
    pos = i / 32.0
    if gate.call(pos) > 0.5
      sample :sn_dolf, amp: 0.7
    end
    sleep 0.125
  end

  sleep 0.5  # Pause between patterns
end
```

**Learning**: Each curve creates a distinct rhythmic character:
- Pulse: Binary, on/off sections
- Breathing (sine): Organic swell/fade
- Building (ramp): Increasing density
- Decaying (saw): Decreasing density
- Chaotic (noise): Scattered, unpredictable

---

#### Exercise 3: Macro Time - Formal Architecture

**Concept**: Large-scale compositional structure (Roads' macro time)

**Theory**: At the macro time scale (10s-minutes), we're concerned with overall form - the large-scale architecture that gives a piece its narrative shape. Multi-section envelopes define this structure.

##### Exercise 3.1: Simple Three-Section Form

```ruby
# Intro → Peak → Outro
form = breakpoints(
  [0.0, 0.2],                 # Section 1: Quiet intro (20%)
  [0.4, 0.8, ease_in(exp: 2)], # Section 2: Build (ease in to 80%)
  [0.6, 1.0],                 # Section 3: Peak (100%)
  [1.0, 0.3, ease_out(exp: 3)] # Section 4: Outro (ease out to 30%)
)

live_loop :macro_form do
  64.times do |i|
    pos = i / 64.0
    intensity = form.call(pos)

    sample :bd_haus,
           amp: intensity * 0.8,
           rate: 0.8 + intensity * 0.4

    sleep 0.25
  end
  stop  # Play once
end
```

**What to listen for**:
- Perceivable sections (intro/build/peak/outro)
- Sense of arrival (peak) and departure (outro)
- Smooth vs. abrupt transitions (controlled by curve functions)

**Theory connection**: Roads' macro scale - minutes-long formal architecture perceived as overall "shape" of the piece.

##### Exercise 3.2: Five-Section Form with Complex Transitions

```ruby
# More complex formal structure
form = breakpoints(
  [0.0, 0.1],                      # 1. Sparse intro
  [0.15, 0.5, ease_in(exp: 3)],    # 2. Quick build
  [0.4, 0.9],                      # 3. First peak (sustained)
  [0.5, 0.4, ease_out(exp: 2)],    # 4. Breakdown (ease out)
  [0.7, 1.0, ease_in(exp: 4)],     # 5. Final build (dramatic)
  [0.9, 1.0],                      # 6. Final peak (sustained)
  [1.0, 0.2, ease_out(exp: 3)]     # 7. Outro (gentle)
)

live_loop :complex_form do
  128.times do |i|
    pos = i / 128.0
    intensity = form.call(pos)

    # Multiple layers following same form
    sample :bd_haus, amp: intensity * 0.8 if i % 4 == 0
    sample :sn_dolf, amp: intensity * 0.6 if intensity > 0.5 && i % 8 == 4
    sample :drum_cymbal_closed, amp: intensity * 0.4 if intensity > 0.7

    sleep 0.125
  end
  stop
end
```

**What to listen for**:
- Multiple sections with clear boundaries
- Different transition characters (quick build vs. gentle outro)
- Layers entering/leaving based on intensity

---

### B. Intermediate Level: Two-Scale Coordination

**Learning goal**: Coordinate micro/meso or meso/macro interactions.

---

#### Exercise 4: Micro + Meso - Modulated Timbral Evolution

**Concept**: Fast modulation shaped by slow envelope (Roads' nested time scales)

**Theory**: Micro-scale phenomena (fast timbral changes) are shaped by meso-scale envelopes. The fast doesn't exist independently - it's modulated by the slow.

##### Exercise 4.1: Wobbling Timbre with Envelope

```ruby
# MICRO: Fast rate modulation
micro_wobble = sine(rate: 8)  # 8 cycles = fast tremolo

# MESO: Slow envelope shapes wobble intensity
meso_env = adsr(attack: 2, decay: 1, sustain: 4, release: 1)

live_loop :wobble_bass do
  64.times do |i|
    pos = i / 64.0

    # Wobble depth controlled by envelope
    wobble_depth = meso_env.call(pos)
    wobble_amount = micro_wobble.call(pos) * wobble_depth * 0.5
    rate_mod = 1.0 + wobble_amount

    sample "#{batches_path(:kck)}kck_064.wav",
           rate: rate_mod,
           amp: 0.7,
           release: 0.15

    sleep 0.125
  end
  stop
end
```

**What to listen for**:
- Fast wobble that grows and shrinks
- Envelope shapes the intensity of the wobble
- Two time scales interacting: fast (8 cycles) shaped by slow (1 cycle)

**Theory connection**: Roads' micro-meso interaction - "fast phenomena shaped by slower structural curves"

##### Exercise 4.2: Sample Morphing with Phrase-Level Control

```ruby
# MICRO: Sample selection (timbral change)
# MESO: Phrase envelope controlling morph range

meso_envelope = pulse(width: 0.5, rate: 2)  # 2 phrases: on/off

live_loop :phrase_controlled_morph do
  32.times do |i|
    pos = i / 32.0

    # Meso-scale controls which subset of samples
    phrase_state = meso_envelope.call(pos)

    if phrase_state > 0.5
      # Phrase ON: use bright samples (64-127)
      micro_curve = ramp(amp: 0.5, bias: 0.5)
    else
      # Phrase OFF: use dark samples (0-63)
      micro_curve = ramp(amp: 0.5, bias: 0.0)
    end

    idx = sample_selector(micro_curve, num_samples: 128).call(pos % (1.0/2.0) * 2)

    sample "#{batches_path(:snr)}snr_#{idx.to_s.rjust(3, '0')}.wav",
           amp: 0.6

    sleep 0.125
  end
end
```

**What to listen for**:
- Phrases have different timbral character (bright vs. dark)
- Within each phrase, smooth morphing occurs
- Phrase structure (meso) controls timbral space (micro)

---

#### Exercise 5: Meso + Macro - Event Density Across Form

**Concept**: Pattern density follows compositional arc (Fell + Roads integration)

**Theory**: Meso-scale patterns (rhythmic density) are modulated by macro-scale form (overall intensity arc). Local pattern follows global structure.

##### Exercise 5.1: Formal Density Evolution

```ruby
# MACRO: Overall intensity arc
macro_form = breakpoints(
  [0.0, 0.2],                   # Sparse intro
  [0.4, 1.0, ease_in(exp: 2)],  # Build to full
  [0.7, 0.8],                   # Slight decline
  [1.0, 0.1, ease_out(exp: 3)]  # Wind down
)

# MESO: Phrase-level pattern
meso_pattern = pulse(width: 0.3, rate: 2)

# COMBINE: Density follows macro, pulsed by meso
combined = lambda do |pos|
  macro_form.call(pos) * meso_pattern.call(pos)
end

gate = bernoulli_gate(combined)

live_loop :density_evolution do
  128.times do |i|
    pos = i / 128.0

    if gate.call(pos) > 0.5
      # Sample selection also follows macro
      intensity = macro_form.call(pos)
      idx = (intensity * 127).round

      sample "#{batches_path(:snr)}snr_#{idx.to_s.rjust(3, '0')}.wav",
             amp: intensity * 0.6
    end

    sleep 0.0625
  end
  stop
end
```

**What to listen for**:
- Overall density arc (sparse → dense → sparse)
- Within each section, pulsing meso-level rhythm
- Timbre following same intensity arc
- Three layers: macro (form), meso (pattern), micro (sample selection)

**Theory connection**: Fell's nested structures - local pattern modulated by global form

---

### C. Advanced Level: Three-Scale Composition

**Learning goal**: Coordinate micro, meso, macro simultaneously (Roads' complete model)

---

#### Exercise 6: Full Multiscalar Synthesis

**Concept**: Roads' complete time-scale hierarchy in action

**Theory**: Music is organized simultaneously at micro (timbre), meso (pattern), and macro (form) scales. All three scales interact to create complex, evolving textures.

##### Exercise 6.1: Textural Composition

```ruby
# MACRO: 3-section form (sparse → dense → sparse)
macro = breakpoints(
  [0.0, 0.1],                       # Section 1: Very sparse
  [0.3, 0.9, ease_in(exp: 2)],      # Section 2: Build dramatically
  [0.6, 1.0],                       # Section 3: Full density
  [1.0, 0.2, ease_out(exp: 3)]      # Section 4: Dissolve
)

# MESO: Phrase-level density pulse
meso = pulse(width: 0.6, rate: 1.5)

# MICRO: Sample playback variation (fast)
micro = sine(rate: 16)

live_loop :multiscalar do
  256.times do |i|
    pos = i / 256.0

    # Calculate values at each scale
    macro_val = macro.call(pos)
    meso_val = meso.call(pos)
    micro_val = micro.call(pos)

    # MESO controls event probability, scaled by MACRO
    trigger_prob = macro_val * meso_val

    if bernoulli_gate(trigger_prob).call(pos) > 0.5
      # MACRO controls sample selection (timbral evolution)
      sample_idx = (macro_val * 127).round

      # MICRO controls playback rate (timbral modulation)
      rate_mod = 0.8 + micro_val * 0.4

      sample "#{batches_path(:atm)}atm_#{sample_idx.to_s.rjust(3, '0')}.wav",
             rate: rate_mod,
             amp: macro_val * 0.4,
             pan: rand(2) - 1,
             attack: 0.01,
             release: rand(0.1..0.3)
    end

    sleep 0.03125  # 32 events/second (micro-temporal)
  end
  stop
end
```

**What to listen for**:
- **Macro**: Overall textural density arc (sparse → dense → sparse)
- **Meso**: Pulsing phrase structure (density swells within sections)
- **Micro**: Shimmering timbral details (fast rate modulation, sample evolution)
- Three scales perceivable simultaneously

**Theory connection**: Roads' complete model - "perceivable organization across all time scales simultaneously"

---

#### Exercise 7: Pattern Morphing (Fell-Style)

**Concept**: Smooth transition between distinct pattern behaviors

**Theory**: Fell's pattern synthesis through behavior transition - two different rhythmic identities morphing into hybrid states.

##### Exercise 7.1: Morphing Rhythmic Patterns

```ruby
# PATTERN A: Regular house kick pattern (4-on-the-floor)
pattern_a = pulse(width: 0.25, rate: 4)

# PATTERN B: Syncopated breaks pattern
pattern_b = mix(
  pulse(width: 0.15, rate: 6, phase: 0.1), 0.7,  # Offset pulse
  noise(low: 0, high: 0.3), 0.3                  # Random scatter
)

# TRANSITION: Try different curves
# Option 1: Linear
transition = ramp

# Option 2: S-curve (natural)
# transition = ease_in_out(exp: 2)

# Option 3: Oscillating (keeps morphing back and forth)
# transition = sine(rate: 0.5)

# Morph between patterns
hybrid = behavior_transition(pattern_a, pattern_b, transition)

live_loop :pattern_morph do
  64.times do |i|
    pos = i / 64.0

    if hybrid.call(pos) > 0.5
      # Sample selection also morphs
      sample_pos = transition.call(pos)
      idx = (sample_pos * 127).round

      sample "#{batches_path(:kck)}kck_#{idx.to_s.rjust(3, '0')}.wav",
             amp: 0.7
    end

    sleep 0.125
  end
  stop
end
```

**What to listen for**:
- Clear pattern A at beginning
- Clear pattern B at end
- Hybrid behavior in middle (not A or B, but a blend)
- How different transition curves create different morphing characters

**Theory connection**: Fell's pattern synthesis - emergent rhythm from combining two simple rules with transition function

---

### D. Expert Level: Self-Similar & Feedback Systems

**Learning goal**: Create non-linear time through nested, self-modulating structures

---

#### Exercise 8: Nested Temporal Structures (Non-Linear Time)

**Concept**: Fell's non-linear time - curves modulating curves creates feedback loops

**Theory**: When one curve's rate is controlled by another curve's output, you create **non-linear time** - the pattern's speed changes based on its own state. This creates fractal-like self-similarity.

##### Exercise 8.1: Self-Similar Patterns

```ruby
# OUTER: Slow macro evolution
outer = sine(rate: 0.25)  # Very slow (1 cycle per 4 sections)

# INNER: Rate modulated BY outer (feedback loop)
inner = lambda do |pos|
  outer_val = outer.call(pos)  # Get current outer curve value
  rate = 1 + outer_val * 8     # Rate varies 1→9 based on outer
  sine(rate: rate).call(pos)   # Sine with variable rate
end

# PROBABILITY: Combination of both scales
prob = lambda do |pos|
  outer_val = outer.call(pos)
  inner_val = inner.call(pos)
  (outer_val + inner_val) / 2.0  # Average of both
end

gate = bernoulli_gate(prob)

live_loop :nested_time do
  128.times do |i|
    pos = i / 128.0

    if gate.call(pos) > 0.5
      # Sample selection follows inner curve
      sample_val = (inner.call(pos) + 1.0) / 2.0  # Normalize -1,1 → 0,1
      idx = (sample_val * 127).round

      sample "#{batches_path(:hat)}hat_#{idx.to_s.rjust(3, '0')}.wav",
             amp: 0.3 + prob.call(pos) * 0.3,
             rate: [-2, -1, 1, 2].choose,
             pan: rand(2) - 1
    end

    sleep 0.0625
  end
  stop
end
```

**What to listen for**:
- Pattern speeds up and slows down
- Fractal-like self-similarity (fast pattern mirrors slow pattern)
- Unpredictable yet coherent
- Two time scales interacting non-linearly

**Theory connection**: Fell's feedback loops - "pattern emerges from self-modulating system where output influences future input"

---

#### Exercise 9: Multi-Category Orchestration

**Concept**: Complex timbral polyphony across categories (Roads + Fell integration)

**Theory**: Multiple sound object streams (categories) each with their own pattern logic, all shaped by a shared macro form. This is Roads' multi-layered time scales combined with Fell's pattern synthesis.

##### Exercise 9.1: Layered Multiscalar Texture

```ruby
# SHARED MACRO: Overall form for all layers
macro = adsr(attack: 4, decay: 2, sustain: 8, release: 2)

# DIFFERENT MESO PATTERNS for each category
layers = {
  kck: {
    density: pulse(width: 0.25, rate: 1),        # Regular kick
    sample_curve: const(value: 0.3),             # Fixed sample
    amp_scale: 0.8
  },
  snr: {
    density: pulse(width: 0.15, rate: 2, phase: 0.5),  # Syncopated snare
    sample_curve: ramp,                          # Morphing snare
    amp_scale: 0.6
  },
  hat: {
    density: sine(rate: 4, amp: 0.5, bias: 0.5), # Swelling hi-hats
    sample_curve: sine(rate: 0.5),               # Slow timbre oscillation
    amp_scale: 0.4
  },
  clp: {
    density: noise(mode: 0.2),                   # Scattered claps
    sample_curve: const(value: 0.8),             # Bright clap
    amp_scale: 0.5
  }
}

live_loop :orchestration do
  128.times do |i|
    pos = i / 128.0
    macro_amp = macro.call(pos)

    # Fire each layer independently
    layers.each do |category, params|
      density_val = params[:density].call(pos)

      if bernoulli_gate(density_val).call(pos) > 0.5
        # Get sample index for this layer
        sample_val = params[:sample_curve].call(pos)
        idx = (sample_val * 127).round

        # Amplitude follows macro AND layer-specific scaling
        amp = macro_amp * params[:amp_scale] / 2.0

        sample "#{batches_path(category)}#{category}_#{idx.to_s.rjust(3, '0')}.wav",
               amp: amp,
               pan: (rand * 0.4 - 0.2)  # Slight stereo spread
      end
    end

    sleep 0.0625
  end
  stop
end
```

**What to listen for**:
- Four independent rhythmic streams
- Each stream has its own pattern character
- All streams follow same intensity arc (macro)
- Layers entering based on macro intensity
- Complex texture from simple layer rules

**Theory connection**: Roads' multi-layered time scales + Fell's pattern synthesis = "complex emergent texture where each layer operates independently but all share global structure"

---

## IV. Compositional Strategies & Techniques

This section provides practical strategies for using curves and batches samples compositionally. These are reusable patterns and techniques you can apply in your own work.

### A. Sample Selection Strategies

#### 1. Continuous Morphing

**Use**: Smooth timbral evolution, atmospheric textures, evolving leads

**Approach**: Use smooth, continuous curves like `sine()` or `ease_in_out()` to create perceptually seamless transformations.

```ruby
# S-curve morph (natural-feeling)
morph = ease_in_out(exp: 2)
selector = sample_selector(morph, num_samples: 128)

# Slow sine oscillation (breathing timbre)
oscillate = sine(rate: 0.5)
selector = sample_selector(oscillate, num_samples: 128)
```

**Why it works**: With 128 samples, adjacent samples are similar enough that small index changes create smooth perceptual transitions. S-curves feel natural because they mirror biological motion (slow start, acceleration, slow end).

#### 2. Discrete Switching

**Use**: Rhythmic variation, surprise moments, formal boundaries

**Approach**: Use step functions like `pulse()` or `sequencer()` with `smooth: false` for abrupt timbral changes.

```ruby
# Binary switching between two samples
switch = pulse(width: 0.5, rate: 2)  # ON/OFF, 2 cycles
selector = sample_selector(switch, num_samples: 128)
# Result: Jumps between sample 0 and sample 127

# Stepped sequence through specific samples
steps = sequencer([0, 0.25, 0.5, 0.75, 1.0], smooth: false)
selector = sample_selector(steps, num_samples: 128)
# Result: Jumps through samples 0, 32, 64, 96, 127
```

**Why it works**: Abrupt changes create rhythmic interest and mark structural boundaries. The ear perceives discrete timbral jumps as rhythmic events.

#### 3. Stochastic Wandering

**Use**: Textural clouds, avoiding repetition, organic feel

**Approach**: Use `noise()` or `mix()` with noise component for exploratory sample selection.

```ruby
# Wandering through sample space
wander = noise(mode: 0.5)  # Centered triangular distribution
selector = sample_selector(wander, num_samples: 128)

# Constrained wandering (within range)
wander_bright = noise(low: 0.6, high: 0.9, mode: 0.75)  # Bright samples, biased high
selector = sample_selector(wander_bright, num_samples: 128)
```

**Why it works**: Randomness prevents exact repetition while mode parameter keeps results musically coherent (not completely scattered).

#### 4. Targeted Subsets

**Use**: Focusing on specific timbral ranges (bright/dark/mid)

**Approach**: Use amplitude and bias to scale curve output to desired sample range.

```ruby
# Only bright samples (samples 90-127)
bright_curve = ramp(amp: 0.3, bias: 0.7)  # Output: 0.7-1.0
selector = sample_selector(bright_curve, num_samples: 128)

# Only dark samples (samples 0-38)
dark_curve = ramp(amp: 0.3, bias: 0.0)  # Output: 0.0-0.3
selector = sample_selector(dark_curve, num_samples: 128)

# Middle samples only (samples 40-88)
mid_curve = sine(amp: 0.19, bias: 0.5)  # Output: 0.31-0.69
selector = sample_selector(mid_curve, num_samples: 128)
```

**Formula for targeting range**:
```
To get samples from index A to index B (out of 128 total):
low = A / 127
high = B / 127
amp = high - low
bias = low
```

### B. Density & Probability Techniques

#### 1. Euclidean-Style Patterns

**Use**: Geometrically distributed rhythms, polyrhythmic textures

**Approach**: Combine modulo arithmetic with curve-controlled thresholds.

```ruby
# Basic Euclidean pattern: 5 hits in 16 steps
threshold = ramp  # Threshold increases

16.times do |i|
  pos = i / 16.0
  if (i * 5) % 16 < (threshold.call(pos) * 16)
    sample :bd_haus
  end
  sleep 0.125
end

# Layered Euclidean with different densities
[3, 5, 7].each do |hits|
  16.times do |i|
    pos = i / 16.0
    if (i * hits) % 16 < (ramp.call(pos) * 16)
      sample choose([:bd_tek, :sn_dolf, :drum_cymbal_closed])
    end
    sleep 0.125
  end
end
```

#### 2. Probability Gradients

**Use**: Organic rhythmic evolution, building/releasing tension

**Approach**: Slowly changing density for smooth transitions.

```ruby
# Breathing in/out
breath = sine(rate: 0.25, amp: 0.4, bias: 0.5)  # 0.1-0.9 range
gate = bernoulli_gate(breath)

# Building intensity (fade in)
build = ease_in(exp: 3)
gate = bernoulli_gate(build)

# Releasing intensity (fade out)
release = ease_out(exp: 3)
gate = bernoulli_gate(release)
```

#### 3. Hysteresis for Stability

**Use**: Preventing jittery triggers when curves hover near threshold

**Approach**: Use `schmitt_gate()` when combining curves with noise or slow-moving curves near decision points.

```ruby
# Problem: wobbly curve creates jitter
wobbly = mix(sine(rate: 1), 0.7, noise, 0.3)

# Without schmitt: rapid on/off near threshold
if wobbly.call(pos) > 0.5
  # Might trigger multiple times as curve crosses 0.5
end

# With schmitt: clean transitions
stable = schmitt_gate(wobbly, threshold_low: 0.4, threshold_high: 0.6)

if stable.call(pos) > 0.5
  # Clean on/off, no double triggers
end
```

**Threshold separation guideline**: Set thresholds 0.1-0.2 apart for musical stability. Wider separation = more stable but less responsive.

#### 4. Composite Probabilities

**Use**: Complex patterns from layered probability curves

**Approach**: Multiply or combine multiple curves to create intricate probability spaces.

```ruby
# Macro AND meso must both be high
macro_density = ease_in(exp: 2)  # Building overall
meso_pulse = pulse(width: 0.6, rate: 2)  # Phrase rhythm

combined = lambda do |pos|
  macro_density.call(pos) * meso_pulse.call(pos)  # Multiplicative
end

gate = bernoulli_gate(combined)
# Result: Pulsing pattern that builds over time

# Macro OR meso (additive, then clamp)
combined_add = lambda do |pos|
  sum = macro_density.call(pos) + meso_pulse.call(pos) * 0.5
  [sum, 1.0].min  # Clamp to max 1.0
end
```

### C. Multi-Scale Composition Patterns

#### 1. Bottom-Up (Micro → Macro)

**Workflow**: Material-first composition
1. Start with sound material (samples, timbres)
2. Build meso-level patterns from material
3. Wrap in macro-level form

**When to use**: Sound design projects, texture-focused pieces, when timbre is primary

**Example approach**:
```ruby
# Step 1: Choose sound material and micro modulation
micro = sine(rate: 12)  # Fast timbral wobble
samples = batches_path(:atm)

# Step 2: Add meso pattern
meso = pulse(width: 0.4, rate: 2)

# Step 3: Wrap in macro form
macro = adsr(attack: 2, decay: 1, sustain: 4, release: 1)

# Combine
# (see full example in Exercise 6)
```

#### 2. Top-Down (Macro → Micro)

**Workflow**: Architecture-first composition
1. Design overall form (sections, arc)
2. Add phrase-level structure within sections
3. Detail with micro-level modulation

**When to use**: Narrative pieces, structured compositions, when form is primary

**Example approach**:
```ruby
# Step 1: Design macro form (overall shape)
macro = breakpoints(
  [0.0, 0.1],  # Intro
  [0.3, 0.8],  # Build
  [0.6, 1.0],  # Peak
  [1.0, 0.2]   # Outro
)

# Step 2: Add meso patterns for each section
# (different patterns triggered by macro intensity)

# Step 3: Add micro details
# (sample morphing, rate modulation within patterns)
```

#### 3. Middle-Out (Meso-Focused)

**Workflow**: Rhythm-first composition (Fell's approach)
1. Establish pattern/groove at meso scale
2. Extend pattern into macro form
3. Detail with micro variations

**When to use**: Dance music, groove-oriented pieces, exploring rhythmic ideas

**Example approach**:
```ruby
# Step 1: Establish meso pattern (the groove)
groove = pulse(width: 0.25, rate: 4)

# Step 2: Extend to macro (overall intensity)
intensity = ease_in_out(exp: 2)  # Overall dynamic shape

# Step 3: Add micro details (timbral variation)
timbre = sine(rate: 8)  # Fast wobble

# Combine with groove as center
```

### D. Pattern Synthesis Recipes (Fell-Inspired)

#### 1. The Drift Pattern

**Formula**: Simple rule + slow modulation = evolving pattern

```ruby
# Base pattern (regular)
base = pulse(width: 0.25, rate: 4)

# Slow drift modulates phase
drift = sine(rate: 0.1)

# Apply drift
drifting = lambda do |pos|
  phase_offset = drift.call(pos) * 0.2  # ±0.2 phase drift
  pulse(width: 0.25, rate: 4, phase: phase_offset).call(pos)
end

gate = bernoulli_gate(drifting)
```

**Result**: Pattern slowly phase-shifts, creating subtle variation while maintaining identity.

#### 2. The Crossfade Pattern

**Formula**: Two states + transition curve = pattern morph

```ruby
# State A: Regular pattern
state_a = pulse(width: 0.25, rate: 2)

# State B: Chaotic pattern
state_b = noise(mode: 0.3)

# Transition (try different curves)
transition = ease_in_out(exp: 2)

# Morph
morph = behavior_transition(state_a, state_b, transition)
gate = bernoulli_gate(morph)
```

**Result**: Smooth transformation from ordered to chaotic.

#### 3. The Nested Pattern

**Formula**: Curve calling curve = fractal rhythm

```ruby
# Outer curve (slow)
outer = sine(rate: 0.5)

# Inner curve (rate modulated by outer)
inner = lambda do |pos|
  rate = 1 + outer.call(pos) * 4  # Rate varies 1-5
  sine(rate: rate).call(pos)
end

gate = bernoulli_gate(inner)
```

**Result**: Self-similar pattern that speeds up and slows down organically.

#### 4. The Layered Pattern

**Formula**: Independent layers + shared form = complex texture

```ruby
# Shared form
form = adsr(attack: 2, decay: 1, sustain: 4, release: 1)

# Independent layer patterns
layer_1_pattern = pulse(width: 0.25, rate: 4)
layer_2_pattern = pulse(width: 0.15, rate: 6, phase: 0.3)
layer_3_pattern = noise(mode: 0.2)

# Each layer scaled by form
layer_1_prob = lambda { |pos| form.call(pos) * layer_1_pattern.call(pos) }
layer_2_prob = lambda { |pos| form.call(pos) * 0.7 * layer_2_pattern.call(pos) }
layer_3_prob = lambda { |pos| form.call(pos) * 0.5 * layer_3_pattern.call(pos) }

# Trigger each layer independently
# (see full example in Exercise 9)
```

**Result**: Polyphonic texture where each voice follows same arc but different rhythmic logic.

### E. Curve Design Principles

#### 1. Match Curve to Perception

**Principle**: What looks mathematically simple doesn't always sound natural.

**Linear curves feel accelerating**:
```ruby
# Linear ramp SOUNDS like it speeds up
ramp  # Mathematically linear, perceptually accelerating
```

**Why**: Human perception of intensity is logarithmic. Equal linear steps feel like increasing steps.

**Exponential curves feel smooth**:
```ruby
# Exponential curves match perception
ease_in_out(exp: 2)  # SOUNDS linear (even, smooth)
```

**S-curves feel natural**:
```ruby
# S-curves mirror biological motion
ease_in_out(exp: 2)  # Like breathing, walking, natural gestures
```

#### 2. Rate Selection Guidelines

Use this table as a starting point:

| Rate | Time Scale | Function | Example |
|------|-----------|----------|---------|
| 0.1 | Macro | Very slow evolution | `sine(rate: 0.1)` = 1 cycle per 10 sections |
| 0.25 | Macro | Slow form shaping | `sine(rate: 0.25)` = 1 cycle per 4 sections |
| 0.5 | Macro→Meso | Section-level changes | `pulse(rate: 0.5)` = 2 sections |
| 1.0 | Meso | One cycle per phrase | `sine(rate: 1)` = 1 complete swell |
| 2-4 | Meso | Multiple phrase cycles | `pulse(rate: 2)` = 2 on/off cycles |
| 8-16 | Micro | Timbral modulation | `sine(rate: 16)` = tremolo/vibrato |
| 32+ | Micro | Very fast texture | `sine(rate: 32)` = rough texture |

**Adjust based on tempo and phrase length**. These assume moderate tempo (120 BPM) and 16-bar phrases.

#### 3. Amplitude & Bias for Range Control

**Formula**:
```ruby
# To scale curve output from min to max:
curve(amp: max - min, bias: min)
```

**Examples**:
```ruby
# Scale to 0.5-1.0 range
sine(amp: 0.5, bias: 0.5)  # Output: 0.5 + (sine_output * 0.5)

# Scale to 0.2-0.8 range
sine(amp: 0.6, bias: 0.2)  # Output: 0.2 + (sine_output * 0.6)

# Target specific samples (64-127)
selector = sample_selector(
  ramp(amp: 0.5, bias: 0.5),
  num_samples: 128
)
```

#### 4. Phase for Polyrhythm

**Principle**: Phase offsets create interlocking rhythmic layers.

```ruby
# Layer 1: On the beat
layer_1 = pulse(width: 0.25, rate: 4, phase: 0.0)

# Layer 2: Offbeat (shifted by half)
layer_2 = pulse(width: 0.25, rate: 4, phase: 0.5)

# Layer 3: Offset by eighth
layer_3 = pulse(width: 0.25, rate: 4, phase: 0.125)

# Result: Interlocking rhythm
```

**Phase as proportion of cycle**: `phase: 0.5` = shifted by 50% of cycle = exactly between pulses.

**Common phase offsets**:
- `0.5` = opposite beat (offbeat)
- `0.25` or `0.75` = quarter offsets
- `0.33` or `0.66` = triplet feel
- `0.125, 0.375, 0.625, 0.875` = sixteenth subdivisions

---

## V. Creative Exercises & Experiments

These exercises are designed as compositional prompts and learning challenges. They progress from focused explorations to open-ended creative tasks.

### Exercise Series A: Curtis Roads Explorations

#### A1. Grain Cloud Simulation

**Goal**: Create texture through high-density micro-events (Roads' granular thinking)

**Requirements**:
- Use `bernoulli_gate` with density >16 events/second
- Modulate density with slow sine wave
- Layer 3-4 sample categories
- Duration: 1-2 minutes

**Starter code**:
```ruby
# Cloud density swells and fades
cloud_density = sine(rate: 0.25, amp: 0.5, bias: 0.5)

# Very high event rate
128.times do |i|
  pos = i / 128.0

  if bernoulli_gate(cloud_density).call(pos) > 0.5
    # Random sample selection
    cat = [:atm, :txt, :vox, :wsh].choose
    idx = rand(0..127)

    sample "#{batches_path(cat)}#{cat}_#{idx.to_s.rjust(3, '0')}.wav",
           amp: 0.2,
           rate: rand(0.5..2.0),
           pan: rand(2) - 1,
           attack: 0.01,
           release: rand(0.05..0.2)
  end

  sleep 0.03125  # 32 events/second
end
```

**Challenge variations**:
- Use multiple cloud densities with different rates
- Add sample morphing (continuous idx rather than random)
- Control stereo width with curves

**What to listen for**: Transition from discrete events to continuous texture as density increases.

---

#### A2. Multiscalar Envelope

**Goal**: Design piece where each time scale has distinct character

**Requirements**:
- Macro: `breakpoints()` defining 3+ section form
- Meso: `pulse()` or `sine()` creating phrase rhythm
- Micro: Fast modulation (rate: 8+) for timbral detail
- All three scales clearly perceivable
- Duration: 1-2 minutes

**Approach**:
1. Design macro form first (intro/build/peak/outro)
2. Choose meso pattern that complements form
3. Add micro details that respond to meso/macro

**Evaluation**: Can a listener identify the three time scales? Do they interact musically (not just layered)?

---

#### A3. Sound Object Transformation

**Goal**: Single sound evolved through continuous morphing (Roads' transformation aesthetic)

**Requirements**:
- Pick one category (e.g., `:atm`, `:txt`, `:sir`)
- Use `sample_selector` with complex curve
- No discrete jumps - only smooth evolution
- Duration: 2+ minutes
- Sustain interest through transformation alone

**Curve suggestions**:
```ruby
# Oscillating evolution
morph = sine(rate: 0.25)

# Nested evolution (self-similar)
outer = sine(rate: 0.1)
inner = lambda { |pos|
  sine(rate: 1 + outer.call(pos) * 2).call(pos)
}

# Multi-stage evolution
morph = chain(
  sine(rate: 0.5),
  ease_in_out(exp: 2)
)
```

**Challenge**: Can you hold attention for 2 minutes with a single sound object?

---

### Exercise Series B: Mark Fell Investigations

#### B1. Minimal Rule, Maximum Pattern

**Goal**: Generate complex rhythm from simplest possible rule

**Requirements**:
- Single curve (e.g., `pulse` with changing width)
- One parameter modulated (e.g., width controlled by slow sine)
- Observe emergent patterns
- Duration: 1-2 minutes

**Example**:
```ruby
# Width slowly changes
width_curve = sine(rate: 0.2, amp: 0.3, bias: 0.5)  # 0.2-0.8

live_loop :minimal_rule do
  64.times do |i|
    pos = i / 64.0
    width = width_curve.call(pos)

    pattern = pulse(width: width, rate: 4)

    if pattern.call(pos) > 0.5
      sample :bd_tek
    end

    sleep 0.125
  end
end
```

**Challenge**: What's the simplest rule that still produces interesting patterns?

---

#### B2. Deterministic Randomness

**Goal**: Explore position-seeded "chance" (Fell's stochastic + deterministic)

**Requirements**:
- Create pattern using `bernoulli_gate`
- Run multiple times - verify consistency
- Change curve slightly - observe dramatic difference
- Document curve → pattern relationships

**Experiment**:
```ruby
# Try these curves, note resulting patterns:
curves = [
  ramp,                              # Building density
  sine(rate: 0.5),                   # Breathing
  pulse(width: 0.3, rate: 2),        # Binary sections
  noise(mode: 0.5),                  # Controlled chaos
  ease_in_out(exp: 2)                # S-curve evolution
]

curves.each do |curve|
  gate = bernoulli_gate(curve)

  32.times do |i|
    pos = i / 32.0
    sample :sn_dolf if gate.call(pos) > 0.5
    sleep 0.125
  end

  sleep 1
end
```

**Reflection**: How does curve shape create rhythmic character? What makes a pattern feel "random" vs "evolving"?

---

#### B3. Pattern Morphing

**Goal**: Transition between two distinct rhythmic identities

**Requirements**:
- Define pattern A (e.g., house kick pattern)
- Define pattern B (e.g., broken beat)
- Use `behavior_transition` to morph over 32+ bars
- Identify "hybrid" moment where neither pattern dominates

**Patterns to try**:
```ruby
# A: 4-on-the-floor
pattern_a = pulse(width: 0.25, rate: 4)

# B: Syncopated
pattern_b = pulse(width: 0.15, rate: 6, phase: 0.1)

# C: Chaotic
pattern_c = noise(mode: 0.2)

# Transition types:
linear = ramp
smooth = ease_in_out(exp: 2)
oscillating = sine(rate: 0.5)
```

**Challenge**: Create a 5-minute piece that morphs through 3+ distinct patterns continuously.

---

### Exercise Series C: Integration Challenges

#### C1. Batches Symphony

**Goal**: Full multiscalar composition using all 27 categories

**Requirements**:
- Use at least 10 categories
- Each category has distinct role (kick/bass/percussion/atmosphere/etc.)
- Assign macro form defining overall arc
- Different meso patterns to category groups
- Micro modulation for timbral variety
- Duration: 3-5 minutes

**Approach**:
1. Group categories by function:
   - **Foundation**: kck, bas (always present)
   - **Rhythm**: snr, hat, clp, tom (phrase-level patterns)
   - **Texture**: atm, txt, wsh, vox (high-density clouds)
   - **Accent**: blp, zap, exp, sir (sparse, dramatic)

2. Assign patterns:
   - Foundation: Steady, macro-modulated
   - Rhythm: Meso-level patterns (pulse, bernoulli_gate)
   - Texture: High-density, evolving
   - Accent: Sparse, form-marking

3. Macro form: Define clear sections (intro/build/peak/breakdown/outro)

**Evaluation**: Does the piece have coherent form? Can you identify individual categories? Do all scales work together?

---

#### C2. Anti-Composition

**Goal**: Embrace Fell's "anti-energy" aesthetic

**Requirements**:
- One tempo, one dynamic level (no builds or crescendos)
- Use only subtle probability variations
- Duration: 5+ minutes
- Meditation on subtle change
- No dramatic events

**Approach**:
```ruby
# Constant density (around 60-70%)
density = mix(
  const(value: 0.65), 0.8,     # Mostly constant
  noise(mode: 0.5), 0.2        # Slight variation
)

# Slow sample drift (barely perceptible)
sample_drift = sine(rate: 0.05)  # Very slow

# No amplitude changes, no builds
amp = 0.5  # Constant

# Pattern that sits and evolves minutely
```

**Challenge**: Can you create interest through subtle variation alone? What's the minimum change needed to sustain attention?

---

#### C3. Microsound Narrative

**Goal**: Roads-inspired "sound birth → transformation → death"

**Requirements**:
- Act 1: Sound emergence (sparse → dense)
- Act 2: Transformation (sample morphing, parameter evolution)
- Act 3: Dissolution (dense → sparse)
- Clear narrative arc
- Duration: 3-5 minutes

**Form suggestion**:
```ruby
narrative = breakpoints(
  # ACT 1: Birth (0.0 - 0.3)
  [0.0, 0.0],                         # Silence
  [0.05, 0.1, ease_in(exp: 3)],       # First emergence
  [0.2, 0.6, ease_in(exp: 2)],        # Growing
  [0.3, 0.8],                         # Established

  # ACT 2: Transformation (0.3 - 0.7)
  [0.5, 1.0, ease_in_out(exp: 2)],    # Peak transformation
  [0.7, 0.8, ease_out(exp: 2)],       # Beginning to fade

  # ACT 3: Death (0.7 - 1.0)
  [0.85, 0.4, ease_out(exp: 3)],      # Dissolving
  [0.95, 0.1],                        # Almost gone
  [1.0, 0.0, ease_out(exp: 4)]        # Silence
)
```

**Challenge**: Can you tell a story through sound transformation alone?

---

## VI. Technical Reference

### A. Quick Function Reference by Use Case

#### Sample Selection

**Continuous morphing:**
```ruby
sample_selector(curve, num_samples: 128)
# Returns: Integer index (0-127)
# Use: Smooth timbral evolution
```

**Discrete category selection:**
```ruby
categorical_sample(curve, [:cat1, :cat2, :cat3])
# Returns: Element from array
# Use: Switching between different sound types
```

#### Event Triggering

**Probability-based:**
```ruby
bernoulli_gate(prob_curve)
# Returns: 1.0 (trigger) or 0.0 (no trigger)
# Randomness: Position-seeded (deterministic)
# Use: Non-metronomic rhythms
```

**Stable state switching:**
```ruby
schmitt_gate(curve, threshold_low: 0.3, threshold_high: 0.7)
# Returns: 1.0 or 0.0 with hysteresis
# Use: Prevent jittery triggers
```

**Density control:**
```ruby
density_curve(base_rate, density_curve)
# Returns: 1.0 (fire event) or 0.0
# Use: Event frequency modulation
```

#### Temporal Structure

**Event sequencing:**
```ruby
temporal_sequence(timing_curve, [event1, event2, event3])
# Returns: [current_event, position_in_event]
# Use: Curve-controlled progression through events
```

**Behavior morphing:**
```ruby
behavior_transition(start_behavior, end_behavior, transition_curve)
# Returns: Crossfaded value
# Use: Smooth transitions between patterns/states
```

#### Composition

**Serial transformation:**
```ruby
chain(curve1, curve2, curve3)
# Returns: Composed curve
# Use: Nested modulation
```

**Parallel blending:**
```ruby
mix(curve1, weight1, curve2, weight2, ...)
# Returns: Weighted sum curve
# Use: Layered complexity
```

### B. Batches System Overview

**Location**: `/Users/jaredmcfarland/Music/Samples/batches_dirt/`

**Categories** (27 total):
- **Percussion**: kck, snr, clp, hat, tom
- **Tonal**: bas, tri
- **Metallic**: cym, mtl, lid
- **Noise**: nos, crk, sch, wsh
- **Tonal/Melodic**: blp, zap, laz, sir
- **Texture**: atm, txt, vib, vox, wod
- **Transient**: bng, exp, stb

**Samples per category**:
- Most: 128 samples
- Some variations: laz (70), tri (70), crk (105), vox (188)

**Naming convention**: `{category}_{index}.wav`
- Example: `kck_042.wav`, `snr_127.wav`
- Index: 000-127 (zero-padded to 3 digits)

**Helper function**:
```ruby
define :batches_path do |category|
  "/Users/jaredmcfarland/Music/Samples/batches_dirt/#{category}/"
end

# Usage:
sample "#{batches_path(:kck)}kck_064.wav"
```

**Index mapping with sample_selector**:
```ruby
# Automatic mapping to available range
selector = sample_selector(curve, num_samples: 128)
idx = selector.call(pos)  # Returns 0-127

# Play sample
sample "#{batches_path(:kck)}kck_#{idx.to_s.rjust(3, '0')}.wav"
```

### C. Performance Optimization Tips

#### 1. Pre-calculate curves outside loops

**Inefficient**:
```ruby
live_loop :example do
  curve = sine(rate: 2)  # ❌ Recreated every iteration!
  value = curve.call(tick / 64.0)
  # ...
end
```

**Efficient**:
```ruby
curve = sine(rate: 2)  # ✅ Calculated once
live_loop :example do
  value = curve.call(tick / 64.0)
  # ...
end
```

#### 2. Use to_array for static curves

When curve won't change during performance:
```ruby
# Pre-compute all values
curve_values = to_array(ease_in_out(exp: 2), 128)

live_loop :efficient do
  value = curve_values[tick % 128]  # Simple array lookup
  play 60, amp: value
  sleep 0.125
end
```

**When to use**: Curves that don't change, fixed-length loops, maximum performance needed.

#### 3. Sample loading (if using load_sample)

```ruby
# Load all samples in category once
kck_samples = 128.times.map do |i|
  load_sample "#{batches_path(:kck)}kck_#{i.to_s.rjust(3, '0')}.wav"
end

# Then play by index (no loading delay)
live_loop :fast_playback do
  idx = sample_selector(ramp, num_samples: 128).call(tick / 64.0)
  sample kck_samples[idx]
  sleep 0.125
end
```

**Note**: Only useful if you're playing samples at very high rates. Usually Sonic Pi's sample caching is sufficient.

#### 4. Minimize recalculation in tight loops

**Inefficient**:
```ruby
128.times do |i|
  pos = i / 128.0

  # Recalculating same curves multiple times per iteration
  if bernoulli_gate(sine(rate: 2)).call(pos) > 0.5  # ❌
    # ...
  end
end
```

**Efficient**:
```ruby
gate = bernoulli_gate(sine(rate: 2))  # ✅ Calculate once

128.times do |i|
  pos = i / 128.0
  if gate.call(pos) > 0.5
    # ...
  end
end
```

---

## VII. Philosophical Reflections

### A. Why These Theories Matter

#### Beyond Technical Craft

Curtis Roads and Mark Fell don't just offer compositional techniques - they challenge fundamental assumptions about musical time, structure, and creation.

**Traditional assumptions they challenge**:

**"Music is made of notes"** (Roads)
→ Music is made of sound particles organized across time scales. The "note" is just one possible time-scale organization among many.

**"Time is a grid"** (Roads)
→ Time exists simultaneously at multiple scales. A micro-event, a phrase, and a formal section all happen "at the same time" but at different perceptual scales.

**"Rhythm is meter + subdivision"** (Fell)
→ Rhythm is event density distribution. Meter emerges from pattern, not the other way around.

**"Complexity requires complicated systems"** (Fell)
→ Complex patterns emerge from simple rules. Adding more rules often reduces, not increases, interesting complexity.

**"Music should be exciting"** (Fell)
→ Sustained attention to subtle variation can be more profound than dramatic gestures. The "anti-energy" aesthetic.

#### Computational Music as Medium

Code makes theory explicit, testable, explorable:

**Explicit formalization**: Writing `sine(rate: 2)` forces you to think: "What time scale am I operating at?" The code IS the theoretical decision.

**Testable hypotheses**: Roads claims micro-scale events create texture. Test it: run `bernoulli_gate()` at 32 events/second. Hear for yourself.

**Explorable parameter space**: What happens when rate varies 0.1 to 32? You can systematically explore the entire range.

**Externalized thought**: Live coding makes compositional thinking visible, shareable, critique-able.

### B. What Batches + Curves Enables

#### Theoretical Affordances

**1. Granular without DSP**
Traditional granular synthesis requires DSP programming. With batches + curves:
- High-density triggering = grain clouds
- Curve-controlled density = grain distribution
- Sample selection = grain timbre
- No complicated signal processing needed

**2. Multiscalar awareness**
The rate parameter forces you to think: "What time scale am I working at?" You can't avoid the question. This awareness changes how you compose.

**3. Pattern as emergent property**
You don't compose patterns directly - you design rules that generate patterns. The pattern emerges from rule + position. This is fundamentally different from traditional composition.

**4. Timbre as parameter space**
128 samples in a category = explorable continuum. Timbre isn't discrete choices ("which sample?") but continuous navigation ("where in timbral space?").

#### Creative Affordances

**1. Composition as system design**
You're not arranging sounds - you're designing systems that arrange themselves. The composer becomes system designer.

**2. Exploration over perfection**
Tweak a curve, hear the result, tweak again. The feedback loop is immediate. Discovery through iteration.

**3. Theory-informed experimentation**
Roads/Fell provide intellectual framework. You're not randomly trying things - you're testing theoretical ideas.

**4. Scalable complexity**
Beginner: One curve, one parameter
Expert: Nested curves across three time scales
Same principles, different depths.

### C. Challenges to Conventional Thinking

#### From Curtis Roads

**"Music isn't made of notes, it's made of particles"**

Implication: Stop thinking in terms of discrete pitch/rhythm. Start thinking in terms of sound events distributed across time scales.

Compositional shift: Instead of "what note goes here?" ask "what density of events at what time scale?"

**"Time isn't grid-based, it's multi-scaled"**

Implication: The macro form, meso pattern, and micro texture aren't separate layers - they're simultaneous organizations of the same temporal flow.

Compositional shift: Design across scales simultaneously, not sequentially. Macro decisions affect micro behavior.

**"Form isn't imposed, it emerges from time-scale interaction"**

Implication: You don't "add form" to material. Form IS the relationship between time scales.

Compositional shift: Instead of "first material, then arrange," think "time-scale relationships generate both material and form."

#### From Mark Fell

**"Complexity doesn't require complicated systems"**

Implication: A pulse wave with slowly changing width can generate infinite rhythmic variation. Adding more rules often makes patterns LESS interesting.

Compositional shift: Resist the urge to add complexity. Find the minimal system that generates maximal interest.

**"Randomness can be deterministic"**

Implication: Position-seeded randomness (bernoulli_gate) feels random but is actually repeatable. This is fundamentally different from true randomness.

Compositional shift: Use "controlled chance" - predictable unpredictability.

**"Energy and excitement aren't necessary"**

Implication: Music can sustain attention through subtle variation at constant intensity. The "anti-energy" aesthetic challenges conventional dynamics.

Compositional shift: Try removing all builds, drops, crescendos. What remains when you remove excitement?

**"Pattern is more interesting than melody"**

Implication: Rhythmic patterns evolving over time can be more musically rich than melodic development.

Compositional shift: Focus on temporal organization (when events happen) rather than pitch organization (what pitch events have).

#### From sonic_pi_curves

**"Parameters can be functions, not just values"**

Implication: Every parameter is a potential modulation target. `amp: 0.5` and `amp: sine(rate: 2)` are equally valid.

Compositional shift: Think in terms of modulation networks, not static values.

**"Composition is function composition"**

Implication: Composing music = composing functions. `chain(sine, ease_in_out)` is a compositional decision.

Compositional shift: Your compositional toolkit is mathematical functions. Learn to think functionally.

**"Modulation is transformation"**

Implication: A curve doesn't just "change a parameter" - it transforms the sound object itself.

Compositional shift: Every curve is a transformation. Design transformations, not static states.

**"Live coding is thinking in public"**

Implication: Code shows your compositional reasoning. Writing `bernoulli_gate(ramp)` reveals you're thinking about increasing probability over time.

Compositional shift: Code as compositional notation. Your thought process is the score.

---

## VIII. Further Exploration

### A. Recommended Reading

#### Curtis Roads

**"Microsound"** (MIT Press, 2001)
- Comprehensive theory of time scales and granular synthesis
- Chapters 1-3: Time scales, sound particles
- Chapter 9: Composition with grains
- Essential reading for understanding micro-scale organization

**"Composing Electronic Music: A New Aesthetic"** (Oxford, 2015)
- Broader aesthetic framework
- Covers Roads' compositional practice
- Integration of theory and technique
- Chapters on time, space, and form especially relevant

**"The Computer Music Tutorial"** (MIT Press, 1996)
- Technical foundation for computer music
- Granular synthesis chapter particularly relevant
- More technical than aesthetic

#### Mark Fell

**"Structure and Synthesis: The Anatomy of Practice"** (Urbanomic, 2020)
- Direct insight into Fell's compositional thinking
- Discusses pattern synthesis, rhythm, timbre
- Includes score excerpts and analytical discussions
- Challenging but rewarding read

**PhD Thesis: "Works in Sound and Pattern Synthesis"** (2013)
- Available online
- Theoretical framework for Fell's practice
- Detailed analysis of specific works
- Academic but accessible

**Interviews and articles:**
- RBMA (Red Bull Music Academy) lecture (YouTube)
- Sound American interview (online)
- Various journal articles on rhythm and pattern

#### Related Theory

**Iannis Xenakis - "Formalized Music"**
- Stochastic composition, probability distributions
- Mathematical approach to composition
- Granular/particle thinking predates Roads

**Barry Truax - "Handbook for Acoustic Ecology"**
- Granular synthesis techniques
- Soundscape composition
- Acoustic ecology perspective

**Paul Lansky - writings on algorithmic composition**
- Early computer music composition
- Time-based transformations
- Influence on Roads' thinking

### B. Related Techniques

#### Granular Synthesis (Traditional DSP)

**Tools to explore:**
- **PaulStretch**: Extreme time-stretching (microtonal clouds)
- **GrainProc** (SuperCollider): Real-time granular processing
- **IRCAM SuperVP**: Spectral + granular analysis/synthesis
- **Ableton Granulator**: Accessible granular instrument

**Relationship to batches + curves**: Traditional granular synthesis operates at DSP sample level. Batches + curves operates at musical sample (file) level. Similar concepts, different scales.

#### Algorithmic Composition

**Environments to explore:**
- **SuperCollider Patterns**: Similar functional approach, more complex syntax
- **TidalCycles**: Live coding for pattern-based music, Haskell-based
- **Chuck**: Time-based programming for music
- **Csound**: Classic computer music language, supports granular + algorithmic

**Relationship to batches + curves**: Sonic Pi + curves offers more accessible entry point. Migrate to these for more complexity.

#### Stochastic Music (Xenakis)

**Concepts:**
- Probability distributions (similar to bernoulli_gate)
- Mass events (similar to grain clouds)
- Statistical thinking about sound

**Explore**: Xenakis' "Concrete PH" (1958) - early granular/stochastic work

#### Spectral Composition

**Concepts:**
- Frequency domain manipulation
- Timbre as compositional parameter
- Transformation through filtering/resynthesis

**Tools**:
- **OpenMusic** (IRCAM)
- **Spear** (spectral analysis/editing)
- **AudioSculpt** (spectral editing)

**Relationship**: Complementary approach to timbre. Curves control sample selection; spectral tools control frequency content.

### C. Extensions & Project Ideas

#### 1. Visual Curve Editor

**Concept**: GUI tool to draw curves, export Ruby code

**Features**:
- Draw bezier curves visually
- Preview curve output
- Export as sonic_pi_curves code
- Save/load curve libraries

**Tech stack**: Web app (JavaScript + HTML5 Canvas) or desktop (Python + Qt)

**Value**: Makes curve design more intuitive for non-programmers

#### 2. Multi-Curve Recorder

**Concept**: Capture live parameter movements as curves

**Features**:
- MIDI controller input → curve recording
- Record multiple parameters simultaneously
- Quantize to curves (fit recorded data to curve functions)
- Export to sonic_pi_curves code

**Use case**: Perform parameter modulation, then use recorded curves in composition

#### 3. Curve Genetics

**Concept**: Evolve curves through genetic algorithms

**Features**:
- Generate random curves
- User rates results (fitness function)
- Breed successful curves
- Mutate parameters (rate, exp, phase)

**Value**: Discover unexpected curve combinations

#### 4. Networked Curves

**Concept**: Share curves between multiple Sonic Pi instances

**Features**:
- OSC communication between instances
- One instance sends curve values
- Others receive and use for parameters
- Synchronized multi-computer performance

**Use case**: Laptop orchestra, networked live coding

#### 5. Batches Explorer

**Concept**: GUI for browsing/previewing batches samples

**Features**:
- Visual waveform display
- Play samples on click
- Tag/categorize by timbre
- Generate curve code for sequences
- Spectral analysis view

**Value**: Know your sample library intimately, make informed curve decisions

#### 6. Curve-Based Sequencer

**Concept**: Traditional sequencer UI with curve-based automation

**Features**:
- Piano roll + curve editor
- Each parameter lane has curve automation
- Export to sonic_pi_curves code
- Real-time preview

**Value**: Bridge between traditional sequencing and curve-based composition

---

## Conclusion

This document has explored how sonic_pi_curves + batches samples create a unique environment for investigating Curtis Roads' multiscalar time theory and Mark Fell's pattern synthesis practice.

**Key takeaways**:

1. **Time scales are compositional parameters**: The `rate` parameter directly controls whether you're working at macro (form), meso (pattern), or micro (timbre) scales.

2. **Curves are transformation functions**: Every curve is a sound transformation strategy, not just a modulation source.

3. **Pattern emerges from rules**: Using `bernoulli_gate()` and `density_curve()`, complex rhythms emerge from simple probability rules.

4. **Samples are parameter spaces**: 128 samples in a category = explorable timbral continuum.

5. **Composition is system design**: You design rules (curves + parameters); the system generates music.

**Moving forward**:

Start simple (Exercise 1: single curve, single time scale), then progressively combine scales. The theory provides roadmap; your ears provide destination.

Experiment systematically: Change one parameter, hear the result, understand the relationship. Build intuition through iteration.

Challenge conventional thinking: Try making a piece with no crescendos. Try generating rhythm from curves alone. Try organizing form through time-scale interaction.

Share your discoveries: Live code, document your systems, teach others. The community grows through shared knowledge.

**Remember**: This is not a technique to master - it's a lens for thinking about musical time. Roads and Fell don't provide answers; they provide better questions.

**What will you discover?**

---

*Document version 1.0 - Created for sonic_pi_curves library*
*For updates and community discussion: [github.com/discohead/sonic_pi_curves]*
