# sonic_pi_curves_examples.rb
# Usage examples for the SonicPiCurves library
# These examples demonstrate musical applications in Sonic Pi

# Load the library (adjust path as needed)
load "~/sonic_pi_curves.rb"
# All functions are now available at top-level (no include needed)

# Example 1: Basic envelope for amplitude control
use_synth :saw
env = adsr(attack: 0.1, decay: 0.2, sustain: 0.5, release: 0.3)

live_loop :envelope_demo do
  16.times do |i|
    pos = i / 16.0
    amp_val = env.call(pos)
    play 60, amp: amp_val, release: 0.1
    sleep 0.125
  end
  sleep 1
end

# Example 2: LFO modulating filter cutoff
use_synth :tb303
lfo_curve = lfo(shape: :sine, rate: 2, depth: 0.5, offset: 0.5)

live_loop :filter_sweep do
  with_fx :reverb, room: 0.7 do
    32.times do |i|
      pos = i / 32.0
      cutoff_val = lfo_curve.call(pos)
      play :e2, cutoff: cutoff_val * 120, res: 0.7, release: 0.2
      sleep 0.125
    end
  end
end

# Example 3: Complex modulation using curve chaining
# Create a wobble bass effect by modulating amplitude with multiple curves
wobble = chain(
  sine(rate: 4),
  ease_in_out(exp: 2)
)

live_loop :wobble_bass do
  use_synth :dsaw
  note_duration = 4
  samples_per_beat = 16
  
  (note_duration * samples_per_beat).times do |i|
    pos = i.to_f / (note_duration * samples_per_beat)
    amp_mod = wobble.call(pos)
    play :e1, amp: amp_mod * 0.8, release: 0.15, cutoff: 70
    sleep 1.0 / samples_per_beat
  end
end

# Example 4: Breakpoint envelope for custom parameter curves
# Create a filter sweep that opens quickly, holds, then closes slowly
filter_env = breakpoints(
  [0, 0.1],                    # Start low
  [0.1, 1.0, ease_in(exp: 3)], # Quick rise
  [0.6, 0.9],                  # Hold high
  [1.0, 0.2, ease_out(exp: 4)] # Slow fall
)

live_loop :custom_filter do
  use_synth :prophet
  
  32.times do |i|
    pos = i / 32.0
    cutoff_normalized = filter_env.call(pos)
    cutoff_hz = 40 + (cutoff_normalized * 100)
    
    play :g2, cutoff: cutoff_hz, res: 0.8, release: 0.2
    sleep 0.125
  end
  sleep 0.5
end

# Example 5: Rhythmic patterns with pulse and sequencer
# Use pulse wave to create rhythmic gates
gate = pulse(width: 0.25, rate: 4)

live_loop :gated_pad do
  use_synth :hollow
  
  64.times do |i|
    pos = i / 64.0
    gate_val = gate.call(pos)
    
    if gate_val > 0.5
      play chord(:d3, :minor7), amp: 0.5, release: 0.2
    end
    sleep 0.0625
  end
end

# Example 6: Sequencer for melodic patterns
melody_curve = sequencer([0, 0.25, 0.5, 0.4, 0.75, 0.6, 0.9, 0.3], smooth: true)
scale_notes = scale(:e3, :minor_pentatonic)

live_loop :melodic_sequence do
  16.times do |i|
    pos = i / 16.0
    note_index = (melody_curve.call(pos) * scale_notes.length).floor
    play scale_notes[note_index], release: 0.3
    sleep 0.25
  end
end

# Example 7: Probability-based triggers using noise
prob_curve = noise(low: 0, high: 1, mode: 0.3) # Mode biases toward lower values

live_loop :probability_triggers do
  use_synth :pluck
  
  16.times do |i|
    pos = i / 16.0
    prob = prob_curve.call(pos)
    
    if prob > 0.6  # 40% chance approximately
      play choose(chord(:a3, :minor)), release: 0.5, amp: prob
    end
    sleep 0.125
  end
end

# Example 8: Mix multiple curves for complex modulation
mixed = mix(
  sine(rate: 1), 0.5,      # 50% slow sine
  triangle(rate: 4), 0.3,  # 30% fast triangle
  noise, 0.2               # 20% random
)

live_loop :mixed_modulation do
  use_synth :blade
  
  32.times do |i|
    pos = i / 32.0
    mod_val = mixed.call(pos)
    
    play :c3, 
         vibrato_rate: 2 + (mod_val * 10),
         vibrato_depth: mod_val * 0.1,
         release: 0.2
    sleep 0.125
  end
end

# Example 9: Time-varying curve parameters
# Create a curve where the rate itself changes over time
rate_mod = ramp  # Rate increases from 1x to 4x
phase_shift = sine(rate: 0.5)  # Slow phase drift

