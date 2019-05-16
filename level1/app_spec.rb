# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Prices calculator", type: :model do
  let(:data)          { JSON.parse(File.read('data.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }

  price_calculator = PricesCalculator.new("data.json")

  describe "load correctly the data" do
    it "should load practitioners" do
    expect(price_calculator.practitioners).not_to be_empty
    end
    it "should load communications" do
    expect(price_calculator.communications).not_to be_empty
    end
  end

  describe "valid calculation" do
    it "should calculate the price of one communication" do
      c = data["communications"].first
      obj_c = Communication.new(c)
      price_calculator.total_single_communication(obj_c) == 2.84
    end
  end

  describe "JSON" do
    it "should output valid JSON format" do
      price_calculator.outputs_turnover_by_dates.should == output.to_json
    end
  end
end
