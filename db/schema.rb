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

ActiveRecord::Schema[8.0].define(version: 2024_12_22_151624) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "deliveries", force: :cascade do |t|
    t.string "destination"
    t.decimal "cost"
    t.text "description"
    t.string "pickup_address", null: false
    t.string "delivery_address", null: false
    t.decimal "weight", null: false
    t.decimal "distance", null: false
    t.datetime "scheduled_time", null: false
    t.string "driver_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding", limit: 1536
    t.index ["driver_name"], name: "index_deliveries_on_driver_name"
    t.index ["embedding"], name: "deliveries_embedding_idx", opclass: :vector_l2_ops, using: :hnsw
    t.index ["pickup_address"], name: "index_deliveries_on_pickup_address"
  end
end
