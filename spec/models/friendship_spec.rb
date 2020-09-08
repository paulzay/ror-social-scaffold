require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { User.create(name: 'papawemba', email: 'wemba@example.com', password: '123123') }
  let(:friend) { User.create(name: 'koffi', email: 'koffi@example.com', password: '123123') }
  let(:friendship) { Friendship.create(user_id: user.id, friend_id: friend.id) }

  context 'Association' do
    it 'should belong to user' do
      t = Friendship.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'should belong to friend' do
      t = Friendship.reflect_on_association(:friend)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
