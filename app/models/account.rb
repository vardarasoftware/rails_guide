class Account < ApplicationRecord
    validates :subdomain, exclusion: { in: %w[ www us ca jp ], message: "%{value} is reserved." }
    validates :email, uniqueness: true
    validates :password, confirmation: true, unless: -> { password.blank? }
end
