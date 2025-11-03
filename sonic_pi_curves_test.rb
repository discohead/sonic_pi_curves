# sonic_pi_curves_test.rb
# Simple test suite for SonicPiCurves library
# Run this to verify all functions work correctly

require_relative 'sonic_pi_curves'
include SonicPiCurves

def test(name, &block)
  begin
    block.call
    puts "✓ #{name}"
  rescue => e
    puts "✗ #{name}: #{e.message}"
    puts e.backtrace.first(3)
  end
end

def assert(condition, message = "Assertion failed")
  raise message unless condition
end

def assert_in_range(value, min, max, message = nil)
  msg = message || "Expected #{value} to be between #{min} and #{max}"
  assert(value >= min && value <= max, msg)
end

puts "Testing SonicPiCurves Library"
puts "=" * 40

# Test basic helper functions
test "clamp keeps values in 0-1 range" do
  assert(clamp(-0.5) == 0.0)
  assert(clamp(0.5) == 0.5)
  assert(clamp(1.5) == 1.0)
end

test "callable? correctly identifies procs and lambdas" do
  assert(callable?(lambda { |x| x }))
  assert(callable?(proc { |x| x }))
  assert(!callable?(5))
  assert(!callable?("string"))
end

test "normalize scales values to 0-1" do
  result = normalize([0, 50, 100])
  assert(result == [0.0, 0.5, 1.0])
  
  result = normalize([-10, 0, 10])
  assert(result == [0.0, 0.5, 1.0])
end

# Test curve generators
test "ramp produces linear 0-1 output" do
  curve = ramp
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 0.5)
  assert(curve.call(1.0) == 1.0)
end

test "saw produces inverse linear 1-0 output" do
  curve = saw
  assert(curve.call(0.0) == 1.0)
  assert(curve.call(0.5) == 0.5)
  assert(curve.call(1.0) == 0.0)
end

test "sine produces smooth wave" do
  curve = sine
  assert_in_range(curve.call(0.0), 0.49, 0.51)  # Should be ~0.5
  assert_in_range(curve.call(0.25), 0.99, 1.01) # Should be ~1.0
  assert_in_range(curve.call(0.5), 0.49, 0.51)  # Should be ~0.5
  assert_in_range(curve.call(0.75), -0.01, 0.01) # Should be ~0.0
end

test "triangle with default symmetry" do
  curve = triangle
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 1.0)
  assert(curve.call(1.0) == 0.0)
end

test "triangle with custom symmetry" do
  curve = triangle(symmetry: 0.25)
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.25) == 1.0)
  assert_in_range(curve.call(0.5), 0.65, 0.67)
  assert(curve.call(1.0) == 0.0)
end

test "pulse generates square wave" do
  curve = pulse(width: 0.5)
  assert(curve.call(0.25) == 0.0)
  assert(curve.call(0.75) == 1.0)
end

test "ease_in starts slow" do
  curve = ease_in(exp: 2)
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 0.25)
  assert(curve.call(1.0) == 1.0)
end

test "ease_out starts fast" do
  curve = ease_out(exp: 2)
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 0.75)
  assert(curve.call(1.0) == 1.0)
end

test "noise generates random values" do
  curve = noise
  values = (0..10).map { curve.call(0.5) }
  assert(values.uniq.size > 1, "Noise should produce different values")
  values.each { |v| assert_in_range(v, 0, 1) }
end

test "amplitude modulation works" do
  curve = ramp(amp: 0.5)
  assert(curve.call(0.5) == 0.25)
  
  curve = ramp(amp: 2)
  assert(curve.call(0.5) == 1.0)
end

test "bias offset works" do
  curve = ramp(bias: 0.5)
  assert(curve.call(0.0) == 0.5)
  assert(curve.call(0.5) == 1.0)
end

