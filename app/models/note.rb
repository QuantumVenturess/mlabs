class Note < ActiveRecord::Base
	attr_accessible :name, :content, :employee_id

	belongs_to :employee
	belongs_to :user

	validates :content, presence: true

	default_scope order: "notes.updated_at DESC"

	def self.search(search)
		if search
			if Rails.env.production?
				where("name ILIKE ? OR content ILIKE ?", "%#{search}%", "%#{search}%")
			else
				where("name LIKE ? OR content LIKE ?", "%#{search}%", "%#{search}%")
			end
		else
			scoped
		end
	end
end