dynamic_sine = lambda do |pos|
  rate_at_pos = 1 + (rate_mod.call(pos) * 3)  # 1x to 4x
  phase_at_pos = phase_shift.call(pos) * 0.25  # ±0.25 phase
  
  sine(rate: rate_at_pos, phase: phase_at_pos).call(pos)
end

live_loop :evolving_modulation do
  use_synth :zawa
  
  64.times do |i|
    pos = i / 64.0
    mod_val = dynamic_sine.call(pos)
    
    play :e2,
         cutoff: 40 + (mod_val * 60),
         res: 0.9,
         release: 0.15,
         amp: 0.6
    sleep 0.125
  end
end

# Example 10: Using curves with samples
# Modulate sample playback rate for tape-stop effect
tape_stop = ease_out(exp: 4)

live_loop :sample_modulation do
  sample_duration = sample_duration(:loop_amen)
  
  32.times do |i|
    pos = i / 32.0
    rate_mod = 0.2 + (tape_stop.call(1 - pos) * 0.8)  # Slow down
    
    sample :loop_amen, 
           rate: rate_mod,
           slice: i % 8,
           num_slices: 8
    sleep sample_duration / 8.0 / rate_mod
  end
  sleep 1
end

# Example 11: Sonic Pi control integration
# Map curves to control live_loops via set/get
live_loop :control_source do
  mod = sine(rate: 0.25)  # Very slow modulation
  
  64.times do |i|
    pos = i / 64.0
    set :global_mod, mod.call(pos)
    sleep 0.25
  end
end

live_loop :controlled_synth do
  sync :control_source
  mod_val = get[:global_mod] || 0.5
  
  use_synth :sine
  play scale(:c4, :major)[mod_val * 8], release: 0.5
  
  use_synth :tri
  play scale(:c2, :major)[mod_val * 8], release: 1, amp: 0.3
end

# Example 12: Euclidean rhythm generation with curves
# Use curves to generate evolving rhythmic patterns
euclidean_threshold = triangle(symmetry: 0.7, rate: 0.5)

live_loop :euclidean_rhythm do
  use_synth :fm
  
  16.times do |i|
    pos = i / 16.0
    threshold = euclidean_threshold.call(pos)
    
    # Simple euclidean-like pattern
    if (i * 5) % 16 < (threshold * 16)
      play :c3, release: 0.1, amp: 0.8
    end
    
    if (i * 3) % 16 < ((1 - threshold) * 16)
      play :g3, release: 0.1, amp: 0.6
    end
    
    sleep 0.125
  end
end

# Tips for using curves in Sonic Pi:
#
# 1. Pre-calculate curves outside loops for efficiency:
#    my_curve = sine(rate: 2)
#    live_loop :example do
#      value = my_curve.call(tick.to_f / 32)
#    end
#
# 2. Use to_array to pre-compute values:
#    curve_values = to_array(sine(rate: 4), 128)
#    live_loop :cached do
#      play 60, amp: curve_values[tick % 128]
#      sleep 0.125
#    end
#
# 3. Combine with Sonic Pi's line and range:
#    curve_values = to_array(ease_in_out, 32)
#    scaled_values = curve_values.map { |v| 60 + v * 24 }
#
# 4. Use with control to smoothly change synth parameters:
#    s = play 60, sustain: 8, note_slide: 0.1
#    curve = adsr(attack: 2, decay: 1, sustain: 3, release: 2)
#    64.times do |i|
#      control s, note: 60 + curve.call(i/64.0) * 12
#      sleep 0.125
#    end

# ============================================================================
# BATCHES INTEGRATION EXAMPLES
# Demonstrating Curtis Roads' multiscalar time and Mark Fell's pattern synthesis
# ============================================================================

# Example 13: Sample Morphing - Micro Time Scale
# Smoothly morph through samples in a directory using curves
# Demonstrates Curtis Roads' concept of sound object transformation

# Setup for batches samples (adjust paths as needed)
define :batches_path do |category|
  "/Users/jaredmcfarland/Music/Samples/batches_dirt/#{category}/"
end

define :play_batches_curved do |category, index_curve, pos, opts = {}|
  idx = sample_selector(index_curve, num_samples: 128).call(pos)
  cat_str = category.to_s
  sample_path = "#{batches_path(category)}#{cat_str}_#{idx.to_s.rjust(3, '0')}.wav"
  sample sample_path, **opts
end

# Morph from one kick sound to another over time
live_loop :sample_morphing do
  morph = ease_in_out(exp: 2)  # Smooth transition curve

  16.times do |i|
    pos = i / 16.0
    play_batches_curved(:kck, morph, pos,
                        amp: 0.7,
                        rate: [0.8, 1.0, 1.2].choose)
    sleep 0.25
  end
