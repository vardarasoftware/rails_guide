class BlogPost < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    has_many :comments, dependent: :destroy

    def featured?
        self.featured == true
    end

    def image_url
        self[:image_url].presence || "default_image.png"
    end
end
