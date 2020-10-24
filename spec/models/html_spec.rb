# frozen_string_literal: true

RSpec.describe Html do
  it 'includes redcarpet module' do
    expect(described_class.included_modules).to include(Rouge::Plugins::Redcarpet)
  end
end
