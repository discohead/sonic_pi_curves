# sonic_pi_curves_examples.rb
# Usage examples for the SonicPiCurves library
# These examples demonstrate musical applications in Sonic Pi

# Load the library (adjust path as needed)
# load "~/sonic_pi_curves.rb"
# include SonicPiCurves

# Or use the shorter alias
# include SPCurves

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