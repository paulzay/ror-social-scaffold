module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end
  def friend_btn(user)
    if current_user.friend_invites(user)
      'Pending Invite'
    elsif current_user.receive_invitation(user)

      link_to('Decline', deny_request_path(user_id: user.id), method: :delete)

    elsif !current_user.friend?(user) && current_user.id != user.id

      link_to 'Add Friend', add_friend_path(user_id: user.id)
    elsif current_user.friend?(user)

      link_to 'Remove friend', delete_friend_path(user_id: user.id),
              method: :delete,
              data: { confirm: 'Are you sure you want to remove friend?' },
              class: 'btn btn-danger'
    end
  end

  def friend_accept(user)
    return unless current_user.friend?(user) == user || current_user.receive_invitation(user)

    link_to('Accept', accept_request_path(user_id: user.id))
  end
end
