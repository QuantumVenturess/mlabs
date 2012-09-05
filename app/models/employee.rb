class Employee < ActiveRecord::Base
	attr_accessible :name, :first_name, :last_name, :tier, :wet_worked, :entry_worked

	has_many :assignments, dependent: :destroy
	has_many :jobs, through: :assignments

	has_many :directions, dependent: :destroy
	has_many :locations, through: :directions

	validates :name, presence: true
	validates :name, uniqueness: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :tier, presence: true

	default_scope order: "employees.last_name ASC"

	def current_location
		if self.directions.first
			self.directions.first.location_id
		else
			nil
		end
	end

	def currently_wet?
		if self.assignments.first
			if self.assignments.first.job_id == 1 && self.assignments.first.created_at.strftime("%m %d %y") == Time.now.strftime("%m %d %y")
				true
			else
				false
			end
		else
			false
		end
	end

	def currently_entry?
		if self.assignments.first.nil?
			false
		else
			today = Time.now.strftime("%w").to_i
			if today == 0
				false
			elsif today == 1
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 1
					true
				else
					false
				end
			elsif today == 2
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 2
					true
				else
					false
				end
			elsif today == 3
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 3
					true
				else
					false
				end
			elsif today == 4
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 4
					true
				else
					false
				end
			elsif today == 5
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 5
					true
				else
					false
				end
			elsif today == 6
				if self.assignments.first.job_id == 2 && self.assignments.first.created_at > Time.now - 86400 * 6
					true
				else
					false
				end
			end
		end
	end
end
