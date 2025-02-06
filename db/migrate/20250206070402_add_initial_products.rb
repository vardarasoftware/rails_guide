class AddInitialProducts < ActiveRecord::Migration[8.0]
  def up
    5.times do |i|
      Product.create(name: "Product ##{i}", description: "A sample product.")
    end
  end

  def down
    Product.delete_all
  end
end
