# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab, '.state' do
  let!(:lab_1) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 1), published_at: Time.zone.local(2001, 1, 2) }
  let!(:lab_2) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 2), published_at: Time.zone.local(2001, 1, 1) }
  let!(:lab_draft) { FactoryBot.create :lab }

  it 'returns drafts' do
    expect(described_class.drafts).to eq [lab_draft]
  end
end
