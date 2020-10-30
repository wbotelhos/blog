# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab, '.url' do
  let(:lab) { FactoryBot.build :lab }

  it 'return the online url of the url' do
    expect(lab.url).to eq "#{CONFIG['url_https']}/#{lab.slug}"
  end
end
