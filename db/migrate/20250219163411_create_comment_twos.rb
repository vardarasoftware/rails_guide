class CreateCommentTwos < ActiveRecord::Migration[8.0]
  def change
    create_table :comment_twos do |t|
      t.string :content

      t.timestamps
    end
  end
end
