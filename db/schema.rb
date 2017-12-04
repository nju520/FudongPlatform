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

ActiveRecord::Schema.define(version: 20171126080508) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "address_type"
    t.string "contact_name"
    t.string "cellphone"
    t.string "address"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "address_type"], name: "index_addresses_on_user_id_and_address_type"
  end

  create_table "admin_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "account_no"
    t.decimal "balance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no"], name: "index_admin_accounts_on_account_no", unique: true
  end

  create_table "admin_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "admin_account_id"
    t.integer "order_id"
    t.string "transction_no"
    t.string "transction_type"
    t.decimal "trade_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_account_id"], name: "index_admin_transactions_on_admin_account_id"
    t.index ["order_id"], name: "index_admin_transactions_on_order_id"
    t.index ["transction_no"], name: "index_admin_transactions_on_transction_no", unique: true
  end

  create_table "buyer_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "name"
    t.string "account_no"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no"], name: "index_buyer_accounts_on_account_no", unique: true
    t.index ["user_id"], name: "index_buyer_accounts_on_user_id"
  end

  create_table "buyer_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "buyer_account_id"
    t.integer "order_id"
    t.string "buyer_name"
    t.string "transction_no"
    t.string "transction_type"
    t.decimal "trade_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_account_id"], name: "index_buyer_transactions_on_buyer_account_id"
    t.index ["order_id"], name: "index_buyer_transactions_on_order_id"
    t.index ["transction_no"], name: "index_buyer_transactions_on_transction_no", unique: true
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.integer "weight", default: 0
    t.integer "products_counter", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["title"], name: "index_categories_on_title"
  end

  create_table "main_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "main_order_no"
    t.decimal "main_total_money", precision: 10, scale: 2
    t.datetime "payment_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["main_order_no"], name: "index_main_orders_on_main_order_no", unique: true
    t.index ["user_id"], name: "index_main_orders_on_user_id"
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.integer "address_id"
    t.string "order_no"
    t.integer "amount"
    t.decimal "total_money", precision: 10, scale: 2
    t.datetime "payment_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_id"
    t.string "status", default: "initial"
    t.integer "main_order_id"
    t.integer "pack_order_id"
    t.index ["main_order_id"], name: "index_orders_on_main_order_id"
    t.index ["order_no"], name: "index_orders_on_order_no", unique: true
    t.index ["pack_order_id"], name: "index_orders_on_pack_order_id"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pack_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "seller_id"
    t.integer "main_order_id"
    t.string "pack_order_no"
    t.decimal "pack_total_money", precision: 10, scale: 2, default: "0.0"
    t.datetime "payment_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["main_order_id"], name: "index_pack_orders_on_main_order_id"
    t.index ["pack_order_no"], name: "index_pack_orders_on_pack_order_no", unique: true
    t.index ["seller_id"], name: "index_pack_orders_on_seller_id"
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "payment_no"
    t.string "transaction_no"
    t.string "status", default: "initial"
    t.decimal "total_money", precision: 10, scale: 2
    t.datetime "payment_at"
    t.text "raw_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "main_order_id"
    t.index ["main_order_id"], name: "index_payments_on_main_order_id"
    t.index ["payment_no"], name: "index_payments_on_payment_no", unique: true
    t.index ["transaction_no"], name: "index_payments_on_transaction_no"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "product_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "product_id"
    t.integer "weight", default: 0
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "weight"], name: "index_product_images_on_product_id_and_weight"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.integer "seller_id"
    t.string "title"
    t.string "status", default: "off"
    t.integer "amount", default: 0
    t.string "uuid"
    t.decimal "msrp", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["seller_id"], name: "index_products_on_seller_id"
    t.index ["status", "category_id"], name: "index_products_on_status_and_category_id"
    t.index ["title"], name: "index_products_on_title"
    t.index ["uuid"], name: "index_products_on_uuid", unique: true
  end

  create_table "seller_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "name"
    t.string "account_no"
    t.decimal "balance", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no"], name: "index_seller_accounts_on_account_no", unique: true
    t.index ["user_id"], name: "index_seller_accounts_on_user_id"
  end

  create_table "seller_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "seller_account_id"
    t.integer "order_id"
    t.string "seller_name"
    t.string "transction_no"
    t.string "transction_type"
    t.decimal "trade_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_seller_transactions_on_order_id"
    t.index ["seller_account_id"], name: "index_seller_transactions_on_seller_account_id"
    t.index ["transction_no"], name: "index_seller_transactions_on_transction_no", unique: true
  end

  create_table "shopping_carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.string "user_uuid"
    t.integer "product_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_shopping_carts_on_user_id"
    t.index ["user_uuid"], name: "index_shopping_carts_on_user_uuid"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_state"
    t.string "activation_token"
    t.datetime "activation_token_expires_at"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string "uuid"
    t.integer "default_address_id"
    t.boolean "is_admin", default: false
    t.boolean "is_seller", default: false
    t.index ["activation_token"], name: "index_users_on_activation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
