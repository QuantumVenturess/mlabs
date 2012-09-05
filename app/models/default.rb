class Default < ActiveRecord::Base
	attr_accessible :lab_employees, :work_days, :wet_employees, :entry_employees

	validates :lab_employees, presence: true
	validates :work_days, presence: true
	validates :wet_employees, presence: true
	validates :entry_employees, presence: true
end