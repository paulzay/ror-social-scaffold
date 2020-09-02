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
end
