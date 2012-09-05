class DirectionsController < ApplicationController

	def create
		@direction = Direction.new(params[:direction])
		if @direction.save
			redirect_to employee_path(Employee.find(@direction.employee_id))
		else
			@employee = params[:direction][:employee_id]
			render 'employees/direct'
		end
	end

	def edit
		@title = "Edit Direction"
		@direction = Direction.find(params[:id])
	end

	def update
		@direction = Direction.find(params[:id])
		if @direction.update_attributes(params[:direction])
			redirect_to employee_path(Employee.find(@direction.employee_id))
		else
			@title = "Edit Direction"
			render 'edit'
		end
	end

	def destroy
		direction = Direction.find(params[:id])
		employee = Employee.find(direction.employee_id)
		direction.destroy
		redirect_to employee_path(employee)
	end
end