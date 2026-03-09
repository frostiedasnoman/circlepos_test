# CirclePOS Test — ISBN-13 Check Digit Generator

A Rails service that calculates the check digit for an ISBN-13 barcode.

## Requirements

- Ruby 3.4.5
- Rails 8.0

## Setup

```bash
bundle install
```

## Running Tests

```bash
bundle exec rspec
```

## Algorithm

Given a 12-digit ISBN prefix (e.g. `978014300723`):

1. Multiply each digit alternately by 1 and 3
2. Sum the results
3. Take modulo 10
4. Subtract from 10 (if result is 10, use 0)

Example: `978014300723` → check digit `4` → `9780143007234`

See [docs/check_digit_generator.md](docs/check_digit_generator.md) for detailed documentation and a process flow chart.

## Usage

```ruby
generator = CheckedBarcodeGenerator.perform("978014300723")
generator.success? # => true
generator.result   # => "9780143007234"
```

The service validates that the input is exactly 12 numeric digits with a valid EAN prefix (`978` or `979`).
