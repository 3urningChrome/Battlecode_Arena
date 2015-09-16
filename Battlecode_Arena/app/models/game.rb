class Game < ActiveRecord::Base
    validates :teamA, presence: true
    validates :teamB, presence: true
    validate :different_teams
    
    def different_teams
        if teamA.eql?(teamB)
            errors.add(:teamB, "Should not be the same as teama")
        end
    end
end
