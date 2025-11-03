# SonicPiCurves - Ruby Signal Generation Library

## Overview

This is a Ruby adaptation of the Python `signal.py` and Lua `curves.lua` libraries, specifically optimized for use in Sonic Pi. The library provides composable functions for generating curves, envelopes, and modulation signals commonly used in algorithmic music composition and live coding.

## Files Included

1. **sonic_pi_curves.rb** - Main library implementation
2. **sonic_pi_curves_examples.rb** - Extensive usage examples for Sonic Pi
3. **sonic_pi_curves_test.rb** - Test suite (requires Ruby environment)
4. **sonic_pi_curves_reference.md** - Quick reference guide

## Key Features

### Core Functionality
- **Waveform Generators**: sine, triangle, saw, pulse, ramp
- **Easing Functions**: ease_in, ease_out, ease_in_out, ease_out_in
- **Envelope Generators**: ADSR, breakpoints, custom curves
- **Modulation**: amplitude, rate, phase, and bias parameters
- **Random/Noise**: uniform and triangular distributions
- **Composition Tools**: chain, mix, sequencer

### Ruby/Sonic Pi Specific Improvements
- **Idiomatic Ruby**: Uses keyword arguments for cleaner API
- **Module Organization**: Clean namespace with `SonicPiCurves` and `SPCurves`
- **Sonic Pi Integration**: ADSR envelopes, LFO helpers, sequencer patterns
- **Live Coding Optimized**: Designed for real-time parameter modulation
- **Functional Composition**: All curves are composable lambdas

## Installation

1. Copy `sonic_pi_curves.rb` to your Sonic Pi workspace
2. Load in your Sonic Pi script:
```ruby
load "~/sonic_pi_curves.rb"
include SonicPiCurves  # or SPCurves for short
```

## Basic Usage

```ruby
# Create a sine LFO
lfo = sine(rate: 2)

# Use it to modulate parameters
live_loop :example do
  16.times do |i|
    pos = i / 16.0
    cutoff = 40 + lfo.call(pos) * 80
    play 60, cutoff: cutoff
    sleep 0.25
  end
end
```

## Advanced Features

### Dynamic Parameters
Any parameter can be a function:
```ruby
# Rate that increases over time
dynamic_sine = sine(
  rate: lambda { |pos| 1 + pos * 3 }
)
```

### Curve Composition
```ruby
# Chain curves together
wobble = chain(
  sine(rate: 4),
  ease_in_out(exp: 2)
)

# Mix multiple curves
complex = mix(
  sine(rate: 1), 0.5,      # 50% weight
  triangle(rate: 4), 0.3,  # 30% weight
  noise, 0.2               # 20% weight
)
```

### Breakpoint Envelopes
```ruby
envelope = breakpoints(
  [0, 0],                      # Start at 0
  [0.2, 1, ease_in(exp: 2)],  # Rise to 1 with easing
  [0.7, 0.3, ease_out],        # Fall to 0.3
  [1, 0]                       # End at 0
)
```

## Design Philosophy

This library follows several key principles:

1. **Functional Programming**: All curves are pure functions (lambdas)
2. **Composability**: Curves can be combined and chained
3. **Normalization**: Input/output typically in 0-1 range for predictability
4. **Live Coding Friendly**: Optimized for real-time use in Sonic Pi
5. **Ruby Idiomatic**: Uses Ruby's strengths (blocks, keyword args, modules)

## Improvements Over Original

1. **Bug Fixes**: Corrected position wrapping issues in the original Python
2. **Better API**: Keyword arguments instead of positional
3. **Sonic Pi Features**: Added ADSR, LFO, and sequencer helpers
4. **Composition Tools**: Added chain and mix functions
5. **Documentation**: Comprehensive examples and reference guide

## Performance Tips

- Pre-calculate curves outside of live_loops
- Use `to_array()` to cache values when curves won't change
- Leverage Sonic Pi's `tick` for position tracking
- Combine with `control` for smooth parameter automation

## Mathematical Accuracy

The Ruby implementation preserves all the mathematical concepts from the original:
- Correct clamp and normalization
- Proper sine/cosine calculations
- Accurate interpolation for breakpoints and timeseries
- Correct easing curve mathematics

## Future Enhancements

Potential additions for future versions:
- Bezier curves
- Catmull-Rom splines
- More waveform types (band-limited versions)
- FFT-based spectral curves
- Physics-based curves (gravity, bounce, spring)

## License

This Ruby adaptation maintains the spirit of the original open-source implementations.
Feel free to use, modify, and share in your Sonic Pi performances and compositions.

## Contributing

This library is designed to be extended. Feel free to add your own curve generators
following the same pattern: functions that return lambdas mapping 0-1 to output values.

Happy live coding!