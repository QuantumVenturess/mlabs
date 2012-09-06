Mlabs::Application.routes.draw do

	resources :assignments
	resources :defaults
	resources :directions
	resources :employees do
		member do
			get :jobs
			get :assign
			get :locations
			get :direct
		end
	end
	resources :jobs
	resources :locations

	#assignments
	match 'wet-assignment' => 'assignments#wet_assignment', as: 'wet_assignment'
	match 'entry-assignment' => 'assignments#entry_assignment', as: 'entry_assignment'
	match 'delete-assignments' => 'assignments#delete_assignments', as: 'delete_assignments'
	#jobs
	match 'all-jobs' => 'jobs#all_jobs', as: 'all_jobs'
	#locations
	match 'switch-locations' => 'locations#switch_locations', as: 'switch_locations'
	match 'set-locations' => 'locations#set_locations', as: 'set_locations'
	match 'delete-directions' => 'locations#delete_directions', as: 'delete_directions'
	#pages
	root to: 'pages#dashboard'
	match 'overview' => 'pages#overview', as: 'overview'
end