class DefaultsController < ApplicationController

	def index
		@title = "System Defaults"
		@defaults = Default.all
	end

	def new
		if Default.first
			redirect_to edit_default_path(Default.first)
		else
			@title = "New Defaults"
			@default = Default.new
		end
	end

	def create
		@default = Default.new(params[:default])
		if @default.save
			redirect_to defaults_path
		else
			@title = "New Defaults"
			render 'new'
		end
	end

	def edit
		@title = "Edit Defaults"
		@default = Default.find(params[:id])
	end

	def update
		@default = Default.find(params[:id])
		if @default.update_attributes(params[:default])
			redirect_to defaults_path
		else
			@title = "Edit Defaults"
			render 'edit'
		end
	end

	def destroy
		Default.find(params[:id]).destroy
		redirect_to defaults_path
	end
end