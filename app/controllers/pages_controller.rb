class PagesController < ApplicationController
	before_filter :authenticate

	def dashboard
		@title = "Dashboard"
		lab_employees = []
		office_employees = []
		Employee.find_each do |e|
			if e.current_location == 1
				lab_employees.push(e)
			elsif e.current_location == 2
				office_employees.push(e) if e.assignments.first
			end
		end
		# Station 1
		@station1_1 = lab_employees.select { |e| e.station == 1 && e.seat == 1 }[0]
		@station1_2 = lab_employees.select { |e| e.station == 1 && e.seat == 2 }[0]
		@station1_3 = lab_employees.select { |e| e.station == 1 && e.seat == 3 }[0]
		@station1_4 = lab_employees.select { |e| e.station == 1 && e.seat == 4 }[0]
		# Station 2
		@station2_1 = lab_employees.select { |e| e.station == 2 && e.seat == 1 }[0]
		@station2_2 = lab_employees.select { |e| e.station == 2 && e.seat == 2 }[0]
		@station2_3 = lab_employees.select { |e| e.station == 2 && e.seat == 3 }[0]
		@station2_4 = lab_employees.select { |e| e.station == 2 && e.seat == 4 }[0]
		# Station 3
		@station3_1 = lab_employees.select { |e| e.station == 3 && e.seat == 1 }[0]
		@station3_2 = lab_employees.select { |e| e.station == 3 && e.seat == 2 }[0]
		@station3_3 = lab_employees.select { |e| e.station == 3 && e.seat == 3 }[0]
		@station3_4 = lab_employees.select { |e| e.station == 3 && e.seat == 4 }[0]
		# Station 4
		@station4_1 = lab_employees.select { |e| e.station == 4 && e.seat == 1 }[0]
		@station4_2 = lab_employees.select { |e| e.station == 4 && e.seat == 2 }[0]
		@station4_3 = lab_employees.select { |e| e.station == 4 && e.seat == 3 }[0]
		@station4_4 = lab_employees.select { |e| e.station == 4 && e.seat == 4 }[0]
		# Station 5
		@station5_1 = lab_employees.select { |e| e.station == 5 && e.seat == 1 }[0]
		@station5_2 = lab_employees.select { |e| e.station == 5 && e.seat == 2 }[0]
		@station5_3 = lab_employees.select { |e| e.station == 5 && e.seat == 3 }[0]
		@station5_4 = lab_employees.select { |e| e.station == 5 && e.seat == 4 }[0]
		# Station 6
		@station6_1 = lab_employees.select { |e| e.station == 6 && e.seat == 1 }[0]
		@station6_2 = lab_employees.select { |e| e.station == 6 && e.seat == 2 }[0]
		@station6_3 = lab_employees.select { |e| e.station == 6 && e.seat == 3 }[0]
		@station6_4 = lab_employees.select { |e| e.station == 6 && e.seat == 4 }[0]
		# Station 7
		@station7_1 = lab_employees.select { |e| e.station == 7 && e.seat == 1 }[0]
		@station7_2 = lab_employees.select { |e| e.station == 7 && e.seat == 2 }[0]
		@station7_3 = lab_employees.select { |e| e.station == 7 && e.seat == 3 }[0]
		@station7_4 = lab_employees.select { |e| e.station == 7 && e.seat == 4 }[0]
		# Station 8
		@station8_1 = lab_employees.select { |e| e.station == 8 && e.seat == 1 }[0]
		@station8_2 = lab_employees.select { |e| e.station == 8 && e.seat == 2 }[0]
		@station8_3 = lab_employees.select { |e| e.station == 8 && e.seat == 3 }[0]
		@station8_4 = lab_employees.select { |e| e.station == 8 && e.seat == 4 }[0]
		# Station 9
		@station9_1 = office_employees.sort_by { |e| e.assignments.first.created_at }.reverse.select { |e| e.station == 9 && e.seat == 1 }[0]
		@station9_2 = office_employees.sort_by { |e| e.assignments.first.created_at }.reverse.select { |e| e.station == 9 && e.seat == 2 }[0]
		@station9_3 = office_employees.sort_by { |e| e.assignments.first.created_at }.reverse.select { |e| e.station == 9 && e.seat == 3 }[0]
		@station9_4 = office_employees.sort_by { |e| e.assignments.first.created_at }.reverse.select { |e| e.station == 9 && e.seat == 4 }[0]
	end

	def dashboard_old
		@title = "Dashboard"
		lab_employees = []
		Employee.find_each do |e|
			if e.current_location == 1
				lab_employees.push(e)
			end
		end
		wet_station = []
		Assignment.where("job_id = ?", 1).take(2).each do |a|
			if Employee.find(a.employee_id).directions.first.location_id == 1
				wet_station.push(Employee.find(a.employee_id))
			end
		end
		entry_station = []
		Assignment.where("job_id = ?", 2).take(2).each do |a|
			if Employee.find(a.employee_id).directions.first.location_id == 1
				entry_station.push(Employee.find(a.employee_id))
			end
		end
		@lab = (lab_employees - (wet_station + entry_station)).sort_by { |e| e.last_name }
		@wet_station = wet_station.sort_by { |e| e.last_name }
		@entry_station = entry_station.sort_by { |e| e.last_name }
	end
end