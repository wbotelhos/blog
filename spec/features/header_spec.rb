require 'rails_helper'

describe :header do
  before { visit root_path }

  it 'shows the logo' do
    expect(page).to have_link CONFIG['author']
  end

  context 'clicking on logo' do
    before { click_link CONFIG['author'] }

    it 'goes to root page' do
      expect(current_path).to eq root_path
    end
  end

  it 'shows the quote' do
    expect(page).to have_content CONFIG['quote']
  end
end
