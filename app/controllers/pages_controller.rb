class PagesController < ApplicationController

	def dashboard
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

	def overview
		@title = "Overview"
		lab_employees = []
		office_employees =[]
		Employee.find_each do |e|
			if e.current_location == 1
				lab_employees.push(e)
			elsif e.current_location == 2
				office_employees.push(e)
			end
		end
		@lab = lab_employees.sort_by { |e| e.last_name }
		@office = office_employees.sort_by { |e| e.last_name }
		wet_a = Assignment.where("job_id = ?", 1).take(2).map(&:employee_id)
		@wet_current = []
		wet_a.each do |e|
			@wet_current.push(Employee.find(e))
		end
		entry_a = Assignment.where("job_id = ?", 2).take(2).map(&:employee_id)
		@entry_current = []
		entry_a.each do |e|
			@entry_current.push(Employee.find(e))
		end
	end
end