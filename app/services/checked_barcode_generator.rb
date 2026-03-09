class CheckedBarcodeGenerator
  include UseCase

  VALID_EAN_PREFIXES = [ "978", "979" ].freeze

  attr_reader :result

  def initialize(unchecked_isbn_barcode)
    @unchecked_isbn_barcode = unchecked_isbn_barcode.to_s
  end

  def perform
    check_length
    check_numeric
    check_valid_ean_prefix
    @result = join_check_digit(generate_check_digit) if success?
  end

  private

  attr_reader :unchecked_isbn_barcode

  def check_length
    length = unchecked_isbn_barcode.length
    if length != 12
      errors.add(:base, "Submitted code is #{length} characters - an unchecked ISBN-13 barcode should be exactly 12 digits")
    end
  end

  def check_numeric
    errors.add(:base, "Submitted code contains non-numeric characters") unless unchecked_isbn_barcode.match?(/\A\d+\z/)
  end

  def check_valid_ean_prefix
    ean_prefix = unchecked_isbn_barcode[0..2]
    unless VALID_EAN_PREFIXES.include?(ean_prefix)
      errors.add(:base, "invalid EAN prefix of #{ean_prefix} - should be one of #{VALID_EAN_PREFIXES.join(', ')}")
    end
  end

  def generate_check_digit
    digits = unchecked_isbn_barcode.chars.map(&:to_i)
    multiplied_digits = digits.map.with_index do |digit, index|
      index.even? ? digit : digit * 3
    end
    remainder = multiplied_digits.sum % 10
    remainder.zero? ? 0 : 10 - remainder
  end

  def join_check_digit(check_digit)
    "#{unchecked_isbn_barcode}#{check_digit}"
  end
end
