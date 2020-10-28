# frozen_string_literal: true

RSpec.describe ApplicationHelper, '#github' do
  it 'builds the url' do
    expect(helper.github).to eq "https://github.com/#{CONFIG['github']}"
  end
end
