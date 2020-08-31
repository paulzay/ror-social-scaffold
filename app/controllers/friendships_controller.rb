class FriendshipsController < ApplicationController
	before_action :authenticate_user!
	before_action :def_user, only: [:create, :accept, :deny, :destroy]

	def index
    	@user = current_user
		@friends = @user.friends.paginate :page => params[:page]
		@pending_friends = @user.pending_friends.paginate :page => params[:page]
		@requested_friends = @user.requested_friends.paginate :page => params[:page]
	end

	def show
	end

  	def create
    	Friendship.request(@user1, @friend)
    	flash[:notice] = "Friend request has been sent to #{@friend.screenname}."
    	redirect_to user_path(@friend)
  	end

	def accept
		Friendship.accept(@user1, @friend)
      	flash[:notice] = "Friend request from #{@friend.screenname} has been accepted."
    	redirect_to friends_path
	end

	def deny
		Friendship.breakup(@user1, @friend)
      	flash[:notice] = "Friend request from #{@friend.screenname} has been declined."
    	redirect_to friends_path
	end

	def destroy
		Friendship.breakup(@user1, @friend)
      	flash[:notice] = "#{@friend.screenname} has been successfully removed from your friends list."
    	redirect_to friends_path
	end

	private

	def def_user
    	@user1 = current_user
    	@friend = User.find(params[:id])
	end
end