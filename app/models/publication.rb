class Publication < ApplicationRecord
  belongs_to :publication_type
  belongs_to :publisher, polymorphic: true
end
