class Competitor < ActiveRecord::Base
    mount_uploader :ai, AiUploader
    
    after_initialize :init
    
    validates :name,
        :presence => true,
        length: { maximum: 50 },
        uniqueness: { case_sensitive: false}
    validates :team, length: { maximum: 50 }
    validate :ai_size
    validates :ai, presence: true
    
    
    def ai_size
        if ai.size > 5.megabytes
            errors.add(:ai,"should be less than 5MB")
        end
    end
    
    def init
        self.Elo = 1500 if self.Elo.nil?
        self.wins = 0 if self.wins.nil?
        self.losses = 0 if self.losses.nil?
        self.active = true if self.active.nil?
        self.broken = false if self.broken.nil?
        self.name = self.ai.to_s.split('/').last.to_s.sub('arena_submission_','').to_s.split('.jar').first.to_s if self.name.nil?
        self.submission = 1 if self.submission.nil?
        self.full_name = get_full_name() if self.full_name.nil?
    end
    
    def increment_submission_value()
        self.submission = self.submission + 1
        self.full_name = get_full_name()
        self.wins = 0
        self.losses = 0
        self.save
    end

    def update_to_pre_existing_version()
        pre_existing_version = Competitor.where("name = ?", self.name).first
        return self if pre_existing_version.nil?
        
#        puts competitor_params
#        puts pre_existing_version
#        pre_existing_version.increment_submission_value()
#        pre_existing_version.update(competitor_params)

        return pre_existing_version
    end
    
    def check_for_pre_existing_version()
        pre_existing_version = Competitor.where("name = ?", self.name).first
        return false if pre_existing_version.nil?
        true
    end
    
    
    def get_full_name()
        return "#{self.name}.#{self.submission}"
    end
    
    def get_number_of_games_won()
       return Game.where("(full_name_a = ? OR full_name_b = ?) AND winner = ?", get_full_name(),get_full_name(),self.competitor_name).count
    end
    
    def get_number_of_games_lost()
       return Game.where("(full_name_a = ? OR full_name_b = ?) AND winner != ?", get_full_name(),get_full_name(),self.competitor_name).count
    end
end