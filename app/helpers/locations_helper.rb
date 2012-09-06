module LocationsHelper

	def set
		if Default.first
			lab_count = Default.first.lab_employees
		else
			lab_count = 23
		end
		all = Employee.all
		if all.size >= lab_count
			limit = ((all.map { |e| e.tier }.sum) * ((lab_count * 1.0)/all.size).round(2)).round
			lab_sum = 0
			while lab_sum < limit - (limit * 0.04).round || lab_sum > limit
				all = all.shuffle
				lab_employees = all[0..(lab_count - 1)]
				office_employees = all[(lab_count)..all.size]
				lab_sum = lab_employees.map { |e| e.tier }.sum
			end
			lab_employees.each do |e|
				e.directions.create(location_id: 1)
			end
			office_employees.each do |e|
				e.directions.create(location_id: 2)
			end
		end
	end

	def switch
		if Default.first
			lab_count = Default.first.lab_employees
			wet_needed = Default.first.work_days * Default.first.wet_employees
			entry_needed = Default.first.entry_employees
		else
			lab_count = 23
			wet_needed = 10
			entry_needed = 2
		end
		lab_employees = []
		office_employees =[]
		Employee.find_each do |e|
			if e.directions.first
				if e.directions.first.location_id == 1
					lab_employees.push(e)
				elsif e.directions.first.location_id == 2
					office_employees.push(e)
				end
			end
		end
		all = lab_employees + office_employees
		tier_sum = all.map{ |e| e.tier }.sum
		limit = (tier_sum * ((lab_employees.size * 1.0)/all.size).round(2)).round
		if all.size >= (lab_count * 2.4).round && all.size >= (wet_needed + entry_needed) * 2
			wet_worked = all.map { |e| e.wet_worked }.count(false)
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
			wet_count = 0
			entry_worked = all.map { |e| e.entry_worked }.count(false)
			if entry_worked >= entry_needed
				entry_limit = entry_needed
			elsif entry_worked == 1
				entry_limit = 1
			elsif entry_worked == 0
				Employee.find_each do |e|
					e.update_attribute(:entry_worked, false)
				end
				entry_limit = entry_needed
			end
			entry_count = 0
			while entry_count < entry_limit
				while wet_count < wet_limit
					office_sum = 0
					while office_sum < limit - (limit * 0.04).round || office_sum > limit
						office_employees = office_employees.shuffle
						new_office = office_employees.take(lab_employees.size)
						office_sum = new_office.map { |e| e.tier }.sum
					end
					wet_count = new_office.map { |e| e.wet_worked }.count(false)
				end
				wet_workers = []
				entry_workers = new_office.shuffle
				entry_workers.each do |e|
					if !e.wet_worked? && wet_workers.size < wet_limit
						wet_workers.push(e)
					end
				end
				entry_workers = entry_workers - wet_workers
				entry_count = entry_workers.map { |e| e.entry_worked }.count(false)
			end
			lab_employees.each do |e|
				e.directions.create(location_id: 2)
			end
			new_office.each do |e|
				e.directions.create(location_id: 1)
			end
		end
	end
end