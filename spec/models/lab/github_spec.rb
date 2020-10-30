# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab, '.github' do
  let(:lab) { FactoryBot.build :lab }

  it 'return the online url of the github' do
    expect(lab.github).to eq "https://github.com/#{CONFIG['github']}/#{lab.slug}"
  end
end
