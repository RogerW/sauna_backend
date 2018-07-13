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

ActiveRecord::Schema.define(version: 20180712123431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "addrobj", primary_key: "aoguid", id: :uuid, default: nil, force: :cascade do |t|
    t.string "areacode", limit: 3
    t.string "autocode", limit: 1
    t.string "citycode", limit: 3
    t.string "code", limit: 17
    t.date "enddate"
    t.string "formalname", limit: 120
    t.string "ifnsfl", limit: 4
    t.string "ifnsul", limit: 4
    t.string "offname", limit: 120
    t.string "okato", limit: 11
    t.string "oktmo", limit: 11
    t.string "placecode", limit: 3
    t.string "plaincode", limit: 15
    t.string "postalcode", limit: 6
    t.string "regioncode", limit: 2
    t.string "shortname", limit: 10
    t.date "startdate"
    t.string "streetcode", limit: 4
    t.string "terrifnsfl", limit: 4
    t.string "terrifnsul", limit: 4
    t.date "updatedate"
    t.string "ctarcode", limit: 3
    t.string "extrcode", limit: 4
    t.string "sextcode", limit: 3
    t.string "plancode", limit: 4
    t.string "cadnum", limit: 100
    t.decimal "divtype", precision: 1
    t.integer "actstatus"
    t.uuid "aoid"
    t.integer "aolevel"
    t.integer "centstatus"
    t.integer "currstatus"
    t.integer "livestatus"
    t.uuid "nextid"
    t.uuid "normdoc"
    t.integer "operstatus"
    t.uuid "parentguid"
    t.uuid "previd"
    t.index "formalname gin_trgm_ops", name: "formalname_trgm_idx", using: :gin
    t.index "offname gin_trgm_ops", name: "offname_trgm_idx", using: :gin
    t.index ["aoguid"], name: "aoguid_pk_idx", unique: true
    t.index ["aoid"], name: "aoid_idx", unique: true
    t.index ["aolevel"], name: "aolevel_idx"
    t.index ["currstatus"], name: "currstatus_idx"
    t.index ["formalname"], name: "formalname_idx"
    t.index ["offname"], name: "offname_idx"
    t.index ["parentguid"], name: "parentguid_idx"
    t.index ["shortname", "aolevel"], name: "shortname_aolevel_idx"
    t.index ["shortname"], name: "shortname_idx"
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
    t.string "aasm_state"
    t.index ["sauna_id"], name: "index_invoices_on_sauna_id"
  end

  create_table "invoices_reservations", force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "reservation_id"
    t.index ["invoice_id"], name: "index_invoices_reservations_on_invoice_id"
    t.index ["reservation_id"], name: "index_invoices_reservations_on_reservation_id"
  end

  create_table "promos", force: :cascade do |t|
    t.string "title"
    t.tsrange "active_range"
    t.bigint "sauna_id"
    t.bigint "user_id"
    t.integer "status"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["sauna_id"], name: "index_promos_on_sauna_id"
    t.index ["user_id"], name: "index_promos_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "state"
    t.bigint "sauna_id"
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.integer "guests_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.tsrange "reserv_range"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.index ["sauna_id"], name: "index_sauna_galleries_on_sauna_id"
  end

  create_table "saunas", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.decimal "rating", precision: 2, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logotype_file_name"
    t.string "logotype_content_type"
    t.integer "logotype_file_size"
    t.datetime "logotype_updated_at"
    t.uuid "city_uuid"
    t.uuid "street_uuid"
    t.string "full_address"
    t.string "house"
    t.decimal "lat", precision: 9, scale: 6
    t.decimal "lon", precision: 9, scale: 6
    t.string "note"
  end

  create_table "socrbase", primary_key: "kod_t_st", id: :string, limit: 4, force: :cascade do |t|
    t.string "socrname", limit: 50
    t.string "scname", limit: 10
    t.integer "level"
    t.index ["kod_t_st"], name: "kod_t_st_idx", unique: true
    t.index ["scname", "level"], name: "scname_level_idx"
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
    t.string "provider"
    t.string "uid"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_contacts", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_users_contacts_on_contact_id"
  end

  create_table "users_saunas", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sauna_id"
    t.index ["sauna_id"], name: "index_users_saunas_on_sauna_id"
  end

  add_foreign_key "addrobj", "addrobj", column: "parentguid", primary_key: "aoguid", name: "addrobj_parentguid_fkey", on_update: :cascade
  add_foreign_key "billings", "saunas"
  add_foreign_key "invoices", "saunas"
  add_foreign_key "invoices_reservations", "invoices"
  add_foreign_key "invoices_reservations", "reservations"
  add_foreign_key "promos", "saunas"
  add_foreign_key "promos", "users"
  add_foreign_key "reservations", "contacts"
  add_foreign_key "reservations", "saunas"
  add_foreign_key "sauna_descriptions", "saunas"
  add_foreign_key "sauna_galleries", "saunas"
  add_foreign_key "users_contacts", "contacts"
  add_foreign_key "users_saunas", "saunas"

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
      saunas.full_address,
      saunas.city_uuid,
      saunas.street_uuid,
      saunas.note,
      saunas.lon,
      saunas.lat
     FROM (billings
       JOIN saunas ON ((saunas.id = billings.sauna_id)))
    GROUP BY saunas.id
    ORDER BY saunas.name;
  SQL

  create_view "user_orders",  sql_definition: <<-SQL
      SELECT reservations.id,
      reservations.id AS reservation_id,
      reservations.user_id,
      reservations.aasm_state AS state,
      to_char(lower(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS start_date_time,
      to_char(upper(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS end_date_time,
      reservations.guests_num,
      saunas.id AS sauna_id,
      saunas.name,
      saunas.full_address,
      saunas.lat,
      saunas.lon
     FROM ((reservations
       LEFT JOIN saunas ON ((saunas.id = reservations.sauna_id)))
       LEFT JOIN users_saunas ON ((users_saunas.sauna_id = saunas.id)));
  SQL

  create_view "bookings",  sql_definition: <<-SQL
      SELECT reservations.id,
      to_char(lower(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS start_date_time,
      to_char(upper(reservations.reserv_range), 'YYYY-MM-DD HH24:MI:ss'::text) AS end_date_time,
      reservations.guests_num,
      reservations.aasm_state AS status,
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

end
