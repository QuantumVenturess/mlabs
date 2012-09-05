module AssignmentsHelper

	def wet
		not_worked = Employee.where("wet_worked = ?", false)
		if not_worked.size == 0
			Employee.find_each do |e|
				e.update_attribute(:wet_worked, false)
			end
			not_worked = Employee.where("wet_worked = ?", false)
		end
		lab_employees = []
		not_worked.each do |e|
			if e.current_location == 1 && !e.currently_entry?
				lab_employees.push(e)
			end
		end
		if lab_employees.size >= 2
			wet_employees = lab_employees.shuffle.pop(2)
			wet_employees.each do |e|
				e.update_attribute(:wet_worked, true)
				e.assignments.create(job_id: 1)
			end
		elsif lab_employees.size == 1
			wet_employee = lab_employees.shuffle.pop
			wet_employee.update_attribute(:wet_worked, true)
			wet_employee.assignments.create(job_id: 1)
		end
	end

	def entry
		not_worked = Employee.where("entry_worked = ?", false)
		if not_worked.size == 0
			Employee.find_each do |e|
				e.update_attribute(:entry_worked, false)
			end
			not_worked = Employee.where("entry_worked = ?", false)
		end
		lab_employees = []
		not_worked.each do |e|
			if e.current_location == 1 && !e.currently_wet?
				lab_employees.push(e)
			end
		end
		if lab_employees.size != 0
			wet_worked = Employee.all.map { |e| e.wet_worked }.count(false)
			if wet_worked >= 10
				wet_limit = 10
			elsif wet_worked < 10 && wet_worked > 0
				wet_limit = wet_worked
			elsif wet_worked == 0
				Employee.find_each do |e|
					e.update_attribute(:wet_worked, false)
				end
				wet_limit = 10
			end
			if not_worked.size >= 2
				entry_limit = 2
			elsif not_worked.size == 1
				entry_limit = 1
			end
			entry_count = 0
			while entry_count < entry_limit
				wet_workers = []
				entry_workers = lab_employees.shuffle
				entry_workers.each do |e|
					if !e.wet_worked? && wet_workers.size < wet_limit
						wet_workers.push(e)
					end
				end
				entry_workers = entry_workers - wet_workers
				entry_count = entry_workers.map { |e| e.entry_worked }.count(false)
			end
			entry_workers.sort_by { |e| !e.entry_worked? }.shuffle.take(2).each do |e|
				e.update_attribute(:entry_worked, true)
				e.assignments.create(job_id: 2)
			end
		end
	end
end