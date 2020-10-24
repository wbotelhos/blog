# frozen_string_literal: true

RSpec.describe CommentPresenter, '.wrap' do
  let!(:comment_1) { FactoryBot.build(:comment) }
  let!(:comment_2) { FactoryBot.build(:comment) }

  it 'converts each comment into presenter' do
    comments = described_class.wrap([comment_1, comment_2])

    expect(comments.size).to eq 2

    expect(comments[0]).to eq comment_1
    expect(comments[0].class).to eq described_class

    expect(comments[1]).to eq comment_2
    expect(comments[1].class).to eq described_class
  end
end