end

# Example 14: Probability-Driven Triggering - Meso Time Scale
# Use curves to control event density and probability
# Demonstrates Mark Fell's stochastic pattern synthesis

live_loop :evolving_density do
  # Density swells and fades
  density = sine(rate: 0.5, amp: 0.5, bias: 0.5)
  gate = bernoulli_gate(density)

  # Sample selection also evolves
  sample_curve = triangle(rate: 0.25)

  32.times do |i|
    pos = i / 32.0

    if gate.call(pos) > 0.5
      play_batches_curved(:hat, sample_curve, pos,
                          amp: 0.5,
                          rate: [0.9, 1.0, 1.1].choose,
                          pan: rand(2) - 1)
    end
    sleep 0.125
  end
end

# Example 15: Multi-Scale Pattern Synthesis
# Demonstrates simultaneous control at micro, meso, and macro time scales

live_loop :multiscale_synthesis do
  # MACRO: Overall intensity envelope
  macro_env = adsr(attack: 4, decay: 2, sustain: 8, release: 2)

  # MESO: Event density pattern
  meso_density = pulse(width: 0.6, rate: 2)

  # MICRO: Sample playback modulation
  micro_rate = sine(rate: 8)

  64.times do |i|
    pos = i / 64.0

    # Get values from each time scale
    macro_amp = macro_env.call(pos)
    meso_prob = meso_density.call(pos)
    micro_mod = micro_rate.call(pos)

    # Trigger based on meso probability, scale by macro envelope
    if bernoulli_gate(meso_prob).call(pos) > 0.5
      # Sample selection based on position
      sample_idx = (pos * 127).round

      play_batches_curved(:snr, const(value: pos), pos,
                          amp: macro_amp * 0.8,
                          rate: 0.8 + micro_mod * 0.4,
                          lpf: 60 + macro_amp * 60)
    end
    sleep 0.125
  end
end

# Example 16: Categorical Sample Selection
# Use curves to select between different sample categories

live_loop :category_sequencing do
  # Sequence through different sonic textures
  categories = [:kck, :snr, :hat, :clp]
  cat_selector = categorical_sample(sequencer([0, 0.33, 0.66, 1.0]), categories)

  # Sample index within category also curves
  index_curve = ramp

  16.times do |i|
    pos = i / 16.0
    category = cat_selector.call(pos)

    play_batches_curved(category, index_curve, pos,
                        amp: 0.7,
                        rate: 1.0)
    sleep 0.25
  end
end

# Example 17: Temporal Sequence Control
# Events follow curve-controlled timing

live_loop :temporal_control do
  # Define a sequence of sound events
  events = [:kck, :snr, :hat, :clp]

  # Timing follows an accelerating curve
  timing = ease_in(exp: 2)
  seq = temporal_sequence(timing, events)

  16.times do |i|
    pos = i / 16.0
    event, time_in_event = seq.call(pos)

    # Play the event with timing-based modulation
    sample_idx = (time_in_event * 127).round
    play_batches_curved(event, const(value: time_in_event), pos,
                        amp: 0.6,
                        rate: 0.8 + time_in_event * 0.4)
    sleep 0.125
  end
end

# Example 18: Behavior Transition - Pattern Morphing
# Smoothly transition between two different rhythmic patterns

live_loop :pattern_morphing do
  # Pattern A: Regular kick pattern
  pattern_a = pulse(width: 0.25, rate: 4)

  # Pattern B: Syncopated pattern
  pattern_b = pulse(width: 0.15, rate: 6, phase: 0.1)

  # Transition curve (linear morph)
  transition = ramp

  # Morph between patterns
  hybrid_pattern = behavior_transition(pattern_a, pattern_b, transition)

  32.times do |i|
    pos = i / 32.0

    if hybrid_pattern.call(pos) > 0.5
      play_batches_curved(:kck, const(value: pos), pos,
                          amp: 0.7)
    end
    sleep 0.125
  end
end

# Example 19: Schmitt Gate for Stable Triggering
# Prevents jittery triggers at threshold crossings

live_loop :stable_triggers do
  # Slowly varying curve might cross threshold multiple times
  wobbly = mix(sine(rate: 1), 0.7, noise, 0.3)

  # Schmitt gate provides clean on/off with hysteresis
  stable_gate = schmitt_gate(wobbly, threshold_low: 0.4, threshold_high: 0.6)

  32.times do |i|
    pos = i / 32.0

    if stable_gate.call(pos) > 0.5
      play_batches_curved(:hat, const(value: 0.5), pos,
                          amp: 0.5)
    else
      play_batches_curved(:kck, const(value: 0.3), pos,
                          amp: 0.6)
    end
    sleep 0.125
  end
