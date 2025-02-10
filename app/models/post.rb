class Post < ApplicationRecord
  belongs_to :author,  type: :uuid
end
