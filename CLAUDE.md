# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**SonicPiCurves** is a Ruby library for generating composable signal curves, envelopes, and modulation functions for [Sonic Pi](https://sonic-pi.net/). It's a Ruby adaptation of Python `signal.py` and Lua `curves.lua` libraries, optimized for live coding and algorithmic music composition.

## Architecture

### Module Structure
- All functions are defined at **top-level** (global scope) for Sonic Pi compatibility
- Sonic Pi doesn't support `include` or `extend` for modules in its sandboxed runtime
- All curve generators return **lambdas** that map position (0-1) → output values (typically 0-1)
- Everything is **composable**: curves can be chained, mixed, and nested

### Core Concepts

1. **Functional Design**: Curves are pure functions (lambdas), not classes or objects
2. **Position-based**: All curves accept `pos` (0-1 normalized position) as input
3. **Dynamic Parameters**: Any parameter (amp, rate, phase, bias) can be a static value OR a lambda
4. **Modulation Pattern**: `calc_pos()` applies rate/phase → curve function → `amp_bias()` applies amp/bias

### File Organization

- **[sonic_pi_curves.rb](sonic_pi_curves.rb)**: Core library (274 lines)
  - Helper functions: `clamp`, `calc_pos`, `amp_bias`, `pos2rad`, `normalize`
  - Waveforms: `sine`, `triangle`, `saw`, `pulse`, `ramp`
  - Easing: `ease_in`, `ease_out`, `ease_in_out`, `ease_out_in`
  - Envelopes: `adsr`, `breakpoints`, `timeseries`
  - Composition: `chain`, `mix`, `sequencer`
- **[sonic_pi_curves_test.rb](sonic_pi_curves_test.rb)**: Test suite (standalone, requires `require_relative`)
- **[sonic_pi_curves_examples.rb](sonic_pi_curves_examples.rb)**: Sonic Pi usage examples
- **[sonic_pi_curves_reference.md](sonic_pi_curves_reference.md)**: Quick reference guide

## Development Commands

### Testing
```bash
# Run full test suite
ruby sonic_pi_curves_test.rb

# Test in Sonic Pi (load in editor)
load "~/path/to/sonic_pi_curves.rb"
# All functions available immediately
```

### Sonic Pi Integration
Users load this library into Sonic Pi:
```ruby
load "~/sonic_pi_curves.rb"
# All functions are available immediately (no include needed)
```

No build system, linting, or dependencies—just pure Ruby stdlib.

## Key Design Patterns

### Curve Generator Pattern
All generators follow this structure:
```ruby
def curve_name(specific_params, amp: 1, rate: 1, phase: 0, bias: 0)
  lambda do |pos|
    pos = calc_pos(pos, rate, phase)      # Apply rate/phase
    value = # ... calculate base curve value ...
    amp_bias(value, amp, bias, pos)       # Apply amp/bias
  end
end
```

### Dynamic Parameters
Parameters can be static or callable:
```ruby
# Static
sine(amp: 0.5)

# Dynamic (changes over time)
sine(amp: lambda { |pos| pos * 0.5 })
```

### Composition Strategies

1. **Chain**: Sequential application `f(g(h(x)))`
   ```ruby
   chain(sine(rate: 4), ease_in_out(exp: 2))
   ```

2. **Mix**: Weighted sum of multiple curves
   ```ruby
   mix(sine(rate: 1), 0.5, triangle(rate: 4), 0.3, noise, 0.2)
   ```

3. **Breakpoints**: Piecewise interpolation with optional easing per segment
   ```ruby
   breakpoints([0, 0], [0.2, 1, ease_in], [1, 0])
   ```

## Common Modifications

### Adding New Waveforms
1. Follow the curve generator pattern above
2. Use `calc_pos()` for rate/phase, `amp_bias()` for amp/bias
3. Keep output normalized to 0-1 range (before amp/bias)
4. Add tests in [sonic_pi_curves_test.rb](sonic_pi_curves_test.rb)

### Bug Fixes from Original Python
The Ruby version fixed position wrapping issues in the Python implementation. When modifying modulation logic, verify:
- Phase wrapping uses `% 1.0` after addition
- Rate is applied before phase offset
- Clamping happens before modulation

### Testing Philosophy
- Tests verify **mathematical correctness** (range, normalization, interpolation)
- Tests check **callable parameter handling**
- Tests ensure **composition functions work together**
- Run tests after any curve generator changes

## Ruby Environment

- **Requires**: Ruby 2.x+ (stdlib only, no gems)
- **Target**: Sonic Pi runtime (embedded Ruby interpreter)
- **Style**: Functional programming with lambdas, minimal OOP
