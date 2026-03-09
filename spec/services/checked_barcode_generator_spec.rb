require "rails_helper"

RSpec.describe CheckedBarcodeGenerator do
  subject(:generate) { described_class.perform(unchecked_isbn_barcode) }

  let(:unchecked_isbn_barcode) { "978014300723" }

  describe "#perform" do
    context "with a valid ISBN-13 barcode without a check digit" do
      it "generates the correct check digit and appends it" do
        generator = generate
        expect(generator.success?).to be true
        expect(generator.result).to eq("9780143007234")
      end
    end

    context "with Old Man's War by John Scalzi (Tor paperback)" do
      let(:unchecked_isbn_barcode) { "978076531524" }

      it "generates check digit 3" do
        generator = generate
        expect(generator.success?).to be true
        expect(generator.result).to eq("9780765315243")
      end
    end

    context "with The Colour of Magic by Terry Pratchett (Corgi edition)" do
      let(:unchecked_isbn_barcode) { "978055216659" }

      it "generates check digit 1" do
        generator = generate
        expect(generator.success?).to be true
        expect(generator.result).to eq("9780552166591")
      end
    end

    context "with a 979 EAN prefix" do
      let(:unchecked_isbn_barcode) { "979888645174" }

      it "generates the correct check digit" do
        generator = generate
        expect(generator.success?).to be true
        expect(generator.result).to eq("9798886451740")
      end
    end

    context "when the check digit is 0" do
      let(:unchecked_isbn_barcode) { "978020137960" }

      it "returns 0 instead of 10" do
        generator = generate
        expect(generator.success?).to be true
        expect(generator.result).to eq("9780201379600")
      end
    end
  end

  describe "validations" do
    context "with too long a barcode" do
      let(:unchecked_isbn_barcode) { "9781234567890" }

      it "is not valid" do
        generator = generate
        expect(generator.success?).to be false
        expect(generator.errors.full_messages).to include("Submitted code is 13 characters - an unchecked ISBN-13 barcode should be exactly 12 digits")
      end
    end

    context "with too short a barcode" do
      let(:unchecked_isbn_barcode) { "97801430072" }

      it "is not valid" do
        generator = generate
        expect(generator.success?).to be false
        expect(generator.errors.full_messages).to include("Submitted code is 11 characters - an unchecked ISBN-13 barcode should be exactly 12 digits")
      end
    end

    context "with a non-numeric barcode" do
      let(:unchecked_isbn_barcode) { "9780143007AB" }

      it "is not valid" do
        generator = generate
        expect(generator.success?).to be false
        expect(generator.errors.full_messages).to include("Submitted code contains non-numeric characters")
      end
    end

    context "with an invalid EAN prefix" do
      let(:unchecked_isbn_barcode) { "980014300723" }

      it "is not valid" do
        generator = generate
        expect(generator.success?).to be false
        expect(generator.errors.full_messages).to include("invalid EAN prefix of 980 - should be one of 978, 979")
      end
    end
  end
end
