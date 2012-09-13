class SessionsController < ApplicationController

	def new
		redirect_to root_path if signed_in?
		@title = "Sign In"
	end

	def create
		redirect_to root_path if signed_in?
		params[:session][:email] = params[:session][:email].downcase
		user = User.authenticate(params[:session][:email], params[:session][:password])
		if user
			if params[:remember_me]
				sign_in user
			else
				sign_in_temp user
			end
			user.increment!(:sign_in_count, by = 1)
			user.update_attribute(:last_signed_in, Time.now)
			redirect_back_or root_path
		else
			@title = "Sign In"
			flash.now[:error] = "The email or password you have entered is invalid."
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to signin_path
	end
end