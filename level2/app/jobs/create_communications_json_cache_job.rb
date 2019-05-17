class CreateCommunicationsJsonCacheJob < ApplicationJob
  queue_as :default

  def perform(*args)
    communications = Communication.all
    Rails.cache.fetch(Communication.cache_key(communications)) do
      communications.to_json
    end
  end
end