end

# Example 20: Non-Linear Time - Mark Fell Style Pattern Synthesis
# Demonstrates path-dependent, self-similar structures

live_loop :nonlinear_time do
  # Create nested temporal structures

  # Outer loop: slow evolution (macro)
  outer_curve = sine(rate: 0.25)

  # Inner loop: fast variation (micro) - rate modulated by outer
  inner_curve = lambda do |pos|
    outer_val = outer_curve.call(pos)
    rate = 1 + outer_val * 8  # Rate varies 1-9
    sine(rate: rate).call(pos)
  end

  # Probability gate modulated by both scales
  prob_curve = lambda do |pos|
    outer_val = outer_curve.call(pos)
    inner_val = inner_curve.call(pos)
    (outer_val + inner_val) / 2.0
  end

  64.times do |i|
    pos = i / 64.0

    # Sample selection follows inner curve
    sample_pos = (inner_curve.call(pos) + 1.0) / 2.0  # Normalize to 0-1

    # Trigger follows probability
    if bernoulli_gate(prob_curve).call(pos) > 0.5
      play_batches_curved(:sir, const(value: sample_pos), pos,
                          amp: 0.4 + prob_curve.call(pos) * 0.3,
                          rate: [-2, -1, 1, 2].choose,
                          lpf: 60 + sample_pos * 60)
    end
    sleep 0.0625
  end
end

# Example 21: Granular-Style Texture Using Density Control
# High-density events create texture similar to granular synthesis

live_loop :textural_clouds do
  # Varying density creates clouds of sound
  cloud_density = mix(
    sine(rate: 0.5), 0.6,      # Slow swell
    noise(low: 0, high: 0.3), 0.4  # Random variation
  )

  # Sample selection drifts slowly
  sample_drift = sine(rate: 0.1)

  # High event rate for granular effect
  128.times do |i|
    pos = i / 128.0

    # Fire events based on density
    if bernoulli_gate(cloud_density).call(pos) > 0.5
      play_batches_curved(:atm, sample_drift, pos,
                          amp: 0.2 + rand * 0.2,
                          rate: rand(0.5..1.5),
                          pan: rand(2) - 1,
                          attack: 0.01,
                          release: rand(0.1..0.3))
    end
    sleep 0.03125  # Fast triggering (32 events/sec)
  end
end

# Example 22: Algorithmic Form - Curtis Roads Macro Time
# Curves define large-scale musical structure

live_loop :algorithmic_form do
  # Define formal sections using breakpoints
  form = breakpoints(
    [0.0, 0.1],              # Intro (quiet)
    [0.2, 0.8, ease_in],     # Build
    [0.5, 1.0],              # Peak (loud)
    [0.7, 0.6, ease_out],    # Breakdown
    [1.0, 0.2]               # Outro
  )

  # Density follows form
  density_evolution = chain(form, ease_in_out(exp: 2))

  # Sample selection also follows form
  sample_evolution = form

  128.times do |i|
    pos = i / 128.0

    intensity = form.call(pos)
    density_val = density_evolution.call(pos)
    sample_pos = sample_evolution.call(pos)

    # Layered sounds based on intensity
    if bernoulli_gate(density_val).call(pos) > 0.5
      play_batches_curved(:kck, const(value: sample_pos), pos,
                          amp: intensity * 0.8)
    end

    if intensity > 0.5 && bernoulli_gate(density_val * 0.5).call(pos) > 0.5
      play_batches_curved(:snr, const(value: sample_pos), pos,
                          amp: (intensity - 0.5) * 1.6)
    end

    sleep 0.0625
  end
end

# Tips for Batches Integration:
#
# 1. SAMPLE MORPHING: Use sample_selector() with smooth curves (sine, ease_in_out)
#    to create timbral transformations that feel organic
#
# 2. PROBABILITY CONTROL: Use bernoulli_gate() with evolving curves to create
#    non-metronomic, human-feeling rhythms
#
# 3. MULTI-SCALE THINKING: Layer curves at different rates:
#    - Micro (8-32x): Sample-level modulation
#    - Meso (1-4x): Phrase-level patterns
#    - Macro (0.1-0.5x): Formal structure
#
# 4. DETERMINISTIC RANDOMNESS: Position-seeded randomness in bernoulli_gate()
#    creates repeatable "chance" operations - great for composition
#
# 5. PATTERN SYNTHESIS: Combine categorical_sample(), temporal_sequence(),
#    and behavior_transition() to create evolving generative patterns
#
# 6. NON-LINEAR TIME: Nest curves (curves that call other curves) to create
#    self-similar, fractal-like temporal structures