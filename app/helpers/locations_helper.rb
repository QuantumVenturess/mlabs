module LocationsHelper

	def set
		if Default.first
			lab_count = Default.first.lab_employees
		else
			lab_count = 23
		end
		all = Employee.all
		limit = ((all.map { |e| e.tier }.sum) * ((lab_count * 1.0)/all.size).round(2)).round
		lab_sum = 0
		while lab_sum <= limit - 5 || lab_sum > limit
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

	def switch
		if Default.first
			work_days = Default.first.work_days
		else

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
		employees_size = all.size
		limit = (tier_sum * ((lab_employees.size * 1.0)/employees_size).round(2)).round
		wet_worked = all.map { |e| e.wet_worked }.count(false)
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
		wet_count = 0
		entry_worked = all.map { |e| e.entry_worked }.count(false)
		if entry_worked >= 2
			entry_limit = 2
		elsif entry_worked == 1
			entry_limit = 1
		elsif entry_worked == 0
			Employee.find_each do |e|
				e.update_attribute(:entry_worked, false)
			end
			entry_limit = 2
		end
		entry_count = 0
		while entry_count < entry_limit
			while wet_count < wet_limit
				office_sum = 0
				while office_sum <= limit - 5 || office_sum > limit
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