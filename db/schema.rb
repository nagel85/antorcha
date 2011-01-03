# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101229095932) do

  create_table "cancellations", :force => true do |t|
    t.integer  "transaction_id",  :null => false
    t.integer  "organization_id", :null => false
    t.datetime "cancelled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "castables", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deliveries", :force => true do |t|
    t.integer  "message_id",         :null => false
    t.integer  "organization_id",    :null => false
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "confirmed_at"
    t.text     "certificate"
    t.string   "organization_title"
  end

  create_table "identities", :force => true do |t|
    t.string   "private_key"
    t.string   "passphrase"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "incoming",           :default => false
    t.integer  "step_id",                               :null => false
    t.datetime "sent_at"
    t.datetime "shown_at"
    t.integer  "transaction_id"
    t.integer  "request_id"
    t.integer  "organization_id"
    t.string   "organization_title"
    t.string   "username"
    t.integer  "user_id"
  end

  create_table "notifiers", :force => true do |t|
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receptions", :force => true do |t|
    t.text     "certificate",     :null => false
    t.text     "content",         :null => false
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delivery_id"
    t.integer  "organization_id"
    t.datetime "confirmed_at"
  end

  create_table "transactions", :force => true do |t|
    t.string   "title"
    t.integer  "definition_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "cancelled_at"
    t.string   "uri"
    t.datetime "stopped_at"
    t.datetime "initialized_at"
    t.datetime "expired_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "",           :null => false
    t.string   "encrypted_password", :limit => 128, :default => "",           :null => false
    t.string   "password_salt",                     :default => "",           :null => false
    t.string   "username",                                                    :null => false
    t.string   "user_type",                         :default => "registered", :null => false
    t.boolean  "activated",                         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
