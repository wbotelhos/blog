# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe :menu do
  before { visit root_path }

  it 'shows bio' do
    expect(page).to have_link CONFIG['bio']
  end

  it 'shows email icon' do
    expect(page).to have_link '', href: "mailto:#{CONFIG['email']}"
  end

  it 'shows linkedin icon' do
    expect(page).to have_link '', href: "http://linkedin.com/in/#{CONFIG['linkedin']}"
  end

  it 'shows github icon' do
    expect(page).to have_link '', href: "http://github.com/#{CONFIG['github']}"
  end

  it 'shows twitter icon' do
    expect(page).to have_link '', href: "http://twitter.com/#{CONFIG['twitter']}"
  end

  it 'shows labs icon' do
    expect(page).to have_link '', href: labs_path
  end

  context 'donate icon' do
    it 'shows donate icon' do
      expect(page).to have_css '.i-heart'
    end

    it 'hides donate options' do
      expect(page).to have_link 'Patreon', href: 'https://www.patreon.com/wbotelhos/creators', visible: false
      expect(page).to have_link 'Paypal', visible: false
    end

    context 'clicking on donate icon' do
      before { find('.i-heart').click }

      it 'shows donate options' do
        expect(page).to have_link 'Patreon', href: 'https://www.patreon.com/wbotelhos/creators', visible: true
        expect(page).to have_link 'Paypal', visible: true
      end

      context 'clicking again' do
        before { find('.i-heart').click }

        it 'hides donate options' do
          expect(page).to have_link 'Patreon', href: 'https://www.patreon.com/wbotelhos/creators', visible: false
          expect(page).to have_link 'Paypal', visible: false
        end
      end
    end
  end

  it 'hides profile menu icon' do
    expect(page).not_to have_link '', href: profile_path
  end

  it 'hides admin menu icon' do
    expect(page).not_to have_link '', href: admin_path
  end

  it 'hides new article menu icon' do
    expect(page).not_to have_link '', href: new_article_path
  end

  it 'hides logout menu icon' do
    expect(page).not_to have_link '', href: logout_path
  end

  it 'hides new lab menu icon' do
    expect(page).not_to have_link '', href: new_lab_path
  end

  context 'clicking on feed icon' do
    before { find('.i-feed').click }

    it 'goes to feed page' do
      expect(page).to have_current_path feed_path, ignore_query: true
    end
  end

  it 'shows quote' do
    expect(page).to have_content CONFIG['quote']
  end

  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login(user)
      visit root_path
    end

    it 'shows profile menu icon' do
      expect(page).to have_link '', href: profile_path
    end

    it 'shows admin menu icon' do
      expect(page).to have_link '', href: admin_path
    end

    it 'shows new article menu icon' do
      expect(page).to have_link '', href: new_article_path
    end

    it 'shows logout menu icon' do
      expect(page).to have_link '', href: logout_path
    end

    it 'shows new lab menu icon' do
      expect(page).to have_link '', href: new_lab_path
    end
  end
end
