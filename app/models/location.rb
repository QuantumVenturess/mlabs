class Location < ActiveRecord::Base
	attr_accessible :name

	has_many :directions, dependent: :destroy
	has_many :employees, through: :directions

	validates :name, presence: true
	validates :name, uniqueness: true
end
