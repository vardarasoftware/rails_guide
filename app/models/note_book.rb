class NoteBook < ApplicationRecord
    validates :author, presence: true
end
