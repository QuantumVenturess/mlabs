class Assignment < ActiveRecord::Base
	attr_accessible :employee_id, :job_id, :created_at

	belongs_to :employee
	belongs_to :job

	validates :employee_id, presence: true
	validates :job_id, presence: true

	default_scope order: "assignments.created_at DESC"

	def month_day
		self.created_at.strftime("%A, %b %d")
	end
end