class Player < ApplicationRecord
    validates :points, numericality: true
    validates :games_played, numericality: { only_integer: true }
end
