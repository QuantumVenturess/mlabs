module LocationsHelper

	def set
		if Default.first
			lab_count = Default.first.lab_employees
			entry_needed = Default.first.entry_employees
			wones_needed = Default.first.wones_employees
			qns_needed = Default.first.qns_employees
			sarah_needed = Default.first.sarah_employees
			wet_needed = Default.first.wet_employees * Default.first.work_days
		else
			lab_count = 24
			entry_needed = 2
			wones_needed = 3
			qns_needed = 1
			sarah_needed = 2
			wet_needed = 10
		end # default values for how many employees of each type are required in the lab and office
		all = Employee.where("vacation = ?", false) 
		if all.size >= lab_count
			limit = ((all.map { |e| e.tier }.sum) * ((lab_count * 1.0)/all.size).round(2)).round
			lab_sum = 0
			while lab_sum < limit - (limit * 0.04).round || lab_sum > limit
				wet_not_worked = 0
				until wet_not_worked >= wet_needed
					entry_not_worked = 0
					if all.select { |e| !e.entry_worked? && !e.on_team? }.size - entry_needed <= entry_needed
						entry_not_worked_max = entry_needed
					else
						entry_not_worked_max = all.select { |e| !e.entry_worked? && !e.on_team? }.size - entry_needed
					end
					until entry_not_worked >= entry_needed && entry_not_worked <= entry_not_worked_max
						wones_not_worked = 0
						if all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed <= wones_needed
							wones_not_worked_max = wones_needed
						else
							wones_not_worked_max = all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed
						end
						until wones_not_worked >= wones_needed && wones_not_worked <= wones_not_worked_max
							qns_not_worked = 0
							if all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed <= qns_needed
								qns_not_worked_max = qns_needed
							else
								qns_not_worked_max = all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed
							end
							until qns_not_worked >= qns_needed && qns_not_worked <= qns_not_worked_max
								sarah_not_worked = 0
								until sarah_not_worked == sarah_needed
									all = all.shuffle
									lab_employees = all[0..(lab_count - 1)]
									office_employees = all[lab_count..(all.size - 1)]
									this_group = lab_employees.select { |e| e.sarah_team? && !e.sarah_worked? }
									sarah_not_worked = this_group.size
									temp_lab = lab_employees - this_group
								end
								this_group = temp_lab.select { |e| e.qns_team? && !e.qns_worked? }
								qns_not_worked = this_group.size
								temp_lab = temp_lab - this_group
								if all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed <= qns_needed
									qns_not_worked_max = qns_needed
								else
									qns_not_worked_max = all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed
								end
							end
							this_group = temp_lab.select { |e| e.wones_team? && !e.wones_worked? }
							wones_not_worked = this_group.size
							temp_lab = temp_lab - this_group
							if all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed <= wones_needed
								wones_not_worked_max = wones_needed
							else
								wones_not_worked_max = all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed
							end
						end
						this_group = temp_lab.select { |e| !e.entry_worked? }
						entry_not_worked = this_group.size
						if all.select { |e| !e.entry_worked? && !e.on_team? }.size - entry_needed <= entry_needed
							entry_not_worked_max = entry_needed
						else
							entry_not_worked_max = all.select { |e| !e.entry_worked? && !e.on_team? }.size - entry_needed
						end
					end
					wet_not_worked = office_employees.select { |e| !e.wet_worked? && !e.sarah_team? }.size
				end
				lab_sum = lab_employees.map { |e| e.tier }.sum
			end
			lab_employees.each do |e|
				e.directions.create(location_id: 1)
			end
			office_employees.each do |e|
				e.directions.create(location_id: 2)
			end
		end
		Undo.create(name: "Set Locations")
	end

	def switch
		if Default.first
			lab_count = Default.first.lab_employees
			entry_needed = Default.first.entry_employees
			wones_needed = Default.first.wones_employees
			qns_needed = Default.first.qns_employees
			sarah_needed = Default.first.sarah_employees
			wet_needed = Default.first.wet_employees * Default.first.work_days
		else
			lab_count = 24
			entry_needed = 2
			wones_needed = 3
			qns_needed = 1
			sarah_needed = 2
			wet_needed = 10
		end # default values for how many employees of each type are required in the lab and office
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
		end # put employees that are in the lab into lab_employees and put employees that are in the office into office_employees
		all = lab_employees + office_employees
		tier_sum = all.map{ |e| e.tier }.sum
		limit = (tier_sum * ((lab_employees.size * 1.0)/all.size).round(2)).round # calculate the tier sum value needed to be balanced in the lab
		must_assign_employees = []
		must_assign_wet = []
		undo_sarah = false
		undo_qns = false
		undo_wones = false
		undo_entry = false
		undo_wet = false
		if all.size >= (lab_count * 2.2).round && all.size >= (entry_needed + wones_needed + qns_needed + sarah_needed + wet_needed) * 2
			lab_sum = 0 # make sure the sum of each employee's tier levels are balanced in the lab and office
			while lab_sum < limit - (limit * 0.04).round || lab_sum > limit
				wet_not_worked = 0
				until wet_not_worked >= wet_needed
					entry_not_worked = 0
					if all.select { |e| !e.on_team? && !e.entry_worked? }.size - entry_needed <= entry_needed
						entry_not_worked_max = entry_needed
					else
						entry_not_worked_max = all.select { |e| !e.on_team? && !e.entry_worked? }.size - entry_needed
					end
					until entry_not_worked >= entry_needed && entry_not_worked <= entry_not_worked_max
						wones_not_worked = 0
						if all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed <= wones_needed
							wones_not_worked_max = wones_needed
						else
							wones_not_worked_max = all.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed
						end
						until wones_not_worked >= wones_needed && wones_not_worked <= wones_not_worked_max
							qns_not_worked = 0 # make sure there is at least 1 employee on the QNS Team that has not worked at Rejects Station
							if all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed <= qns_needed
								qns_not_worked_max = qns_needed
							else
								qns_not_worked_max = all.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed
							end
							until qns_not_worked >= qns_needed && qns_not_worked <= qns_not_worked_max
								sarah_not_worked = 0 # make sure there are exactly 2 employees on Sarah's Team that has not worked at Sarah's Station
								until sarah_not_worked == sarah_needed
									if all.select { |e| e.sarah_team? && !e.sarah_worked? }.size < sarah_needed
										sarahs_team = all.select { |e| e.sarah_team? } # all employees on Sarah's Team
										sarahs_team_not_worked = sarahs_team.select { |e| !e.sarah_worked? } # all employees on Sarah's Team that have not worked Sarah's Station
										sarahs_team_not_worked.each do |e|
											e.update_attribute(:must_assign, 5)
											must_assign_employees.push(e)
										end
										sarahs_team.each do |e|
											e.update_attribute(:sarah_worked, false)
										end
										undo_sarah = true
									end
									if all.select { |e| e.qns_team? && !e.qns_worked? }.size < qns_needed
										qns_team = all.select { |e| e.qns_team? } # all employees on QNS Team
										qns_team_not_worked = qns_team.select { |e| !e.qns_worked? } # all employees on QNS Team that have not worked QNS Station
										qns_team_not_worked.each do |e|
											e.update_attribute(:must_assign, 4)
											must_assign_employees.push(e)
										end
										qns_team.each do |e|
											e.update_attribute(:qns_worked, false)
										end
										undo_qns = true
									end
									if all.select { |e| e.wones_team? && !e.wones_worked? }.size < wones_needed
										wones_team = all.select { |e| e.wones_team? } # all employees on Wet Ones Team
										wones_team_not_worked = wones_team.select { |e| !e.wones_worked? } # all employees on Wet Ones Team that have not worked Wet Ones Station
										wones_team_not_worked.each do |e|
											e.update_attribute(:must_assign, 3)
											must_assign_employees.push(e)
										end
										wones_team.each do |e|
											e.update_attribute(:wones_worked, false)
										end
										undo_wones = true
									end
									if all.select { |e| !e.on_team? && !e.entry_worked? }.size < entry_needed
										entry_team = all.select { |e| !e.on_team? } # all employees not on a team
										entry_team_not_worked = entry_team.select { |e| !e.entry_worked? } # all employees not on a team that have not worked Entry Station
										entry_team_not_worked.each do |e|
											e.update_attribute(:must_assign, 2)
											must_assign_employees.push(e)
										end
										entry_team.each do |e|
											e.update_attribute(:entry_worked, false)
										end
										undo_entry = true
									end
									if all.select { |e| !e.sarah_team? && !e.wet_worked? }.size < wet_needed
										wet_team = all.select { |e| !e.sarah_team } # all employees who are not on Sarah's Team
										wet_team_not_worked = wet_team.select { |e| !e.wet_worked? } # all employees who are not on Sarah's Team that have not worked Wet Station
										wet_team_not_worked.each do |e|
											e.update_attribute(:must_assign, 1)
											must_assign_wet.push(e)
										end
										wet_team.each do |e|
											e.update_attribute(:wet_worked, false)
										end
										undo_wet = true
									end
									new_lab_employees = office_employees.reject { |e| must_assign_wet.include?(e) || must_assign_employees.include?(e) }.shuffle.take(lab_count - must_assign_employees.size) + must_assign_employees
									remaining_employees = office_employees - new_lab_employees
									new_office_employees = lab_employees + remaining_employees
									this_group = new_lab_employees.select { |e| e.sarah_team? && !e.sarah_worked? }
									sarah_not_worked = this_group.size
									temp_lab = new_lab_employees - this_group
								end
								this_group = temp_lab.select { |e| e.qns_team? && !e.qns_worked? }
								qns_not_worked = this_group.size
								temp_lab = temp_lab - this_group
								if new_lab_employees.select { |e| e.qns_team? && !e.qns_worked? }.size + new_office_employees.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed <= qns_needed
									qns_not_worked_max = qns_needed
								else
									qns_not_worked_max = new_lab_employees.select { |e| e.qns_team? && !e.qns_worked? }.size + new_office_employees.select { |e| e.qns_team? && !e.qns_worked? }.size - qns_needed
								end
							end
							this_group = temp_lab.select { |e| e.wones_team? && !e.wones_worked? }
							wones_not_worked = this_group.size
							temp_lab = temp_lab - this_group
							if new_lab_employees.select { |e| e.wones_team? && !e.wones_worked? }.size + new_office_employees.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed <= wones_needed
								wones_not_worked_max = wones_needed
							else
								wones_not_worked_max = new_lab_employees.select { |e| e.wones_team? && !e.wones_worked? }.size + new_office_employees.select { |e| e.wones_team? && !e.wones_worked? }.size - wones_needed
							end
						end
						this_group = temp_lab.select { |e| !e.on_team? && !e.entry_worked? }
						entry_not_worked = this_group.size
						temp_lab = temp_lab - this_group
						if new_lab_employees.select { |e| !e.on_team? && !e.entry_worked? }.size + new_office_employees.select { |e| !e.on_team? && !e.entry_worked? }.size - entry_needed <= entry_needed
							entry_not_worked_max = entry_needed
						else
							entry_not_worked_max = new_lab_employees.select { |e| !e.on_team? && !e.entry_worked? }.size + new_office_employees.select { |e| !e.on_team? && !e.entry_worked? }.size - entry_needed
						end
					end
					wet_not_worked = (lab_employees + remaining_employees).select { |e| !e.sarah_team? && !e.wet_worked? }.size
				end
				lab_sum = new_lab_employees.map { |e| e.tier }.sum
			end
			new_lab_employees.each do |e| # take the employees taken from the office and relocate them into the lab
				e.directions.create(location_id: 1)
			end
			new_office_employees.each do |e| # take the old employees in the lab and the remaining employees and relocate them into the office
				e.directions.create(location_id: 2)
			end
		end
		if undo_sarah # Sarah IDs
			sarah_must_assign = must_assign_employees.select { |e| e.sarah_team? }
			sarah_undo = all.select { |e| e.sarah_team? && !sarah_must_assign.include?(e) && !e.vacation? }.map(&:id).join(", ")
		else
			sara_undo = nil
		end
		if undo_qns # QNS IDs
			qns_must_assign = must_assign_employees.select { |e| e.qns_team? }
			qns_undo = all.select { |e| e.qns_team? && !qns_must_assign.include?(e) && !e.vacation? }.map(&:id).join(", ")
		else
			qns_undo = nil
		end
		if undo_wones # Wet Ones IDS
			wones_must_assign = must_assign_employees.select { |e| e.wones_team? }
			wones_undo = all.select { |e| e.wones_team? && !wones_must_assign.include?(e) && !e.vacation? }.map(&:id).join(", ")
		else
			wones_undo = nil
		end
		if undo_entry  # Entry IDs
			entry_must_assign = must_assign_employees.select { |e| !e.on_team? }
			entry_undo = all.select { |e| !e.on_team? && !entry_must_assign.include?(e) && !e.vacation? }.map(&:id).join(", ")
		else
			entry_undo = nil
		end
		if undo_wet # Wet IDs
			wet_must_assign = must_assign_wet
			wet_undo = all.select { |e| !e.sarah_team? && !wet_must_assign.include?(e) && !e.vacation? }.map(&:id).join(", ")
		else
			wet_undo = nil
		end
		Undo.create(name: "Switch Locations", sarah: sarah_undo, qns: qns_undo, wones: wones_undo, entry: entry_undo, wet: wet_undo)
	end

	def undo_locations(undo)
		max_time = undo.created_at + 10
		min_time = undo.created_at - 10
		directions = Direction.where("created_at > ? AND created_at < ?", min_time, max_time)
		directions.destroy_all
		if !undo.sarah.nil? && undo.sarah != ""
			Employee.where("sarah_team = ? AND id NOT IN (#{undo.sarah})", true).each do |e|
				e.update_attribute(:must_assign, 0)
			end
			Employee.where("sarah_team = ? AND id IN (#{undo.sarah})", true).each do |e|
				e.update_attribute(:sarah_worked, true)
			end
		end
		if !undo.qns.nil? && undo.qns != ""
			Employee.where("qns_team = ? AND id NOT IN (#{undo.qns})", true).each do |e|
				e.update_attribute(:must_assign, 0)
			end
			Employee.where("qns_team = ? AND id IN (#{undo.qns})", true).each do |e|
				e.update_attribute(:qns_worked, true)
			end
		end
		if !undo.wones.nil? && undo.wones != ""
			Employee.where("wones_team = ? AND id NOT IN (#{undo.wones})", true).each do |e|
				e.update_attribute(:must_assign, 0)
			end
			Employee.where("wones_team = ? AND id IN (#{undo.wones})", true).each do |e|
				e.update_attribute(:wones_worked, true)
			end
		end
		if !undo.entry.nil? && undo.entry != ""
			Employee.where("wones_team = ? AND qns_team = ? AND sarah_team = ? AND id NOT IN (#{undo.entry})", false, false, false).each do |e|
				e.update_attribute(:must_assign, 0)
			end
			Employee.where("wones_team = ? AND qns_team = ? AND sarah_team = ? AND id IN (#{undo.entry})", false, false, false).each do |e|
				e.update_attribute(:entry_worked, true)
			end
		end
		if !undo.wet.nil? && undo.wet != ""
			Employee.where("sarah_team = ? AND id NOT IN (#{undo.wet})", false).each do |e|
				e.update_attribute(:must_assign, 0)
			end
			Employee.where("sarah_team = ? AND id IN (#{undo.wet})", false).each do |e|
				e.update_attribute(:wet_worked, true)
			end
		end
		undo.destroy
	end

	def move_assignments
		Assignment.find_each do |a|
			a.update_attribute(:created_at, Time.now - 86400 * 7 * 20)
		end
	end
end