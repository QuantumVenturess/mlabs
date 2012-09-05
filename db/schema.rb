# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120905222402) do

  create_table "assignments", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["employee_id", "job_id"], :name => "index_assignments_on_employee_id_and_job_id"

  create_table "defaults", :force => true do |t|
    t.integer  "lab_employees"
    t.integer  "work_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "wet_employees"
    t.integer  "entry_employees"
  end

  add_index "defaults", ["entry_employees"], :name => "index_defaults_on_entry_employees"
  add_index "defaults", ["lab_employees"], :name => "index_defaults_on_lab_employees"
  add_index "defaults", ["wet_employees"], :name => "index_defaults_on_wet_employees"
  add_index "defaults", ["work_days"], :name => "index_defaults_on_work_days"

  create_table "directions", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "directions", ["employee_id", "location_id"], :name => "index_directions_on_employee_id_and_location_id"

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tier",         :default => 0
    t.boolean  "wet_worked",   :default => false
    t.boolean  "entry_worked", :default => false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "employees", ["entry_worked"], :name => "index_employees_on_entry_worked"
  add_index "employees", ["first_name", "last_name"], :name => "index_employees_on_first_name_and_last_name", :unique => true
  add_index "employees", ["name"], :name => "index_employees_on_name"
  add_index "employees", ["tier"], :name => "index_employees_on_tier"
  add_index "employees", ["wet_worked"], :name => "index_employees_on_wet_worked"

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["name"], :name => "index_jobs_on_name"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"

end
