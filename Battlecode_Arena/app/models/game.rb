class Game < ActiveRecord::Base
    
    
    before_save :create_full_team_names
    validates :teama, presence: true
    validates :teamb, presence: true
    validate :different_teams
    
    def different_teams
        if teama.eql?(teamb)
            errors.add(:teamb, "Should not be the same as team a")
        end
    end
    
    def create_full_team_names()
        if not self.teama.nil?
            target = Competitor.where("name = ?",self.teama).first
            if not target.nil?
                self.full_name_a = target.full_name unless target.nil?
            end
        end
        if not self.teamb.nil?
            target = Competitor.where("name = ?",self.teamb).first
            self.full_name_b = target.full_name unless target.nil?
        end        
    end
    
    def get_game_id()
        return "#{self.full_name_a}.#{self.full_name_b}.#{self.map}"
    end
end
