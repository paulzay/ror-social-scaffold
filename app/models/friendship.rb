class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.request(user, friend)
    # unless user == friend or Friendship.exists?(user, friend)
    return if user == friend or Friendship.exists?(user, friend)

    transaction do
      create(user: user, friend: friend, status: 'pending')
      create(user: friend, friend: user, status: 'requested')
    end
  end

  def self.accept(user, friend)
    transaction do
      updated_at = Time.now
      accept_one_side(user, friend, updated_at)
      accept_one_side(friend, user, updated_at)
    end
  end

  def self.accept_one_side(user, friend, _accepted_at)
    request = find_by_user_id_and_friend_id(user, friend)
    request.save!
  end
end
