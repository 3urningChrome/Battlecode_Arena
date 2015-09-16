class Competitor < ActiveRecord::Base
    mount_uploader :ai, AiUploader
    
    validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :team, length: { maximum: 50 }
    validate :ai_size
    validates :ai, presence: true
    
    def ai_size
        if ai.size > 5.megabytes
            errors.add(:ai,"should be less than 5MB")
        end
    end
end
