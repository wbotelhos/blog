# frozen_string_literal: true

RSpec.describe Comment, '.roots' do
  let!(:parent) { FactoryBot.create :comment }

  it 'returns just the root' do
    # ignored: not root
    FactoryBot.create(:comment, parent: parent)

    expect(described_class.roots).to eq [parent]
  end
end
