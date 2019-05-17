class Communication < ApplicationRecord
  belongs_to :practitioner, touch: true
  after_save :create_json_cache

  def as_json(options = nil)
    {
      first_name: practitioner.first_name,
      last_name: practitioner.last_name,
      sent_at: sent_at
    }
  end

  def self.cache_key(communications)
    {
      serializer: 'communications',
      stat_record: communications.maximum(:updated_at)
    }
  end

  def create_json_cache
    CreateCommunicationsJsonCacheJob.perform_later
  end

end
