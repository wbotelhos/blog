# frozen_string_literal: true

RSpec.describe Lab, '.by_created' do
  let!(:lab_1) { FactoryBot.create :lab, created_at: Time.zone.local(2013, 1) }
  let!(:lab_2) { FactoryBot.create :lab, created_at: Time.zone.local(2013, 2) }
  let!(:lab_3) { FactoryBot.create :lab, created_at: Time.zone.local(2013, 3) }

  it 'sort by created_at desc' do
    expect(described_class.by_created).to eq [lab_3, lab_2, lab_1]
  end
end
