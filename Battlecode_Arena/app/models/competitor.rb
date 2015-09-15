class Competitor < ActiveRecord::Base
    mount_uploader :ai, AiUploader
    
    validate :ai_size
    
    def ai_size
        if ai.size > 5.megabytes
            errors.add(:ai,"should be less than 5MB")
        end
    end
end
