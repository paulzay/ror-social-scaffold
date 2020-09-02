class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    return unless current_user.send_invitation(params[:user_id])

    flash[:success] = 'Friend request has been sent'
    redirect_to users_path
  end

  def accept
    return unless current_user.confirm_invites(params[:user_id])

    flash[:notice] = 'Friend request has been accepted.'
    redirect_to users_path
  end

  def deny
    current_user.reject_invites(params[:user_id])
    flash[:danger] = 'Friend request has been declined.'
    redirect_to users_path
  end

  def pending_invitation
    @pending_invitations = current_user.pending_invites
  end

  def destroy
    user = User.find(params[:user_id])
    friend = current_user.friendships.find_by_friend_id(user)
    return unless friend

    friend.delete
    flash[:notice] = 'has been successfully removed from your friends list.'
    redirect_to users_path
  end

  def friends_list
    @friends_list = current_user.friends
  end
  # before_action :authenticate_user!
  # before_action :def_user, only: %i[create accept deny destroy]

  # def index
  #   # @users = User.where.not(id: current_user).where.not(id: current_user.friends)
  #   # @user = current_user
  #   # @friends = @user.friends
  #   # @pending_friends = @user.pending_friends
  #   # @requested_friends = @user.requested_friends
  #   @user = current_user
  #   @friends = @user.friendships
  #   @pending_friends = @user.friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  #   @requested_friends = @user.inverse_friendships.map do |friendship|
  #     friendship.user unless friendship.confirmed
  #   end .compact
  # end

  # def show; end

  # def create
  #   if @user1 !=  @friend
  #     is_friendship = current_user.friendships.exists?(friend: @friend)
  #     if !is_friendship
  #       current_user.friendships.create(friend: @friend, confirmed: 'pending')
  #       @friend.friendships.create(friend: @user1, confirmed: 'requested')
  #       flash[:success] = "Friend request has been sent to #{@friend.name}."
  #       redirect_to friends_path
  #     else
  #       flash[:success] = "Friend request already sent"
  #       redirect_to friends_path
  #     end

  #   else
  #     flash[:danger] = "You can't friend yourself"
  #     redirect_to friends_path
  #   end
  #   # Friendship.request(@user1, @friend)
  #   # flash[:notice] = "Friend request has been sent to #{@friend.name}."
  #   # redirect_to user_path(@friend)
  # end

  # def accept
  #   Friendship.accept(@user1, @friend)
  #   flash[:notice] = "Friend request from #{@friend.name} has been accepted."
  #   redirect_to friends_path
  # end

  # def destroy
  #   Friendship.breakup(@user1, @friend)
  #   flash[:notice] = "#{@friend.name} has been successfully removed from your friends list."
  #   redirect_to friends_path
  # end
  # def deny
  #   Friendship.breakup(@user1, @friend)
  #   flash[:danger] = "Friend request from #{@friend.name} has been declined."
  #   redirect_to friends_path
  # end

  # private

  # def def_user
  #   @user1 = current_user
  #   @friend = User.find(params[:id])
  # end

  # def friends
  #   friends_array = friendships.map { |friendship| friendship.friend if friendship.confirmed }
  #   friends_array + inverse_friendships.map { |friendship| friendship.user if friendship.confirmed }
  #   friends_array.compact
  # end

  # # Users who have yet to confirm friend requests
  # def pending_friends
  #   friendships.map { |friendship| friendship.friend unless friendship.confirmed }.compact
  # end

  # # Users who have requested to be friends
  # def friend_requests
  #   inverse_friendships.map { |friendship| friendship.user unless friendship.confirmed }.compact
  # end

  # def confirm_friend(user)
  #   friendship = inverse_friendships.find { |friendship| friendship.user == user }
  #   friendship.confirmed = true
  #   friendship.save
  # end

  # def friend?(user)
  #   friends.include?(user)
  # end
end
