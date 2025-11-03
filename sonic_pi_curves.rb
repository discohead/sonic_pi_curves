# sonic_pi_curves.rb
# Signal and curve generation library for Sonic Pi
# Adapted from Python signal.py and Lua curves.lua
# Generates composable functions for modulation, envelopes, and control signals

module SonicPiCurves
  extend self
  
  # Core helper methods
  
  # Check if value responds to call (is a Proc/lambda/method)
  def callable?(v)
    v.respond_to?(:call)
  end
  
  # Clamp value between 0 and 1
  def clamp(pos)
    [[pos, 0.0].max, 1.0].min
  end
  
  # Apply rate and phase modulation to position (with wrapping for periodic curves)
  def calc_pos(pos, rate, phase)
    pos = clamp(pos)
    pos *= callable?(rate) ? rate.call(pos) : rate
    phase_offset = callable?(phase) ? phase.call(pos) : phase
    (pos + phase_offset) % 1.0
  end

  # Apply rate and phase modulation to position (smart wrapping for linear curves)
  # Wraps normally, but preserves 1.0 when rate=1 and phase=0
  def calc_pos_linear(pos, rate, phase)
    pos = clamp(pos)
    r = callable?(rate) ? rate.call(pos) : rate
    p = callable?(phase) ? phase.call(pos) : phase

    # If position is exactly 1.0 and no modulation, keep it as 1.0
    return 1.0 if pos == 1.0 && r == 1 && p == 0

    ((pos * r) + p) % 1.0
  end
  
  # Apply amplitude scaling and bias offset
  def amp_bias(value, amp, bias, pos = nil)
    p = pos || value
    amp_val = callable?(amp) ? amp.call(p) : amp
    bias_val = callable?(bias) ? bias.call(p) : bias
    value * amp_val + bias_val
  end
  
  # Convert 0-1 position to radians
  def pos2rad(pos)
    clamp(pos) * 2 * Math::PI
  end
  
  # Triangular distribution for weighted random values
  def triangular(low, high, mode = nil)
    r = rand
    mode ||= 0.5
    
    if r > mode
      r = 1.0 - r
      mode = 1.0 - mode
      low, high = high, low
    end
    
    low + (high - low) * Math.sqrt(r * mode)
  end
  
  # Normalize array of values to 0-1 range
  def normalize(values)
    return [] if values.empty?
    min, max = values.minmax
    range = max - min
    return values.map { 0.5 } if range == 0
    values.map { |v| (v - min) / range.to_f }
  end
  
  # Curve generator functions
  # All return lambdas that map 0-1 input to 0-1 output (by default)
  
  # Constant value, optionally modulated
  def const(value: 1, mod: false, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      if mod
        pos = calc_pos(pos, rate, phase)
        v = callable?(value) ? value.call(pos) : value
        amp_bias(v, amp, bias, pos)
      else
        callable?(value) ? value.call(pos) : value
      end
    end
  end
  
  # Random noise generator (uniform or triangular distribution)
  def noise(low: 0, high: 1, mode: nil, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos(pos, rate, phase)
      lo = callable?(low) ? low.call(pos) : low
      hi = callable?(high) ? high.call(pos) : high
      
      value = if mode
        m = callable?(mode) ? mode.call(pos) : mode
        triangular(lo, hi, m)
      else
        rand(lo..hi)
      end
      
      amp_bias(value, amp, bias, pos)
    end
  end
  
  # Linear ramp (0 to 1)
  def ramp(amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      amp_bias(pos, amp, bias)
    end
  end

  # Sawtooth (1 to 0)
  def saw(amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      amp_bias(1 - pos, amp, bias)
    end
  end
  
  # Triangle wave with adjustable symmetry
  def triangle(symmetry: 0.5, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos(pos, rate, phase)
      sym = callable?(symmetry) ? symmetry.call(pos) : symmetry
      sym = clamp(sym)
      
      value = if pos < sym
        pos / sym
      else
        1.0 - ((pos - sym) / (1.0 - sym))
      end
      
      amp_bias(value, amp, bias, pos)
    end
  end
  
  # Sine wave
  def sine(amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos(pos, rate, phase)
      value = Math.sin(pos2rad(pos)) * 0.5 + 0.5
      amp_bias(value, amp, bias, pos)
    end
  end
  
  # Pulse wave with adjustable width
  def pulse(width: 0.5, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos(pos, rate, phase)
      w = callable?(width) ? width.call(pos) : width
      w = clamp(w)
      value = pos < w ? 0.0 : 1.0
      amp_bias(value, amp, bias, pos)
    end
  end
  
  # Exponential ease-in curve
  def ease_in(exp: 2, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      e = callable?(exp) ? exp.call(pos) : exp
      amp_bias(pos ** e, amp, bias, pos)
    end
  end

  # Logarithmic ease-out curve
  def ease_out(exp: 3, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      e = callable?(exp) ? exp.call(pos) : exp
      amp_bias(1 - (1 - pos) ** e, amp, bias, pos)
    end
  end

  # S-curve ease-in-out
  def ease_in_out(exp: 3, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      value = pos * 2
      e = callable?(exp) ? exp.call(pos) : exp

      result = if value < 1
        0.5 * value ** e
      else
        value -= 2
        0.5 * (value ** e + 2)
      end

      amp_bias(result, amp, bias, pos)
    end
  end

  # Inverse S-curve ease-out-in
  def ease_out_in(exp: 3, amp: 1, rate: 1, phase: 0, bias: 0)
    lambda do |pos|
      pos = calc_pos_linear(pos, rate, phase)
      value = pos * 2 - 1
      e = callable?(exp) ? exp.call(pos) : exp
      
      result = if value < 1
        0.5 * value ** e + 0.5
      else
        1.0 - (0.5 * value ** e + 0.5)
      end
      
      amp_bias(result, amp, bias, pos)
    end
  end
  
  # Create curve from time series data
  def timeseries(values)
    normalized = normalize(values)
    return const(value: 0.5) if normalized.empty?
    
    lambda do |pos|
      return normalized[0] if normalized.size == 1
      
      index_f = pos * (normalized.size - 1)
      index_pos = index_f % 1.0
      index_low = index_f.floor.clamp(0, normalized.size - 1)
      index_high = index_f.ceil.clamp(0, normalized.size - 1)
      
      normalized[index_low] * (1.0 - index_pos) + normalized[index_high] * index_pos
    end
  end
  
  # Multi-segment envelope with breakpoints
  # Each breakpoint: [time, value, curve_func]
  # Example: breakpoints([0, 0], [0.2, 1, ease_in], [0.7, 0.3, ease_out], [1, 0])
  def breakpoints(*points)
    return const(value: 0) if points.empty?
    
    # Normalize times to 0-1 range
    times = points.map(&:first)
    min_time = times.min
    time_range = times.max - min_time
    
    # Normalize values to 0-1 range
    values = points.map { |p| p[1] }
    min_val = values.min
    val_range = values.max - min_val
    val_range = 1.0 if val_range == 0
    
    # Create normalized breakpoints
    normalized_points = points.map do |point|
      norm_time = time_range > 0 ? (point[0] - min_time) / time_range.to_f : 0
      norm_val = (point[1] - min_val) / val_range.to_f
      curve = point[2] || ramp
      [norm_time, norm_val, curve]
    end
    
    lambda do |pos|
      # Find the segment we're in
      index = normalized_points.index { |p| p[0] > pos } || normalized_points.size
      
      return normalized_points[0][1] if index == 0
      return normalized_points[-1][1] if index >= normalized_points.size
      
      start_point = normalized_points[index - 1]
      end_point = normalized_points[index]
      
      # Calculate position within segment
      segment_width = end_point[0] - start_point[0]
      return start_point[1] if segment_width == 0
      
      segment_pos = (pos - start_point[0]) / segment_width
      
      # Apply curve function to segment position
      curve_func = end_point[2]
      curved_pos = if curve_func.respond_to?(:call)
        curve_func.call(segment_pos)
      else
        segment_pos
      end
      
      # Interpolate between start and end values
      start_point[1] + curved_pos * (end_point[1] - start_point[1])
    end
  end
  
  # Sample a curve function to an array
  def to_array(curve_func, num_samples, map_func: nil)
    Array.new(num_samples) do |i|
      sample = curve_func.call(i.to_f / num_samples)
      map_func ? map_func.call(sample) : sample
    end
  end
  
  # Chain multiple curves together
  def chain(*curves)
    lambda do |pos|
      curves.reduce(pos) { |val, curve| curve.call(val) }
    end
  end
  
  # Mix multiple curves with weights
  def mix(*curves_and_weights)
    curves = curves_and_weights.select.with_index { |_, i| i.even? }
    weights = curves_and_weights.select.with_index { |_, i| i.odd? }
    weights = Array.new(curves.size, 1.0) if weights.empty?
    
    total_weight = weights.sum.to_f
    normalized_weights = weights.map { |w| w / total_weight }
    
    lambda do |pos|
      curves.zip(normalized_weights).sum { |curve, weight| 
        curve.call(pos) * weight 
      }
    end
  end
  
  # Sonic Pi specific extensions
  
  # Create an envelope that maps to Sonic Pi's ADSR parameters
  def adsr(attack: 0.01, decay: 0.1, sustain: 0.7, release: 0.2, 
           sustain_level: 0.8, curve: :linear)
    total = attack + decay + sustain + release
    a_norm = attack / total
    d_norm = decay / total
    s_norm = sustain / total
    
    curve_func = case curve
    when :step then pulse
    when :linear then ramp
    when :sine then sine
    when :exponential then ease_in
    when :logarithmic then ease_out
    else ramp
    end
    
    breakpoints(
      [0, 0],
      [a_norm, 1, curve_func],
      [a_norm + d_norm, sustain_level, curve_func],
      [a_norm + d_norm + s_norm, sustain_level],
      [1, 0, curve_func]
    )
  end
  
  # LFO helper for common modulation patterns
  def lfo(shape: :sine, rate: 1, depth: 1, offset: 0)
    base_func = case shape
    when :sine then sine(rate: rate)
    when :triangle then triangle(rate: rate)
    when :saw then saw(rate: rate)
    when :pulse then pulse(rate: rate)
    when :noise then noise
    else sine(rate: rate)
    end

    lambda do |pos|
      (base_func.call(pos) - 0.5) * depth + offset
    end
  end
  
  # Sequencer - cycles through values at specified rate
  def sequencer(values, smooth: false)
    if smooth
      timeseries(values)
    else
      lambda do |pos|
        index = (pos * values.size).floor % values.size
        values[index]
      end
    end
  end
end

# Convenience module for cleaner syntax in Sonic Pi
module SPCurves
  include SonicPiCurves
  extend self
end