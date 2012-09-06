class AssignmentsController < ApplicationController

	def index
		@title = "All Assignments"
		@wet_station = Assignment.where("job_id = ?", 1).group_by(&:month_day)
		@entry_station = Assignment.where("job_id = ?", 2).group_by(&:month_day)
	end

	def create
		@assignment = Assignment.new(params[:assignment])
		if @assignment.save
			employee = Employee.find(@assignment.employee_id)
			if @assignment.job_id == 1
				employee.update_attribute(:wet_worked, true)
			elsif @assignment.job_id == 2
				employee.update_attribute(:entry_worked, true)
			elsif @assignment.job_id == 3
				employee.update_attribute(:wones_worked, true)
			elsif @assignment.job_id == 4
				employee.update_attribute(:qns_worked, true)
			elsif @assignment.job_id == 5
				employee.update_attribute(:sarah_worked, true)
			end
			redirect_to employee_path(employee)
		else
			@employee = Employee.find(params[:assignment][:employee_id])
			render 'employees/assign'
		end
	end

	def edit
		@title = "Edit Assignment"
		@assignment = Assignment.find(params[:id])
	end

	def update
		@assignment = Assignment.find(params[:id])
		if @assignment.update_attributes(params[:assignment])
			redirect_to employee_path(Employee.find(@assignment.employee_id))
		else
			@title = "Edit Assignment"
			render 'edit'
		end
	end

	def destroy
		@assignment = Assignment.find(params[:id])
		employee = Employee.find(@assignment.employee_id)
		if @assignment.job_id == 1
			employee.update_attribute(:wet_worked, false)
		elsif @assignment.job_id == 2
			employee.update_attribute(:entry_worked, false)
		elsif @assignment.job_id == 3
			employee.update_attribute(:wones_worked, false)
		elsif @assignment.job_id == 4
			employee.update_attribute(:qns_worked, false)
		elsif @assignment.job_id == 5
			employee.update_attribute(:sarah_worked, false)
		end
		@assignment.destroy
		redirect_to employee_path(employee)
	end

	def wet_assignment
		wet
		redirect_to jobs_path
	end

	def entry_assignment
		entry
		redirect_to jobs_path
	end

	def delete_assignments
		Assignment.destroy_all
		Employee.where("wet_worked = ? OR entry_worked = ?", true, true).each do |e|
			e.update_attributes(wet_worked: false, entry_worked: false)
		end
		redirect_to jobs_path
	end
end