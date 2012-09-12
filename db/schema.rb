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

ActiveRecord::Schema.define(:version => 20120911213217) do

  create_table "assignments", :force => true do |t|
    t.integer   "employee_id"
    t.integer   "job_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "assignments", ["employee_id", "job_id"], :name => "index_assignments_on_employee_id_and_job_id"

  create_table "defaults", :force => true do |t|
    t.integer   "lab_employees"
    t.integer   "work_days"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "wet_employees"
    t.integer   "entry_employees"
    t.integer   "wones_employees"
    t.integer   "qns_employees"
    t.integer   "sarah_employees"
  end

  add_index "defaults", ["entry_employees"], :name => "index_defaults_on_entry_employees"
  add_index "defaults", ["lab_employees"], :name => "index_defaults_on_lab_employees"
  add_index "defaults", ["qns_employees"], :name => "index_defaults_on_qns_employees"
  add_index "defaults", ["sarah_employees"], :name => "index_defaults_on_sarah_employees"
  add_index "defaults", ["wet_employees"], :name => "index_defaults_on_wet_employees"
  add_index "defaults", ["wones_employees"], :name => "index_defaults_on_wones_employees"
  add_index "defaults", ["work_days"], :name => "index_defaults_on_work_days"

  create_table "directions", :force => true do |t|
    t.integer   "employee_id"
    t.integer   "location_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "directions", ["employee_id", "location_id"], :name => "index_directions_on_employee_id_and_location_id"

  create_table "employees", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "tier",         :default => 0
    t.boolean   "wet_worked",   :default => false
    t.boolean   "entry_worked", :default => false
    t.string    "first_name"
    t.string    "last_name"
    t.boolean   "vacation",     :default => false
    t.boolean   "floater",      :default => false
    t.boolean   "wones_team",   :default => false
    t.boolean   "wones_worked", :default => false
    t.boolean   "qns_team",     :default => false
    t.boolean   "qns_worked",   :default => false
    t.boolean   "sarah_team",   :default => false
    t.boolean   "sarah_worked", :default => false
    t.integer   "must_assign",  :default => 0
    t.integer   "station",      :default => 0
    t.integer   "seat",         :default => 0
  end

  add_index "employees", ["entry_worked"], :name => "index_employees_on_entry_worked"
  add_index "employees", ["first_name", "last_name"], :name => "index_employees_on_first_name_and_last_name", :unique => true
  add_index "employees", ["floater"], :name => "index_employees_on_floater"
  add_index "employees", ["must_assign"], :name => "index_employees_on_must_assign"
  add_index "employees", ["name"], :name => "index_employees_on_name"
  add_index "employees", ["qns_team"], :name => "index_employees_on_qns_team"
  add_index "employees", ["qns_worked"], :name => "index_employees_on_qns_worked"
  add_index "employees", ["sarah_team"], :name => "index_employees_on_sarah_team"
  add_index "employees", ["sarah_worked"], :name => "index_employees_on_sarah_worked"
  add_index "employees", ["seat"], :name => "index_employees_on_seat"
  add_index "employees", ["station"], :name => "index_employees_on_station"
  add_index "employees", ["tier"], :name => "index_employees_on_tier"
  add_index "employees", ["vacation"], :name => "index_employees_on_vacation"
  add_index "employees", ["wet_worked"], :name => "index_employees_on_wet_worked"
  add_index "employees", ["wones_team"], :name => "index_employees_on_wones_team"
  add_index "employees", ["wones_worked"], :name => "index_employees_on_wones_worked"

  create_table "jobs", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "jobs", ["name"], :name => "index_jobs_on_name"

  create_table "locations", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"

  create_table "undos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "sarah",      :limit => 255
    t.text     "qns",        :limit => 255
    t.text     "wones",      :limit => 255
    t.text     "entry",      :limit => 255
    t.text     "wet",        :limit => 255
  end

  add_index "undos", ["entry"], :name => "index_undos_on_entry"
  add_index "undos", ["name"], :name => "index_undos_on_name"
  add_index "undos", ["qns"], :name => "index_undos_on_qns"
  add_index "undos", ["sarah"], :name => "index_undos_on_sarah"
  add_index "undos", ["wet"], :name => "index_undos_on_wet"
  add_index "undos", ["wones"], :name => "index_undos_on_wones"

end
