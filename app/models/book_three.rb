class BookThree < ApplicationRecord
  belongs_to :supplier_two
  belongs_to :author_three
  has_many :reviews
  has_and_belongs_to_many :order_twos, join_table: "books_orders"

  scope :in_print, -> { where(out_of_print: false) }
  scope :out_of_print, -> { where(out_of_print: true) }
  scope :recent, -> { where(year_published: 50.years.ago.year..) }
  scope :old, -> { where(year_published: ...50.years.ago.year) }
  scope :out_of_print_and_expensive, -> { out_of_print.where("price > 500") }
  scope :costs_more_than, ->(amount) { where("price > ?", amount) }
  scope :out_of_print, -> { where(out_of_print: true) }
end
