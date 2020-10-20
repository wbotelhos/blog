# frozen_string_literal: true

require 'support/capybara_box'

RSpec.describe :header do
  before { visit root_path }

  it 'shows the logo' do
    expect(page).to have_link CONFIG['author']
  end

  context 'clicking on logo' do
    before { click_link CONFIG['author'] }

    it 'goes to root page' do
      expect(page).to have_current_path root_path, ignore_query: true
    end
  end

  it 'shows the quote' do
    expect(page).to have_content CONFIG['quote']
  end
end
