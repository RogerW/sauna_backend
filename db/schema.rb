# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171222055601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "house"
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lon", precision: 9, scale: 6
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_area_id"
    t.index ["city_area_id"], name: "index_addresses_on_city_area_id"
  end

  create_table "billings", force: :cascade do |t|
    t.bigint "sauna_id"
    t.integer "day_type"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "cost_cents", default: 0, null: false
    t.string "cost_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sauna_id"], name: "index_billings_on_sauna_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "city_areas", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "city_id"
    t.index ["city_id"], name: "index_city_areas_on_city_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contactable_type"
    t.bigint "contactable_id"
    t.string "middle_name"
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "sauna_id"
    t.bigint "user_id", null: false
    t.integer "inv_type"
    t.integer "state"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.decimal "discount", precision: 4, scale: 2
    t.integer "result_cents", default: 0, null: false
    t.string "result_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sauna_id"], name: "index_invoices_on_sauna_id"
  end

  create_table "invoices_reservations", force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "reservation_id"
    t.index ["invoice_id"], name: "index_invoices_reservations_on_invoice_id"
    t.index ["reservation_id"], name: "index_invoices_reservations_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.tstzrange "reserv_range"
    t.integer "state"
    t.bigint "sauna_id"
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.integer "guests_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["contact_id"], name: "index_reservations_on_contact_id"
    t.index ["sauna_id"], name: "index_reservations_on_sauna_id"
  end

  create_table "sauna_descriptions", force: :cascade do |t|
    t.bigint "sauna_id"
    t.string "description"
    t.jsonb "services"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sauna_id"], name: "index_sauna_descriptions_on_sauna_id"
  end

  create_table "sauna_galleries", force: :cascade do |t|
    t.bigint "sauna_id"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sauna_id"], name: "index_sauna_galleries_on_sauna_id"
  end

  create_table "saunas", force: :cascade do |t|
    t.string "name"
    t.bigint "address_id"
    t.string "logo"
    t.decimal "rating", precision: 2, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logotype_file_name"
    t.string "logotype_content_type"
    t.integer "logotype_file_size"
    t.datetime "logotype_updated_at"
    t.index ["address_id"], name: "index_saunas_on_address_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_contacts", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_users_contacts_on_contact_id"
  end

  create_table "users_saunas", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sauna_id"
    t.index ["sauna_id"], name: "index_users_saunas_on_sauna_id"
  end

  create_table "users_tables", force: :cascade do |t|
  end

  add_foreign_key "billings", "saunas"
  add_foreign_key "cities", "countries"
  add_foreign_key "city_areas", "cities"
  add_foreign_key "invoices", "saunas"
  add_foreign_key "invoices_reservations", "invoices"
  add_foreign_key "invoices_reservations", "reservations"
  add_foreign_key "reservations", "contacts"
  add_foreign_key "reservations", "saunas"
  add_foreign_key "sauna_descriptions", "saunas"
  add_foreign_key "sauna_galleries", "saunas"
  add_foreign_key "saunas", "addresses"
  add_foreign_key "users_contacts", "contacts"
  add_foreign_key "users_saunas", "saunas"

  create_view "bookings",  sql_definition: <<-SQL
      SELECT reservations.id,
      lower(reservations.reserv_range) AS start_date_time,
      upper(reservations.reserv_range) AS end_date_time,
      reservations.guests_num,
      reservations.status,
      contacts.id AS contact_id,
      contacts.first_name,
      contacts.middle_name,
      contacts.last_name,
      contacts.phone,
      contacts.created_at,
      contacts.updated_at,
      users_saunas.user_id,
      saunas.id AS sauna_id
     FROM (((reservations
       LEFT JOIN saunas ON ((saunas.id = reservations.sauna_id)))
       LEFT JOIN users_saunas ON ((users_saunas.sauna_id = saunas.id)))
       LEFT JOIN contacts ON ((reservations.contact_id = contacts.id)));
  SQL

  create_view "sauna_lists",  sql_definition: <<-SQL
      SELECT saunas.id,
      max(billings.cost_cents) AS max_cost_cents,
      min(billings.cost_cents) AS min_cost_cents,
      saunas.name,
      saunas.logotype_file_name,
      saunas.logotype_content_type,
      saunas.logotype_file_size,
      saunas.logotype_updated_at,
      saunas.rating,
      cities.name AS city,
      countries.name AS country,
      city_areas.name AS city_area,
      addresses.street,
      addresses.house,
      addresses.lat,
      addresses.lon,
      addresses.notes
     FROM (((((billings
       JOIN saunas ON ((saunas.id = billings.sauna_id)))
       JOIN addresses ON ((addresses.id = saunas.address_id)))
       JOIN city_areas ON ((city_areas.id = addresses.city_area_id)))
       JOIN cities ON ((cities.id = city_areas.city_id)))
       JOIN countries ON ((countries.id = cities.country_id)))
    GROUP BY saunas.id, cities.name, city_areas.name, countries.name, addresses.street, addresses.house, addresses.lat, addresses.lon, addresses.notes
    ORDER BY saunas.name;
  SQL

end
