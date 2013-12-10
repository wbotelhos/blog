require 'spec_helper'

describe Comment do
  it 'has a valid factory' do
    FactoryGirl.build(:comment).should be_valid
  end

  it { should validate_presence_of :article }
  it { should validate_presence_of :body }
  it { should validate_presence_of :email }
  it { should validate_presence_of :name }

  context :create do
    let!(:article) { FactoryGirl.create :article }
    let!(:comment) { FactoryGirl.create :comment }

    it 'creates a valid media' do
      expect {
        comment = Comment.new(
          article_id: article.id,
          body:       'body',
          email:      'john@example.org',
          name:       'name',
          url:        'http://example.org'
        )

        comment.parent = comment
        comment.save!
      }.to_not raise_error
    end

    it 'validates the email' do
      expect(FactoryGirl.build(:comment, email: 'fail')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@fail')).to be_invalid
      expect(FactoryGirl.build(:comment, email: 'fail@fail.')).to be_invalid

      expect(FactoryGirl.build(:comment, email: 'ok@ok.ok')).to be_valid
    end
  end

  context :scope do
    describe :roots do
      let!(:article) { FactoryGirl.create :article }
      let!(:parent)  { FactoryGirl.create :comment, article: article }
      let!(:child)   { FactoryGirl.create :comment, article: article, parent: parent }

      it 'returns just the root comments' do
        expect(Comment.roots).to eq [parent]
      end
    end
  end
end
