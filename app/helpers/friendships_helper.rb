module FriendshipsHelper
  def friends
    friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
    friends_array + inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
    friends_array.compact
  end

  # Users who have yet to confirm friend requests
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  end

  # def requested_friends
  #   inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  # end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |friendship| friendship.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def counts?(friends)
    if friends.nil? || friends.count.negative? || requested_friends.negative?
      render 'friendships/no_friend'
    else
      render 'friendships/requested_friends'
    end
  end
end
