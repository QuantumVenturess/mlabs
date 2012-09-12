class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  include AssignmentsHelper
  include LocationsHelper

	private

		def default_settings
			if Default.first
				@lab_count = Default.first.lab_employees
				@entry_needed = Default.first.entry_employees
				@wones_needed = Default.first.wones_employees
				@qns_needed = Default.first.qns_employees
				@sarah_needed = Default.first.sarah_employees
				@wet_needed = Default.first.wet_employees
			else
				@lab_count = 24
				@entry_needed = 2
				@wones_needed = 3
				@qns_needed = 1
				@sarah_needed = 2
				@wet_needed = 2
			end
		end
end