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

	def self.search(search)
		if search
			if Rails.env.production?
				employee_ids = Employee.where("name ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ? OR tier ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").map(&:id).join(", ")
			else
				employee_ids = Employee.where("name LIKE ? OR first_name LIKE ? OR last_name LIKE ? OR tier LIKE ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").map(&:id).join(", ")
			end
			where("employee_id IN (#{employee_ids})")
		else
			scoped
		end
	end
end