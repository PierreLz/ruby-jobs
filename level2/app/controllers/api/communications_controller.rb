class Api::CommunicationsController < ApplicationController

  def create
    practitioner = Practitioner.where(first_name: communication_params[:first_name], last_name: communication_params[:last_name]).first
    communication = Communication.new(practitioner_id: practitioner.id, sent_at: communication_params[:sent_at])
    if communication.save
      render json: communication.to_json, status: :created
    else
      render json: communication.errors, status: :unprocessable_entity
    end
  end

  def index
    communications = Communication.all
    json = Rails.cache.fetch(Communication.cache_key(communications)) do
      communications.to_json
    end
    render json: json
  end

  def communication_params
    params.require(:communication).permit(:first_name, :last_name, :sent_at)
  end
end
