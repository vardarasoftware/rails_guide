class MyOtherValidator < ActiveModel::Validator
    def validate(record)
      if record.name.length < 3
        record.errors.add(:name, "must be at least 3 characters long")
      end
    end
end
