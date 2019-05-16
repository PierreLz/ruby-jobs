# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Prices calculator", type: :model do
  let(:data)          { JSON.parse(File.read('data.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }

  it "should load correctly the data" do
    price_calculator = PricesCalculator.new("data.json")
    expect(price_calculator.practitioners).not_to be_empty
    expect(price_calculator.communications).not_to be_empty
  end

  it "should calculate the price of one communication" do
    price_calculator = PricesCalculator.new("data.json")
    c = data["communications"].first
    obj_c = Communication.new(c)
    price_calculator.total_single_communication(obj_c) == 2.84
  end

  it "should output the right calculation in JSON format" do
    price_calculator = PricesCalculator.new("data.json")
    price_calculator.outputs_turnover_by_dates.should == output.to_json
  end
end
