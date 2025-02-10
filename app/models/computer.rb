class Computer < ApplicationRecord
    validates :mouse, presence: true,
                      if: [ Proc.new { |c| c.market.retail? }, :desktop? ],
                      unless: Proc.new { |c| c.trackpad.present? }
end
