class JobsController < ApplicationController
	before_filter :default_settings, only: :index
	before_filter :authenticate
	before_filter :admin_user, only: [:new, :create, :show, :edit, :update, :destroy, :all_jobs]

	def index
		@title = "Job Assignments"
		@wet = Assignment.where("job_id = ?", 1).take(@wet_needed)
		@wet_station = @wet.group_by(&:month_day)
		@entry = Assignment.where("job_id = ?", 2).take(@entry_needed)
		@entry_station = @entry.group_by(&:month_day)
		@wones = Assignment.where("job_id = ?", 3).take(@wones_needed)
		@wones_station = @wones.group_by(&:month_day)
		@qns = Assignment.where("job_id = ?", 4).take(@qns_needed)
		@qns_station = @qns.group_by(&:month_day)
		@sarah = Assignment.where("job_id = ?", 5).take(@sarah_needed)
		@sarah_station = @sarah.group_by(&:month_day)
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

	def wet_station
		@title = "Wet Station"
		@all_assignments = Assignment.where("job_id = ?", 1).search(params[:search])
		@assignments = @all_assignments.paginate(page: params[:page], per_page: 20)
		render 'jobs'
	end

	def entry_station
		@title = "Entry Station"
		@all_assignments = Assignment.where("job_id = ?", 2).search(params[:search])
		@assignments = @all_assignments.paginate(page: params[:page], per_page: 20)
		render 'jobs'
	end

	def wones_station
		@title = "Wet Ones Station"
		@all_assignments = Assignment.where("job_id = ?", 3).search(params[:search])
		@assignments = @all_assignments.paginate(page: params[:page], per_page: 20)
		render 'jobs'
	end

	def rejects_station
		@title = "Rejects Station"
		@all_assignments = Assignment.where("job_id = ?", 4).search(params[:search])
		@assignments = @all_assignments.paginate(page: params[:page], per_page: 20)
		render 'jobs'
	end

	def sarah_station
		@title = "Sarah's Station"
		@all_assignments = Assignment.where("job_id = ?", 5).search(params[:search])
		@assignments = @all_assignments.paginate(page: params[:page], per_page: 20)
		render 'jobs'
	end
end