test "rate modulation works" do
  curve = sine(rate: 2)
  # With rate=2, we complete 2 full cycles
  assert_in_range(curve.call(0.0), 0.49, 0.51)   # Start of first cycle
  assert_in_range(curve.call(0.25), 0.49, 0.51)  # Start of second cycle
  assert_in_range(curve.call(0.5), 0.49, 0.51)   # Start of third cycle (wraps)
end

test "breakpoints creates multi-segment envelope" do
  curve = breakpoints(
    [0, 0],
    [0.5, 1],
    [1, 0]
  )
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 1.0)
  assert(curve.call(1.0) == 0.0)
  assert(curve.call(0.25) == 0.5)
end

test "breakpoints with curve functions" do
  curve = breakpoints(
    [0, 0],
    [0.5, 1, ease_in(exp: 2)],
    [1, 0]
  )
  assert(curve.call(0.0) == 0.0)
  # With ease_in, 0.25 should be less than 0.5
  assert(curve.call(0.125) < 0.3)
end

test "timeseries interpolates values" do
  curve = timeseries([0, 1, 0])
  assert(curve.call(0.0) == 0.0)
  assert(curve.call(0.5) == 1.0)
  assert(curve.call(1.0) == 0.0)
  assert(curve.call(0.25) == 0.5)
end

test "to_array samples curve correctly" do
  curve = ramp
  samples = to_array(curve, 5)
  assert(samples.size == 5)
  assert(samples == [0.0, 0.2, 0.4, 0.6, 0.8])
end

test "chain composes multiple curves" do
  # Chain two curves that each multiply by 0.5
  curve = chain(
    lambda { |x| x * 0.5 },
    lambda { |x| x * 0.5 }
  )
  assert(curve.call(1.0) == 0.25)
end

test "mix blends multiple curves" do
  # Mix constant 0 and constant 1 with equal weight
  curve = mix(
    const(value: 0), 1,
    const(value: 1), 1
  )
  assert(curve.call(0.5) == 0.5)
  
  # Mix with different weights
  curve = mix(
    const(value: 0), 1,
    const(value: 1), 3
  )
  assert(curve.call(0.5) == 0.75)
end

test "adsr envelope shape" do
  curve = adsr(attack: 0.25, decay: 0.25, sustain: 0.25, release: 0.25, sustain_level: 0.8)
  
  # Should start at 0
  assert(curve.call(0.0) == 0.0)
  
  # Should reach 1.0 at end of attack (0.25)
  assert_in_range(curve.call(0.25), 0.99, 1.01)
  
  # Should be at sustain level during sustain phase
  assert_in_range(curve.call(0.6), 0.79, 0.81)
  
  # Should return to 0 at end
  assert(curve.call(1.0) == 0.0)
end

test "lfo generates modulation" do
  curve = lfo(shape: :sine, rate: 1, depth: 0.5, offset: 0.5)
  
  # Should oscillate around offset with given depth
  values = (0..4).map { |i| curve.call(i / 4.0) }
  values.each { |v| assert_in_range(v, 0.25, 0.75) }
end

test "sequencer steps through values" do
  curve = sequencer([0, 0.5, 1], smooth: false)
  
  assert(curve.call(0.0) == 0)
  assert(curve.call(0.4) == 0.5)
  assert(curve.call(0.7) == 1)
end

test "sequencer with smoothing" do
  curve = sequencer([0, 1], smooth: true)
  
  assert(curve.call(0.0) == 0)
  assert(curve.call(0.5) == 0.5)
  assert(curve.call(1.0) == 1.0)
end

test "callable parameters work" do
  # Amplitude that changes over position
  amp_func = lambda { |pos| pos }
  curve = ramp(amp: amp_func)
  
  assert(curve.call(0.5) == 0.25)  # 0.5 * 0.5
  assert(curve.call(1.0) == 1.0)   # 1.0 * 1.0
end

test "phase modulation works" do
  curve = ramp(phase: 0.5)
  assert(curve.call(0.0) == 0.5)   # Shifted by 0.5
  assert(curve.call(0.5) == 0.0)   # Wraps around
end

puts
puts "=" * 40
puts "Testing complete!"