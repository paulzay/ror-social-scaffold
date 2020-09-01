require 'rails_helper'

# Test suite for the User model
RSpec.describe User, type: :model do
  let(:user1) do
    User.create(name: 'papawemba', email: 'wemba@example.com',
                password: '123123', password_confirmation: '123123')
  end
  let(:friend) do
    User.create(name: 'koffi', email: 'koffi@example.com',
                password: 'foobar', password_confirmation: 'foobar')
  end
  let(:friendship) { Friendship.create(user_id: user1.id, friend_id: friend.id, status: false) }

  # Validation tests
  context 'validation' do
    subject do
      described_class.new(name: 'papawemba', email: 'wemba@example.com', password: 'foobar')
    end

    it 'is valid with the required attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a valid email' do
      subject.email = 'yyyyy'
      expect(subject).to_not be_valid
    end
  end

  # Association test
  context 'Association' do
    it 'should have many posts' do
      t = User.reflect_on_association(:posts)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many comments' do
      t = User.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many likes' do
      t = User.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many friendships' do
      t = User.reflect_on_association(:friendships)
      expect(t.macro).to eq(:has_many)
    end
    it 'should have many inverse_friendships' do
      t = User.reflect_on_association(:inverse_friendships)
      expect(t.macro).to eq(:has_many)
    end
  end
end
