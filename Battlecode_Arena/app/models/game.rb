class Game < ActiveRecord::Base
    
    
    before_save :create_full_team_names
    validates :teamA, presence: true
    validates :teamB, presence: true
    validate :different_teams
    
    def different_teams
        if teamA.eql?(teamB)
            errors.add(:teamB, "Should not be the same as team a")
        end
    end
    
    def create_full_team_names()
        if not self.teamA.nil?
            target = Competitor.where("name = ?",self.teamA).first
            if not target.nil?
                self.full_name_A = target.full_name unless target.nil?
            end
        end
        if not self.teamB.nil?
            target = Competitor.where("name = ?",self.teamB).first
            self.full_name_B = target.full_name unless target.nil?
        end        
    end
    
    def get_game_id()
        return "#{self.full_name_A}.#{self.full_name_B}.#{self.map}"
    end
end
