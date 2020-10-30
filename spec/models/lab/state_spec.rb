# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab, '.published' do
  let!(:lab_1) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 1), published_at: Time.zone.local(2001, 1, 2) }
  let!(:lab_2) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 2), published_at: Time.zone.local(2001, 1, 1) }
  let!(:lab_draft) { FactoryBot.create :lab }

  context 'lab without published date on the past' do
    it 'is ignored' do
      expect(described_class.published).to include lab_1, lab_2
    end
  end

  context 'lab without published date in the same time' do
    before do
      allow(Time).to receive(:now).and_return Time.zone.local(2013, 1, 1, 0, 0, 0)

      @lab_now = FactoryBot.create :lab, published_at: Time.current
    end

    it 'is ignored' do
      expect(described_class.published).to include @lab_now
    end
  end

  context 'lab without published date' do
    it 'is ignored' do
      expect(described_class.published).not_to include lab_draft
    end
  end

  context 'lab with published date but in the future (scheduled)' do
    let!(:lab_scheduled) { FactoryBot.create :lab, published_at: Time.zone.local(2500, 1, 1) }

    it 'is ignored' do
      expect(described_class.published).not_to include lab_scheduled
    end
  end
end
