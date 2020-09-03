class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends_list = current_user.friends
  end

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
    friend = User.find_by_id(params[:user_id])
    inv = Friendship.find_by(user: friend, friend: current_user)
    not_inv = Friendship.find_by(user: current_user, friend: friend)
    if inv || not_inv
      inv&.destroy
      not_inv&.destroy
      flash[:notice] = 'Frendship terminated'
      redirect_to users_path
    else
      flash[:danger] = 'Error occured'
      redirect_to users_path
    end
  end


end
