require 'spec_helper'

describe Comment do
  it 'has a valid factory' do
    expect(FactoryGirl.build :comment).to be_valid
  end

  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_presence_of :commentable }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :name }

  context :create do
    let!(:commentable) { FactoryGirl.create :commentable }

    it 'creates a valid media' do
      comment = commentable.comments.new(
        body:  'body',
        email: 'john@example.org',
        name:  'name',
        url:   'http://example.org'
      )

      comment.parent = comment
      expect(comment).to be_valid
    end
  end

  context :format do
    it 'validates the email format' do
      expect(FactoryGirl.build(:comment, email: 'fail')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@fail')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@fail.')).to be_invalid

      expect(FactoryGirl.build(:comment, email: 'ok@ok.ok')).to be_valid
    end
  end

  context :scope do
    describe :roots do
      let!(:parent) { FactoryGirl.create :comment }
      let!(:child)  { FactoryGirl.create :comment, parent: parent }

      it 'returns just the root' do
        expect(Comment.roots).to eq [parent]
      end
    end

    describe :pendings do
      let!(:comment)  { FactoryGirl.create :comment, pending: false }
      let!(:authored) { FactoryGirl.create :comment, author: true }
      let!(:pending)  { FactoryGirl.create :comment }

      it 'returns just the pendings that does not belongs to author' do
        expect(Comment.pendings).to eq [pending]
      end
    end
  end
end
