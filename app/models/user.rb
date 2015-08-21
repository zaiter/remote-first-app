class User < ActiveRecord::Base
 
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :groups
  has_many :posts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :group_users
  has_many :participated_groups, through: :group_users, source: :group
  has_many :user_post_votes
  has_many :votes, through: :user_post_votes, source: :post

  def join!(group)
    participated_groups << group
  end
 
  def quit!(group)
    participated_groups.delete(group)
  end
  
  def is_member_of?(group)
    participated_groups.include?(group)
  end

end

