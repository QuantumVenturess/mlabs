class NotesController < ApplicationController
	before_filter :authenticate

	def create
		if params[:note][:name] == ""
			params[:note][:name] == "Employee Note"
		end
		note = current_user.notes.new(params[:note])
		employee = Employee.find_by_id(params[:note][:employee_id])
		if note.save
			flash[:success] = "Note successfully created."
			redirect_to note
		else
			redirect_to note_employee_path(employee)
		end
	end

	def show
		@note = Note.find(params[:id])
		@title = "#{@note.name}"
	end

	def edit
		@note = Note.find(params[:id])
		@title = "Edit Note"
	end

	def update
		@note = Note.find(params[:id])
		if @note.update_attributes(params[:note])
			flash[:success] = "Note successfully updated."
			redirect_to @note
		else
			@title = "Edit Note"
			render 'edit'
		end
	end

	def destroy
		note = Note.find(params[:id])
		employee = Employee.find(note.employee_id)
		if current_user == User.find_by_id(note.user_id) || current_user.admin?
			note.destroy
			redirect_to notes_employee_path(employee)
		else
			flash[:error] = "You cannot delete someone else's note."
			redirect_to note
		end
	end
end