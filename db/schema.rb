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

ActiveRecord::Schema.define(:version => 20090903233447) do

  create_table "biodatabase_biosequences", :force => true do |t|
    t.integer "biodatabase_id"
    t.integer "biosequence_id"
  end

  create_table "biodatabase_groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biodatabase_types", :force => true do |t|
    t.string   "name",       :limit => 128, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biodatabases", :force => true do |t|
    t.string   "name",                 :limit => 128, :null => false
    t.string   "authority",            :limit => 128
    t.text     "description"
    t.integer  "biodatabase_type_id",                 :null => false
    t.integer  "biodatabase_group_id",                :null => false
    t.integer  "fasta_file_id"
    t.integer  "user_id"
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

  create_table "blast_commands", :force => true do |t|
    t.integer  "test_fasta_file_id"
    t.integer  "target_fasta_file_id"
    t.float    "evalue"
    t.integer  "identity"
    t.integer  "score"
    t.string   "biodatabase_name"
    t.integer  "biodatabase_type_id"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.integer  "biodatabase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blast_results", :force => true do |t|
    t.string   "name"
    t.string   "output_file_name"
    t.string   "output_content_type"
    t.integer  "output_file_size"
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.decimal  "duration_in_seconds", :precision => 10, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.string   "job_name"
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.boolean  "run_once"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "fasta_files", :force => true do |t|
    t.string   "label"
    t.string   "fasta_file_name"
    t.string   "fasta_content_type"
    t.integer  "fasta_file_size"
    t.boolean  "is_generated",       :default => false
    t.integer  "biodatabase_id"
    t.integer  "project_id",                            :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_logs", :force => true do |t|
    t.string   "job_name"
    t.string   "job_class_name"
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.decimal  "duration_in_seconds", :precision => 10, :scale => 4
    t.boolean  "success"
    t.text     "message"
    t.integer  "user_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mi"
    t.string   "title"
    t.string   "organization"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
