class Undo < ActiveRecord::Base
	attr_accessible :name, :sarah, :qns, :wones, :entry, :wet

	default_scope order: "undos.created_at DESC"
end