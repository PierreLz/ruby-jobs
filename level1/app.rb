require "json"

module Pricing
  COMMUNICATION = 0.10
  COLORMODE = 0.18
  PAGESUP = 0.07
  EXPRESSDELIVERY = 0.60
end

class PricesCalculator
  include Pricing
  attr_reader :practitioners, :communications

  def initialize(filename)
    @practitioners = Hash.new
    @communications = Array.new

    json = JSON.parse(File.read(filename))

    json["practitioners"].each do |item|
      @practitioners[item["id"]] = Practitioner.new(item)
    end

    json["communications"].each do |item|
      @communications << Communication.new(item)
    end
  end

  def outputs_turnover_by_dates
    totals_by_date = Hash.new

    @communications.group_by{|x, v| x.sent_on }.each do |date, array|
      sum = array.collect {|x| total_single_communication(x)}.reduce(:+).round(2)
      totals_by_date[date] = sum
    end

    output = Hash.new
    output["totals"] = totals_by_date.to_a.map { |date, total| { "sent_on" => date, "total" => total }}
    output.to_json
  end

  private

  def total_single_communication(communication)
    price = Pricing::COMMUNICATION
    practitioner_id = communication.practitioner_id
    practitioner = @practitioners[communication.practitioner_id]

    if communication.color
      price += Pricing::COLORMODE
    end

    if communication.pages_number > 1
      price += (communication.pages_number - 1) * Pricing::PAGESUP
    end

    if practitioner.express_delivery
      price += Pricing::EXPRESSDELIVERY
    end
    price.round(2)
  end
end

class Practitioner
  attr_reader :first_name, :last_name, :id, :express_delivery

  def initialize(args= {})
    @id = args["id"]
    @first_name = args["first_name"]
    @last_name = args["last_name"]
    @express_delivery = args["express_delivery"]
  end
end

class Communication
  attr_reader :id, :practitioner_id, :pages_number, :color, :sent_at, :sent_on
  def initialize(args = {})
    @id = args["id"]
    @practitioner_id = args["practitioner_id"]
    @pages_number = args["pages_number"]
    @color = args["color"]
    @sent_at = args["sent_at"].split(" ").last
    @sent_on = args["sent_at"].split(" ").first
  end

  def date
    self.sent_at.split(" ").first
  end
end

price_calculator = PricesCalculator.new("data.json")
price_calculator.outputs_turnover_by_dates

out_file = File.new("/home/pierre/code/PierreLz/honestica/ruby-jobs/level1/out.txt", "w")
out_file.puts(price_calculator.outputs_turnover_by_dates)
out_file.close





