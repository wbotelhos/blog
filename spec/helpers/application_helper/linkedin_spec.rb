# frozen_string_literal: true

RSpec.describe ApplicationHelper, '#linkedin' do
  it 'builds the url' do
    expect(helper.linkedin).to eq "https://www.linkedin.com/in/#{CONFIG['linkedin']}"
  end
end
