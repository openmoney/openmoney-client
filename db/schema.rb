# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "allowances", :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
    t.integer "allowance",     :default => 1
  end

  add_index "allowances", ["role_id"], :name => "index_allowances_on_role_id"

  create_table "configurations", :force => true do |t|
    t.string   "name"
    t.string   "configuration_type"
    t.text     "value"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "name"
    t.text     "body"
    t.integer  "om_account_id"
    t.integer  "modifier_id"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "om_accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "omrl"
    t.text     "credentials",                      :null => false
    t.text     "currencies_cache"
    t.string   "default_currency", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "om_contexts", :force => true do |t|
    t.integer  "user_id"
    t.string   "omrl"
    t.text     "credentials"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "om_currencies", :force => true do |t|
    t.integer  "user_id"
    t.string   "omrl"
    t.text     "credentials"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "permissions", ["name"], :name => "index_permissions_on_name", :unique => true

  create_table "plays", :force => true do |t|
    t.text     "description"
    t.text     "notes"
    t.string   "account_omrl"
    t.string   "currency_omrl"
    t.integer  "player_id"
    t.integer  "creator_id"
    t.integer  "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rauth_native_accounts", :force => true do |t|
    t.string   "user_name"
    t.string   "openid_url"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "activation_code"
    t.string   "reset_code"
    t.datetime "created_at"
    t.boolean  "enabled",         :default => true
  end

  add_index "rauth_native_accounts", ["user_name"], :name => "index_rauth_native_accounts_on_user_name", :unique => true
  add_index "rauth_native_accounts", ["activation_code"], :name => "index_rauth_native_accounts_on_activation_code"
  add_index "rauth_native_accounts", ["reset_code"], :name => "index_rauth_native_accounts_on_reset_code"

  create_table "roles", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "users", :force => true do |t|
    t.integer  "account_id"
    t.integer  "role_id"
    t.string   "user_name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "last_login"
    t.string   "pref_language",        :default => "", :null => false
    t.integer  "pref_items_per_page",  :default => 20, :null => false
    t.string   "pref_default_account", :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pref_date_format",     :default => "", :null => false
  end

end
