class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :inverted_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships, source: :user

  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_arrayb = inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.concat(friends_arrayb)
    friends_array.compact.uniq
  end

  # Users who have yet to confirmed friend invites
  def pending_invites
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  # Users who have requested to be friends
  def friend_invites(user_id)
    friendship = friendships.where(friend_id: user_id).first
    true if friendship && friendship.confirmed == false
  end

  def receive_invitation(user_id)
    friendship = inverse_friendships.where(user_id: user_id).first
    true if friendship && friendship.confirmed == false
  end

  def send_invitation(user_id)
    @friendship = Friendship.new(user_id: id, friend_id: user_id)
    @friendship.confirmed = false
    @friendship.save
  end

  def confirm_invites(user)
    friendship = inverse_friendships.where(user_id: user).first
    friendship.confirmed = true
    friendship.save
    inverse_friend_confirm = friendships.create(friend_id: user)
    inverse_friend_confirm.confirmed = true
    inverse_friend_confirm.save
  end

  def reject_invites(user)
    friendship = inverse_friendships.where(user_id: user).first
    friendship.destroy
  end

  def friend?(user)
    friends.include?(user)
  end
end
