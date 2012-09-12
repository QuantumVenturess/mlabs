module AssignmentsHelper

	def undo_assignments(undo)
		max_time = undo.created_at + 10
		min_time = undo.created_at - 10
		if undo.name == "Wet Station"
			assignments = Assignment.where("job_id = ? AND created_at > ? AND created_at < ?", 1, min_time, max_time)
			if !undo.wet.nil? && undo.wet != ""
				Employee.where("sarah_team = ? AND id NOT IN (#{undo.wet})", false).each do |e|
					e.update_attribute(:wet_worked, false)
				end
				Employee.where("sarah_team = ? AND id IN (#{undo.wet})", false).each do |e| # all employees who had their wet_worked changed to false from true
					e.update_attribute(:wet_worked, true)
				end
			else
				assignments.each do |a|
					Employee.find(a.employee_id).update_attribute(:wet_worked, false)
				end
			end
			assignments.destroy_all
		end
		if undo.name == "Entry Station"
			assignments = Assignment.where("job_id = ? AND created_at > ? AND created_at < ?", 2, min_time, max_time)
			if !undo.entry.nil? && undo.entry != ""
				Employee.where("wones_team = ? AND qns_team = ? AND sarah_team = ? AND id NOT IN (#{undo.entry})", false, false, false).each do |e|
					e.update_attribute(:entry_worked, false)
				end
				Employee.where("wones_team = ? AND qns_team = ? AND sarah_team = ? AND id IN (#{undo.entry})", false, false, false).each do |e| # all employees who had their entry_worked changed to false from true
					e.update_attribute(:entry_worked, true)
				end
			else
				assignments.each do |a|
					Employee.find(a.employee_id).update_attribute(:entry_worked, false)
				end
			end
			assignments.destroy_all
		end
		if undo.name == "Wet Ones"
			assignments = Assignment.where("job_id = ? AND created_at > ? AND created_at < ?", 3, min_time, max_time)
			if !undo.wones.nil? && undo.wones != ""
				Employee.where("wones_team = ? AND id NOT IN (#{undo.wones})", true).each do |e|
					e.update_attribute(:wones_worked, false)
				end
				Employee.where("wones_team = ? AND id IN (#{undo.wones})", true).each do |e| # all employees who had their wones_worked changed to false from true
					e.update_attribute(:wones_worked, true)
				end
			else
				assignments.each do |a|
					Employee.find(a.employee_id).update_attribute(:wones_worked, false)
				end
			end
			assignments.destroy_all
		end
		if undo.name == "Rejects Station"
			assignments = Assignment.where("job_id = ? AND created_at > ? AND created_at < ?", 4, min_time, max_time)
			if !undo.qns.nil? && undo.qns != ""
				Employee.where("qns_team = ? AND id NOT IN (#{undo.qns})", true).each do |e|
					e.update_attribute(:qns_worked, false)
				end
				Employee.where("qns_team = ? AND id IN (#{undo.qns})", true).each do |e| # all employees who had their qns_worked changed to false from true
					e.update_attribute(:qns_worked, true)
				end
			else
				assignments.each do |a|
					Employee.find(a.employee_id).update_attribute(:qns_worked, false)
				end
			end
			assignments.destroy_all
		end
		if undo.name == "Sarah's Station"
			assignments = Assignment.where("job_id = ? AND created_at > ? AND created_at < ?", 5, min_time, max_time)
			if !undo.sarah.nil? && undo.sarah != ""
				Employee.where("sarah_team = ? AND id NOT IN (#{undo.sarah})", true).each do |e|
					e.update_attribute(:sarah_worked, false)
				end
				Employee.where("sarah_team = ? AND id IN (#{undo.sarah})", true).each do |e| # all employees who had their sarah_worked changed to false from true
					e.update_attribute(:sarah_worked, true)
				end
			else
				assignments.each do |a|
					Employee.find(a.employee_id).update_attribute(:sarah_worked, false)
				end
			end
			assignments.destroy_all
		end
		undo.destroy
	end

	def wet
		if Default.first
			wet_daily = Default.first.wet_employees
		else
			wet_daily = 2
		end
		undo_holder = []
		not_worked = Employee.where("vacation = ? AND wet_worked = ? AND sarah_team = ?", false, false, false)
		if not_worked.size >= wet_daily
			office = []
			not_worked.each do |e|
				office.push(e) if e.current_location == 2
			end
			must_assign = office.select { |e| e.must_assign == 1 }
			if !must_assign.empty?
				must_assign.each do |e|
					e.assignments.create(job_id: 1)
					e.update_attributes(wet_worked: true, must_assign: 0)
				end
			end
			office.reject { |e| must_assign.include?(e) }.shuffle.take(wet_daily - must_assign.size).each do |e|
				e.assignments.create(job_id: 1)
				e.update_attribute(:wet_worked, true)
			end
		elsif not_worked.size < wet_daily && not_worked.size > 0
			must_assign = not_worked.select { |e| e.current_location == 2 }
			office = []
			Employee.where("vacation = ? AND sarah_team = ?", false, false).each do |e|
				e.update_attribute(:wet_worked, false)
				undo_holder.push(e) if !must_assign.include?(e) # all employees that has their wet_worked being changed to false
				office.push(e) if e.current_location == 2
			end
			must_assign.each do |e|
				e.assignments.create(job_id: 1)
				e.update_attribute(:wet_worked, true)
			end
			office = office - must_assign
			office.shuffle.take(wet_daily - must_assign.size).each do |e|
				e.assignments.create(job_id: 1)
				e.update_attribute(:wet_worked, true)
			end
		elsif not_worked.size == 0
			office = []
			Employee.where("vacation = ? AND sarah_team = ?", false, false).each do |e|
				e.update_attribute(:wet_worked, false)
				undo_holder.push(e) # all employees that has their wet_worked being changed to false
				office.push(e) if e.current_location == 2
			end
			office.shuffle.take(wet_daily).each do |e|
				e.assignments.create(job_id: 1)
				e.update_attribute(:wet_worked, true)
			end
		end
		if undo_holder.empty?
			Undo.create(name: "Wet Station")
		else
			Undo.create(name: "Wet Station", wet: undo_holder.map(&:id).join(", "))
		end
	end

	def entry
		if Default.first
			entry_needed = Default.first.entry_employees
		else
			entry_needed = 2
		end
		undo_holder = []
		not_worked = Employee.where("vacation = ? AND entry_worked = ? AND wones_team = ? AND qns_team = ? AND sarah_team = ?", false, false, false, false, false)
		if not_worked.size >= entry_needed
			lab = []
			not_worked.each do |e|
				lab.push(e) if e.current_location == 1 && !e.currently_working? && !e.on_team?
			end
			must_assign = lab.select { |e| e.must_assign == 2 }
			if !must_assign.empty?
				must_assign.each do |e|
					e.assignments.create(job_id: 2)
					e.update_attributes(entry_worked: true, must_assign: 0)
				end
			end
			lab.reject { |e| must_assign.include?(e) }.shuffle.take(entry_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 2)
				e.update_attribute(:entry_worked, true)
			end
		elsif not_worked.size < entry_needed && not_worked.size > 0
			must_assign = not_worked.select { |e| e.current_location == 1 }
			lab = []
			Employee.where("vacation = ? AND sarah_team = ?", false, false).each do |e|
				e.update_attribute(:entry_worked, false)
				undo_holder.push(e) if !must_assign.include?(e) # all employees that has their entry_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working? && !e.on_team?
			end
			must_assign.each do |e|
				e.assignments.create(job_id: 2)
				e.update_attribute(:entry_worked, true)
			end
			lab = lab - must_assign
			lab.shuffle.take(entry_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 2)
				e.update_attribute(:entry_worked, true)
			end
		elsif not_worked.size == 0
			lab = []
			Employee.where("vacation = ? AND sarah_team = ?", false, false).each do |e|
				e.update_attribute(:entry_worked, false)
				undo_holder.push(e) # all employees that has their entry_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working? && !e.on_team?
			end
			lab.shuffle.take(entry_needed).each do |e|
				e.assignments.create(job_id: 2)
				e.update_attribute(:entry_worked, true)
			end
		end
		if undo_holder.empty?
			Undo.create(name: "Entry Station")
		else
			Undo.create(name: "Entry Station", entry: undo_holder.map(&:id).join(", "))
		end
	end

	def wet_ones
		if Default.first
			wones_needed = Default.first.wones_employees
		else
			wones_needed = 3
		end
		undo_holder = []
		not_worked = Employee.where("vacation = ? AND wones_worked = ? AND wones_team = ? AND sarah_team = ?", false, false, true, false)
		if not_worked.size >= wones_needed
			lab = []
			not_worked.each do |e|
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign = lab.select { |e| e.must_assign == 3 }
			if !must_assign.empty?
				must_assign.each do |e|
					e.assignments.create(job_id: 3)
					e.update_attributes(wones_worked: true, must_assign: 0)
				end
			end
			lab.reject { |e| must_assign.include?(e) }.shuffle.take(wones_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 3)
				e.update_attribute(:wones_worked, true)
			end
		elsif not_worked.size < wones_needed && not_worked.size > 0
			must_assign = not_worked.select { |e| e.current_location == 1 }
			lab = []
			Employee.where("vacation = ? AND wones_team = ? AND sarah_team = ?", false, true, false).each do |e|
				e.update_attribute(:wones_worked, false)
				undo_holder.push(e) if !must_assign.include?(e) # all employees that has their wones_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign.each do |e|
				e.assignments.create(job_id: 3)
				e.update_attribute(:wones_worked, true)
			end
			lab = lab - must_assign
			lab.shuffle.take(wones_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 3)
				e.update_attribute(:wones_worked, true)
			end
		elsif not_worked.size == 0
			lab = []
			Employee.where("vacation = ? AND wones_team = ? AND sarah_team = ?", false, true, false).each do |e|
				e.update_attribute(:wones_worked, false)
				undo_holder.push(e) # all employees that has their wones_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			lab.shuffle.take(wones_needed).each do |e|
				e.assignments.create(job_id: 3)
				e.update_attribute(:wones_worked, true)
			end
		end
		if undo_holder.empty?
			Undo.create(name: "Wet Ones")
		else
			Undo.create(name: "Wet Ones", wones: undo_holder.map(&:id).join(", "))
		end
	end

	def rejects
		if Default.first
			qns_needed = Default.first.qns_employees
		else
			qns_needed = 1
		end
		undo_holder = []
		not_worked = Employee.where("vacation = ? AND qns_worked = ? AND qns_team = ? AND sarah_team = ?", false, false, true, false)
		if not_worked.size >= qns_needed
			lab = []
			not_worked.each do |e|
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign = lab.select { |e| e.must_assign == 4 }
			if !must_assign.empty?
				must_assign.each do |e|
					e.assignments.create(job_id: 4)
					e.update_attributes(qns_worked: true, must_assign: 0)
				end
			end
			lab.reject { |e| must_assign.include?(e) }.shuffle.take(qns_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 4)
				e.update_attribute(:qns_worked, true)
			end
		elsif not_worked.size < qns_needed && not_worked.size > 0
			must_assign = not_worked.select { |e| e.current_location == 1 }
			lab = []
			Employee.where("vacation = ? AND qns_team = ? AND sarah_team = ?", false, true, false).each do |e|
				e.update_attribute(:qns_worked, false)
				undo_holder.push(e) if !must_assign.include?(e) # all employees that has their qns_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign.each do |e|
				e.assignments.create(job_id: 4)
				e.update_attribute(:qns_worked, true)
			end
			lab = lab - must_assign
			lab.shuffle.take(qns_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 4)
				e.update_attribute(:qns_worked, true)
			end
		elsif not_worked.size == 0
			lab = []
			Employee.where("vacation = ? AND qns_team = ? AND sarah_team = ?", false, true, false).each do |e|
				e.update_attribute(:qns_worked, false)
				undo_holder.push(e) # all employees that has their qns_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			lab.shuffle.take(qns_needed).each do |e|
				e.assignments.create(job_id: 4)
				e.update_attribute(:qns_worked, true)
			end
		end
		if undo_holder.empty?
			Undo.create(name: "Rejects Station")
		else
			Undo.create(name: "Rejects Station", qns: undo_holder.map(&:id).join(", "))
		end
	end

	def sarah
		if Default.first
			sarah_needed = Default.first.sarah_employees
		else
			sarah_needed = 2
		end
		undo_holder = []
		not_worked = Employee.where("vacation = ? AND sarah_worked = ? AND sarah_team = ?", false, false, true)
		if not_worked.size >= sarah_needed
			lab = []
			not_worked.each do |e|
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign = lab.select { |e| e.must_assign == 5 }
			if !must_assign.empty?
				must_assign.each do |e|
					e.assignments.create(job_id: 5)
					e.update_attributes(sarah_worked: true, must_assign: 0)
				end
			end
			lab.reject { |e| must_assign.include?(e) }.shuffle.take(sarah_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 5)
				e.update_attribute(:sarah_worked, true)
			end
		elsif not_worked.size < sarah_needed && not_worked.size > 0
			must_assign = not_worked.select { |e| e.current_location == 1 }
			lab = []
			Employee.where("vacation = ? AND sarah_team = ?", false, true).each do |e|
				e.update_attribute(:sarah_worked, false)
				undo_holder.push(e) if !must_assign.include?(e) # all employees that has their qns_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			must_assign.each do |e|
				e.assignments.create(job_id: 5)
				e.update_attribute(:sarah_worked, true)
			end
			lab = lab - must_assign
			lab.shuffle.take(sarah_needed - must_assign.size).each do |e|
				e.assignments.create(job_id: 5)
				e.update_attribute(:sarah_worked, true)
			end
		elsif not_worked.size == 0
			lab = []
			Employee.where("vacation = ? AND sarah_team = ?", false, true).each do |e|
				e.update_attribute(:sarah_worked, false)
				undo_holder.push(e) # all employees that has their qns_worked changed to false
				lab.push(e) if e.current_location == 1 && !e.currently_working?
			end
			lab.shuffle.take(sarah_needed).each do |e|
				e.assignments.create(job_id: 5)
				e.update_attribute(:sarah_worked, true)
			end
		end
		if undo_holder.empty?
			Undo.create(name: "Sarah's Station")
		else
			Undo.create(name: "Sarah's Station", sarah: undo_holder.map(&:id).join(", "))
		end
	end

	def assign_seats
		if Default.first
			lab_count = Default.first.lab_employees
			entry_needed = Default.first.entry_employees
			wones_needed = Default.first.wones_employees
			qns_needed = Default.first.qns_employees
			sarah_needed = Default.first.sarah_employees
			wet_needed = Default.first.wet_employees
		else
			lab_count = 24
			entry_needed = 2
			wones_needed = 3
			qns_needed = 1
			sarah_needed = 2
			wet_needed = 2
		end
		sarah = [] # Sarah's Station
		Assignment.where("job_id = ?", 5).take(sarah_needed).each do |a|
			employee = Employee.find(a.employee_id)
			sarah.push(employee) if employee.current_location == 1
		end
		sarah = sarah.sort_by { |e| e.last_name }
		sarah.each do |e|
			e.update_attributes(station: 4, seat: ((sarah.index(e) + 1) * 2))
		end
		rejects = [] # Rejects Station
		Assignment.where("job_id = ?", 4).take(qns_needed).each do |a|
			employee = Employee.find(a.employee_id)
			rejects.push(employee) if employee.current_location == 1
		end
		rejects = rejects.sort_by { |e| e.last_name }
		rejects.each do |e|
			e.update_attributes(station: 8, seat: (rejects.index(e) + 1))
		end
		wet_ones = [] # Wet Ones
		Assignment.where("job_id = ?", 3).take(wones_needed).each do |a|
			employee = Employee.find(a.employee_id)
			wet_ones.push(employee) if employee.current_location == 1
		end
		wet_ones = wet_ones.sort_by { |e| e.last_name }
		wet_ones.each do |e|
			if wet_ones.index(e) == wet_ones.size - 1
				e.update_attributes(station: 5, seat: 3)
			else
				e.update_attributes(station: 6, seat: ((wet_ones.index(e) * 2) + 1))
			end
		end
		entry = [] # Entry Station
		Assignment.where("job_id = ?", 2).take(entry_needed).each do |a|
			employee = Employee.find(a.employee_id)
			entry.push(employee) if employee.current_location == 1
		end
		entry = entry.sort_by { |e| e.last_name }
		entry.each do |e|
			e.update_attributes(station: 7, seat: ((entry.index(e) + 1) * 2))
		end
		wet = [] # Wet Station
		Assignment.where("job_id = ?", 1).take(wet_needed).each do |a|
			employee = Employee.find(a.employee_id)
			wet.push(employee) if employee.current_location == 2
		end
		wet = wet.sort_by { |e| e.last_name }
		wet.each do |e|
			e.update_attributes(station: 9, seat: (wet.index(e) + 1))
		end
		lab_employees = [] # The rest of the lab
		Employee.find_each do |e|
			lab_employees.push(e) if e.current_location == 1
		end
		remaining_employees = (lab_employees - (sarah + rejects + wet_ones + entry)).sort_by { |e| e.last_name }
		if remaining_employees[0..3] # Station 1
			station_1 = remaining_employees[0..3]
			station_1.each do |e|
				e.update_attributes(station: 1, seat: (station_1.index(e) + 1))
			end
		end
		if remaining_employees[4..7] # Station 2
			station_2 = remaining_employees[4..7]
			station_2.each do |e|
				e.update_attributes(station: 2, seat: (station_2.index(e) + 1))
			end
		end
		if remaining_employees[8..11] # Station 3
			station_3 = remaining_employees[8..11]
			station_3.each do |e|
				e.update_attributes(station: 3, seat: (station_3.index(e) + 1))
			end
		end
		if remaining_employees[12..13] # Station 4
			station_4 = remaining_employees[12..13]
			station_4.each do |e|
				e.update_attributes(station: 4, seat: ((station_4.index(e) * 2) + 1))
			end
		end
		if remaining_employees[14..16] # Station 5
			station_5 = remaining_employees[14..16]
			station_5.each do |e|
				if station_5.index(e) == station_5.size - 1
					e.update_attributes(station: 5, seat: 4)
				else
					e.update_attributes(station: 5, seat: (station_5.index(e) + 1))
				end
			end
		end
	end
end