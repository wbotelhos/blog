# frozen_string_literal: true

RSpec.describe ApplicationHelper, '#twitter' do
  it 'builds the url' do
    expect(helper.twitter).to eq "https://twitter.com/#{CONFIG['twitter']}"
  end
end
