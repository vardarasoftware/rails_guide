class Author < ApplicationRecord
    has_many :books, before_add: [:check_limit, :calculate_shipping_charges]

  def check_limit(_book)
    if books.count >= 5
      errors.add(:base, "Cannot add more than 5 books for this author")
      throw(:abort)
    end
  end

  def calculate_shipping_charges(book)
    weight_in_pounds = book.weight_in_pounds || 1
    shipping_charges = weight_in_pounds * 2

    shipping_charges
  end
end
