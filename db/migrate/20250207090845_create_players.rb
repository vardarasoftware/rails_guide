class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.decimal :points
      t.integer :games_played

      t.timestamps
    end
  end
end
