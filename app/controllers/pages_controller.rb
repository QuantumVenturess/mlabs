class PagesController < ApplicationController

	def dashboard
		@title = "Dashboard"
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
		wet_a = Assignment.where("job_id = ?", 1).take(2).map(&:employee_id).join(', ')
		@wet_current = Employee.where("id IN (#{wet_a})")
		entry_a = Assignment.where("job_id = ?", 2).take(2).map(&:employee_id).join(', ')
		@entry_current = Employee.where("id IN (#{entry_a})")
	end
end