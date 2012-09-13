class UndosController < ApplicationController
	before_filter :authenticate
	before_filter :admin_user, only: :reverse

	def index
		@title = "History"
		@undos = Undo.all
	end

	def reverse
		@undo = Undo.find(params[:id])
		if @undo.name == "Set Locations" || @undo.name == "Switch Locations"
			undo_locations(@undo)
		else
			undo_assignments(@undo)
		end
		redirect_to undos_path
	end
end