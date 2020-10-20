# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Lab, '#show' do
  let(:lab) { FactoryBot.create :lab_published }

  before { visit slug_lab_path lab.slug }

  it 'redirects to show page' do
    expect(page).to have_current_path "/#{lab.slug}", ignore_query: true
  end

  it 'does not display edit link' do
    expect(page).not_to have_link 'Edit'
  end

  it 'changes the title' do
    expect(page).to have_title "#{lab.title} | #{lab.description}"
  end

  describe 'header' do
    it 'shows title' do
      within '.header' do
        expect(page).to have_link lab.title, href: slug_lab_path(lab.slug)
      end
    end

    it 'shows description' do
      within '.header' do
        expect(page).to have_content lab.description
      end
    end
  end

  describe 'navigation' do
    it 'shows download button' do
      within 'nav' do
        expect(page).to have_link "v#{lab.version}", href: "http://github.com/#{CONFIG['github']}/#{lab.slug}/archive/#{lab.version}.zip"
      end
    end

    it 'show github button' do
      within 'nav' do
        expect(page).to have_link '', href: "http://github.com/#{CONFIG['github']}/#{lab.slug}"
      end
    end

    it 'show labs button' do
      within 'nav' do
        expect(page).to have_link '', href: labs_url
      end
    end

    context 'donate icon' do
      it 'shows donate icon' do
        expect(page).to have_css '.i-heart'
      end

      it 'hides donate options' do
        expect(page).to have_link 'Patreon', visible: false
        expect(page).to have_link 'Paypal', visible: false
      end

      context 'clicking on donate icon' do
        before { find('.i-heart').click }

        it 'shows donate options' do
          expect(page).to have_link 'Patreon', visible: true
          expect(page).to have_link 'Paypal', visible: true
        end

        context 'clicking again' do
          before { find('.i-heart').click }

          it 'hides donate options' do
            expect(page).to have_link 'Patreon', visible: false
            expect(page).to have_link 'Paypal', visible: false
          end
        end
      end
    end
  end

  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }

    it 'displays edit link', :js do
      login(user)

      visit slug_lab_path lab.slug

      within '.header__subtitle' do
        expect(page).to have_link 'Edit', href: edit_lab_path(lab)
      end
    end
  end
end
