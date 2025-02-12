class Comment < ApplicationRecord
    before_save :filter_content, if: [:subject_to_parental_control?, :untrusted_author?]

    private

    def subject_to_parental_control?
        false
    end

    def filter_content
        self.content = "[Content Removed: Violates Guidelines]"
    end
end
