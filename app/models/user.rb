class User < ApplicationRecord
    self.primary_key = "guid"
    has_and_belongs_to_many :friends,
    class_name: "User",
    foreign_key: "this_user_id",
    association_foreign_key: "other_user_id"
end
