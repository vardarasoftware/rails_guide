# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_06_090032) do
  create_table "authors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.date "date_of_birth"
    t.string "nationality"
    t.string "email"
    t.string "website"
    t.integer "total_books"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "category_id", null: false
  end

  create_table "distributors", force: :cascade do |t|
    t.string "zipcode"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_books", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "products", primary_key: ["customer_id", "product_sku"], force: :cascade do |t|
    t.string "name"
    t.integer "customer_id"
    t.string "product_sku"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "price"
    t.string "category"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "products_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
  end

  create_table "publications", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "publication_type_id"
    t.string "publisher_type"
    t.integer "publisher_id"
    t.boolean "single_issue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_type_id"], name: "index_publications_on_publication_type_id"
    t.index ["publisher_type", "publisher_id"], name: "index_publications_on_publisher"
  end

  create_table "users", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "address"
  end

  add_foreign_key "books", "authors"
  add_foreign_key "posts", "users"
  add_foreign_key "products", "users"
end
