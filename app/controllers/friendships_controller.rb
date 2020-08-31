class FriendshipsController < ApplicationController

	before_action :authenticate_user!
	before_action :def_user, only: [:create, :accept, :deny, :destroy]

	def index
    	@user = current_user
		@friends = @user.friendships
		@pending_friends = @user.friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
		@requested_friends = @user.inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact
	end

	def show
	end

  	def create
    	Friendship.request(@user1, @friend)
    	flash[:notice] = "Friend request has been sent to #{@friend.name}."
    	redirect_to user_path(@friend)
  	end

	def accept
		Friendship.accept(@user1, @friend)
      	flash[:notice] = "Friend request from #{@friend.name} has been accepted."
    	redirect_to friends_path
	end

	def deny
		Friendship.breakup(@user1, @friend)
      	flash[:notice] = "Friend request from #{@friend.name} has been declined."
    	redirect_to friends_path
	end

	def destroy
		Friendship.breakup(@user1, @friend)
      	flash[:notice] = "#{@friend.name} has been successfully removed from your friends list."
    	redirect_to friends_path
	end

	private

	def def_user
    	@user1 = current_user
    	@friend = User.find(params[:id])
	end


	def friends
		friends_array = friendships.map{|friendship| friendship.friend if friendship.confirmed}
		friends_array + inverse_friendships.map{|friendship| friendship.user if friendship.confirmed}
		friends_array.compact
	  end
	
	  # Users who have yet to confirm friend requests
	  def pending_friends
		friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
	  end
	
	  # Users who have requested to be friends
	  def friend_requests
		inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact
	  end
	
	  def confirm_friend(user)
		friendship = inverse_friendships.find{|friendship| friendship.user == user}
		friendship.confirmed = true
		friendship.save
	  end
	
	  def friend?(user)
		friends.include?(user)
	  end
end