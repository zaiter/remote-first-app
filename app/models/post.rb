class Post < ActiveRecord::Base
	# validates :content, presence: true

	validates_presence_of :content
	belongs_to :group, counter_cache: :posts_count
	belongs_to :author, class_name: "User", foreign_key: :user_id
	
 	has_many :user_post_votes
  	has_many :vote_by_users, through: :user_post_votes, source: :user

  	def editable_by?(user)
		user && user == author
	end

	scope :recent, -> { order("updated_at DESC") }

end
