# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Comment do
  it { expect(FactoryBot.build(:comment).valid?).to be(true) }

  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_presence_of :commentable }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :name }

  it 'creates a valid media' do
    commentable = FactoryBot.create(:commentable)

    comment = commentable.comments.new(
      body:  'body',
      email: 'john@example.org',
      name:  'name',
      url:   'https://example.org'
    )

    comment.parent = comment

    expect(comment.valid?).to be(true)
  end

  it 'validates the email format' do
    expect(FactoryBot.build(:comment, email: 'fail')).to be_invalid
    expect(FactoryBot.build(:comment, email: 'fail@')).to be_invalid
    expect(FactoryBot.build(:comment, email: 'fail@fail')).to be_invalid
    expect(FactoryBot.build(:comment, email: 'fail@fail.')).to be_invalid

    expect(FactoryBot.build(:comment, email: 'ok@ok.ok')).to be_valid
  end
end
