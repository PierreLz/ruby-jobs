# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Prices calculator", type: :model do
  let(:data)          { JSON.parse(File.read('data.json')) }
  let(:output)        { JSON.parse(File.read('output.json')) }

  it "should load correctly the data" do
    price_calculator = PricesCalculator.new("data.json")
    price_calculator.practitioners.should have_key(:id)
    price_calculator.communications.should_not be_empty
  end
end
