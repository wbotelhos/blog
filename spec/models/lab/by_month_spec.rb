# frozen_string_literal: true

RSpec.describe Lab, '.by_month' do
  let!(:lab_1) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o1, 0o1) }
  let!(:lab_2) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o1, 0o1) }
  let!(:lab_3) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o2, 0o1) }
  let!(:lab_4) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o3, 0o1) }
  let(:result) { described_class.by_month }
end
