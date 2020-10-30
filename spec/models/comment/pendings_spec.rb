# frozen_string_literal: true

RSpec.describe Comment, '.pendings' do
  let!(:pending) { FactoryBot.create(:comment) }

  it 'returns just the pendings that does not belongs to author' do
    # ignored: not pending
    FactoryBot.create(:comment, pending: false)

    # ignored: belongs to the author
    FactoryBot.create(:comment, author: true)

    expect(described_class.pendings).to eq [pending]
  end
end
