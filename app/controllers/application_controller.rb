class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  include AssignmentsHelper
  include LocationsHelper
end
