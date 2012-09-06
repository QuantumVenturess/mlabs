module AssignmentsHelper

	def wet
		if Default.first
			wet_daily = Default.first.wet_employees
		else
			wet_daily = 2
		end
		not_worked = Employee.where("wet_worked = ?", false)
		if not_worked.size == 0
			Employee.find_each do |e|
				e.update_attribute(:wet_worked, false)
			end
			not_worked = Employee.where("wet_worked = ?", false)
			lab_employees = []
			not_worked.each do |e|
				if e.current_location == 1 && !e.currently_entry?
					lab_employees.push(e)
				end
			end
			wet_employees = lab_employees.shuffle.pop(wet_daily)
			wet_employees.each do |e|
				e.update_attribute(:wet_worked, true)
				e.assignments.create(job_id: 1)
			end
		elsif not_worked.size >= wet_daily
			lab_employees = []
			not_worked.each do |e|
				if e.current_location == 1 && !e.currently_entry?
					lab_employees.push(e)
				end
			end
			wet_employees = lab_employees.shuffle.pop(wet_daily)
			wet_employees.each do |e|
				e.update_attribute(:wet_worked, true)
				e.assignments.create(job_id: 1)
			end
		elsif not_worked.size < wet_daily && not_worked.size > 0
			remaining = wet_daily - not_worked.size
			lab_employees = []
			not_worked.each do |e|
				if e.current_location == 1 && !e.currently_entry?
					lab_employees.push(e)
				end
			end
			wet_employees = lab_employees.shuffle.pop(not_worked.size)
			wet_employees.each do |e|
				e.update_attribute(:wet_worked, true)
				e.assignments.create(job_id: 1)
			end
			Employee.find_each do |e|
				e.update_attribute(:wet_worked, false)
			end
			not_worked = Employee.where("wet_worked = ?", false)
			lab_employees = []
			not_worked.each do |e|
				if e.current_location == 1 && !e.currently_entry?
					lab_employees.push(e)
				end
			end
			wet_employees = lab_employees.shuffle.pop(remaining)
			wet_employees.each do |e|
				e.update_attribute(:wet_worked, true)
				e.assignments.create(job_id: 1)
			end
		end
	end

	def entry
		if Default.first
			wet_needed = Default.first.work_days * Default.first.wet_employees
			entry_needed = Default.first.entry_employees
		else
			wet_needed = 10
			entry_needed = 2
		end
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
		if lab_employees.size != 0 && lab_employees.size >= wet_needed + entry_needed
			wet_worked = Employee.all.map { |e| e.wet_worked }.count(false)
			if wet_worked >= wet_needed
				wet_limit = wet_needed
			elsif wet_worked < wet_needed && wet_worked > 0
				wet_limit = wet_worked
			elsif wet_worked == 0
				Employee.find_each do |e|
					e.update_attribute(:wet_worked, false)
				end
				wet_limit = wet_needed
			end
			if not_worked.size >= entry_needed
				entry_limit = entry_needed
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
			entry_workers.sort_by { |e| !e.entry_worked? }.shuffle.take(entry_needed).each do |e|
				e.update_attribute(:entry_worked, true)
				e.assignments.create(job_id: 2)
			end
		end
	end
end