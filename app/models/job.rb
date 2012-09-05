class Job < ActiveRecord::Base
	attr_accessible :id, :name

	has_many :assignments, dependent: :destroy
	has_many :employees, through: :assignments

	validates :name, presence: true
	validates :name, uniqueness: true
end