class JobsController < ApplicationController

	def index
		@title = "Job Assignments"
		@wet = Assignment.where("job_id = ?", 1)
		@wet_station = @wet.group_by(&:month_day)
		@entry = Assignment.where("job_id = ?", 2)
		@entry_station = @entry.group_by(&:month_day)
	end

	def new
		@title = "New Job"
		@job = Job.new
	end

	def create
		@job = Job.new(params[:job])
		if @job.save
			redirect_to all_jobs_path
		else
			render 'new'
		end
	end

	def show
		@job = Job.find(params[:id])
		@title = "#{@job.name}"
	end

	def edit
		@title = "Edit Job"
		@job = Job.find(params[:id])
	end

	def update
		@job = Job.find(params[:id])
		if @job.update_attributes(params[:job])
			redirect_to all_jobs_path
		else
			@title = "Edit Job"
			render 'edit'
		end
	end

	def destroy
		Job.find(params[:id]).destroy
		redirect_to all_jobs_path
	end

	def all_jobs
		@title = "All Jobs"
		@jobs = Job.all
	end
end