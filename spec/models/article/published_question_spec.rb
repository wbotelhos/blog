# frozen_string_literal: true

RSpec.describe Article, '.published?' do
  context 'when unpublished' do
    it 'returns false' do
      expect(described_class.new).not_to be_published
    end
  end

  context 'when published' do
    it 'returns true' do
      expect(described_class.new(published_at: Time.current)).to be_published
    end
  end
end
