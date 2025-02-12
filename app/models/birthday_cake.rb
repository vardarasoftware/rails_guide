class BirthdayCake < ApplicationRecord
    after_create -> { Rails.logger.info("Congratulations, the callback has run!") }
  end
  