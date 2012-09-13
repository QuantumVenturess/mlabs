class UsersController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user, only: [:edit, :updated]
	before_filter :admin_user, only: :destroy

	def index
		@title = "All Users"
		@users = User.search(params[:search]).paginate(page: params[:page], per_page: 20)
	end

	def show
		@user = User.find(params[:id])
		@title = "#{@user.name}"
	end

	def new
		@title = "New User"
		@user = User.new
	end

	def create
		params[:user][:email] = params[:user][:email].downcase
		@user = User.new(params[:user])
		if @user.save
			flash[:success] = "User successfully created."
			redirect_to users_path
		else
			@title = "New User"
			render 'new'
		end
	end

	def edit
		@title = "Edit Profile"
		@user = User.find(params[:id])
	end

	def update
		params[:user][:email] = params[:user][:email].downcase
		@user = User.find(params[:id])
  		if @user.update_attributes(params[:user])
  			if params[:user][:password].length >= 2 && params[:user][:password_confirmation].length >= 2 && @user == current_user
  				flash[:success] = "Password changed. Please sign in with your new password."
				sign_out
				redirect_to signin_path
			else
				flash[:success] = "User profile has been updated."
		  		redirect_to users_path
		  	end
  		else
  			@title = "Edit Profile"
  			render 'edit'
  		end
	end

	def destroy
		user = User.find(params[:id])
		if current_user == user
			flash[:notice] = "You cannot delete yourself"
			redirect_to users_path
		else
			user.destroy
			redirect_to users_path
		end
	end
end