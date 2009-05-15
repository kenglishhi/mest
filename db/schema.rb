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

ActiveRecord::Schema.define(:version => 20090515053712) do

  create_table "biodatabase_sequences", :force => true do |t|
    t.integer "biodatabase_id"
    t.integer "biosequence_id"
  end

  create_table "biodatabase_types", :force => true do |t|
    t.string   "name",       :limit => 128, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biodatabases", :force => true do |t|
    t.string   "name",          :limit => 128, :null => false
    t.string   "authority",     :limit => 128
    t.text     "description"
    t.integer  "fasta_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biosequences", :force => true do |t|
    t.string  "name",                              :null => false
    t.text    "description"
    t.integer "length"
    t.string  "alphabet",    :limit => 10
    t.text    "seq",         :limit => 2147483647
  end

  create_table "fasta_files", :force => true do |t|
    t.string  "label"
    t.string  "fasta_file_name"
    t.string  "fasta_content_type"
    t.integer "fasta_file_size"
    t.boolean "is_generated",       :default => false
    t.integer "blast_command_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
