class Direction < ActiveRecord::Base
	attr_accessible :employee_id, :location_id, :created_at

	belongs_to :employee
	belongs_to :location

	validates :employee_id, presence: true
	validates :location_id, presence: true

	default_scope order: 'directions.created_at DESC'
end
