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

ActiveRecord::Schema[7.1].define(version: 2024_09_18_122750) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "halls", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "duration"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "genre"
    t.text "cast"
    t.string "director"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating", default: 0, null: false
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "movie_id", null: false
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "seats", force: :cascade do |t|
    t.string "seat_number"
    t.string "seat_type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hall_id"
    t.index ["hall_id"], name: "index_seats_on_hall_id"
  end

  create_table "seats_showtimes", id: false, force: :cascade do |t|
    t.bigint "seat_id", null: false
    t.bigint "showtime_id", null: false
  end

  create_table "showtimes", force: :cascade do |t|
    t.bigint "movie_id", null: false
    t.bigint "hall_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hall_id"], name: "index_showtimes_on_hall_id"
    t.index ["movie_id"], name: "index_showtimes_on_movie_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "showtime_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seat_id"
    t.integer "price"
    t.index ["seat_id"], name: "index_tickets_on_seat_id"
    t.index ["showtime_id"], name: "index_tickets_on_showtime_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "premium", default: false
  end

  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
  add_foreign_key "seats", "halls"
  add_foreign_key "showtimes", "halls"
  add_foreign_key "showtimes", "movies"
  add_foreign_key "tickets", "seats"
  add_foreign_key "tickets", "showtimes"
  add_foreign_key "tickets", "users"
end
