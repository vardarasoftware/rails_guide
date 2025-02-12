class PictureFile < ApplicationRecord
    after_commit FileDestroyerCallback.new
end
  