class BlogPost < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true

    def featured?
        self.featured == true
    end
end
