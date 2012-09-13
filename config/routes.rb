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
			get :note
			get :notes
		end
	end
	resources :jobs
	resources :locations
	resources :notes
	resources :sessions, only: [:new, :create, :destroy]
	resources :undos do
		member do
			get :reverse
		end
	end
	resources :users

	#assignments
	match 'weekly-assignment' => 'assignments#weekly_assignment', as: 'weekly_assignment'
	match 'wet-assignment' => 'assignments#wet_assignment', as: 'wet_assignment'
	match 'entry-assignment' => 'assignments#entry_assignment', as: 'entry_assignment'
	match 'wones-assignment' => 'assignments#wones_assignment', as: 'wones_assignment'
	match 'rejects-assignment' => 'assignments#rejects_assignment', as: 'rejects_assignment'
	match 'sarah-assignment' => 'assignments#sarah_assignment', as: 'sarah_assignment'
	match 'seat-assignment' => 'assignments#seat_assignment', as: 'seat_assignment'
	match 'delete-assignments' => 'assignments#delete_assignments', as: 'delete_assignments'
	#employees
	match 'sarahs-team' => 'employees#sarah_team', as: 'sarah_team'
	match 'qns-team' => 'employees#qns_team', as: 'qns_team'
	match 'wet-ones' => 'employees#wet_ones', as: 'wet_ones'
	#jobs
	match 'all-jobs' => 'jobs#all_jobs', as: 'all_jobs'
	match 'wet-station' => 'jobs#wet_station', as: 'wet_station'
	match 'entry-station' => 'jobs#entry_station', as: 'entry_station'
	match 'wones-station' => 'jobs#wones_station', as: 'wones_station'
	match 'rejects-station' => 'jobs#rejects_station', as: 'rejects_station'
	match 'sarah-station' => 'jobs#sarah_station', as: 'sarah_station'
	#locations
	match 'switch-locations' => 'locations#switch_locations', as: 'switch_locations'
	match 'set-locations' => 'locations#set_locations', as: 'set_locations'
	match 'delete-directions' => 'locations#delete_directions', as: 'delete_directions'
	#pages
	root to: 'pages#dashboard'
	#sessions
	match 'signin' => 'sessions#new', as: 'signin'
	match 'signout' => 'sessions#destroy', as: 'signout'
end