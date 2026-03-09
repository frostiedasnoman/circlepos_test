namespace :isbn do
  desc "Generate check digit for an ISBN-13 barcode prefix. Usage: rake isbn:check_digit[978014300723]"
  task :check_digit, [ :barcode_prefix ] => :environment do |_t, args|
    unless args[:barcode_prefix]
      puts "Usage: rake isbn:check_digit[978014300723]"
      exit 1
    end

    generator = CheckedBarcodeGenerator.perform(args[:barcode_prefix])

    if generator.success?
      puts generator.result
    else
      generator.errors.full_messages.each { |msg| puts "Error: #{msg}" }
      exit 1
    end
  end
end
