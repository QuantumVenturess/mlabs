class EmployeesController < ApplicationController

	def index
		@title = "All Employees"
		@employees = Employee.all
	end

	def new
		@title = "New Employee"
		@employee = Employee.new
	end

	def create
		if params[:employee][:first_name] && params[:employee][:last_name] && params[:employee][:name] == ""
			params[:employee][:name] = "#{params[:employee][:first_name]} #{params[:employee][:last_name]}"
		elsif params[:employee][:name].split(' ').size >= 2 && params[:employee][:first_name] == "" && params[:employee][:last_name] == ""
			params[:employee][:first_name] = "#{params[:employee][:name].split(' ')[0]}"
			params[:employee][:last_name] = "#{params[:employee][:name].split(' ')[1]}"
		end
		@employee = Employee.new(params[:employee])
		if @employee.save
			redirect_to @employee
		else
			render 'new'
		end
	end

	def show
		@employee = Employee.find(params[:id])
		@title = "#{@employee.name}"
		@assignments = @employee.assignments
		@directions = @employee.directions
	end

	def edit
		@title = "Edit Employee"
		@employee = Employee.find(params[:id])
	end

	def update
		@employee = Employee.find(params[:id])
		if params[:employee][:first_name] && params[:employee][:last_name] && params[:employee][:name] == ""
			params[:employee][:name] = "#{params[:employee][:first_name]} #{params[:employee][:last_name]}"
		elsif params[:employee][:name].split(' ').size >= 2 && params[:employee][:first_name] == "" && params[:employee][:last_name] == ""
			params[:employee][:first_name] = "#{params[:employee][:name].split(' ')[0]}"
			params[:employee][:last_name] = "#{params[:employee][:name].split(' ')[1]}"
		end
		if @employee.update_attributes(params[:employee])
			redirect_to @employee
		else
			@title = "Edit Employee"
			render 'edit'
		end
	end

	def destroy
		Employee.find(params[:id]).destroy
		redirect_to employees_path
	end

	def jobs
		@employee = Employee.find(params[:id])
		@title = "Job Assignments"
		@assignments = @employee.assignments
	end

	def assign
		@employee = Employee.find(params[:id])
		@title = "New Assignment"
		@assignment = Assignment.new
	end

	def locations
		@employee = Employee.find(params[:id])
		@title = "Locations Worked"
		@directions = @employee.directions
	end

	def direct
		@employee = Employee.find(params[:id])
		@title = "New Direction"
		@direction = Direction.new
	end
end
