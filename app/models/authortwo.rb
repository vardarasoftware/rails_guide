require_dependency "find_recent_extension"
class Authortwo < ApplicationRecord
    has_many :book_twos, -> { extending FindRecentExtension }
    validates :name, presence: true
end
