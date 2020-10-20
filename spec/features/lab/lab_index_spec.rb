# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Lab, '#index' do
  context 'when logged' do
    let!(:draft) { FactoryBot.create :lab }
    let!(:lab)   { FactoryBot.create :lab_published }
    let!(:user) { FactoryBot.create(:user) }

    before do
      login(user)
      visit labs_path
    end

    it 'access index page' do
      expect(page).to have_current_path '/labs'
    end

    it 'do not display draft record' do
      expect(page).to have_no_content draft.title
    end

    it 'display the labs' do
      expect(page).to have_content lab.title
      expect(page).to have_content lab.slug
    end

    it 'shows the year and month of publication' do
      expect(page).to have_content lab.published_at.strftime('%m/%Y')
    end

    context 'when click on title' do
      before { click_link lab.title }

      it 'redirects to the lab page' do
        expect(page).to have_current_path slug_lab_path(lab.slug), ignore_query: true
      end
    end

    context 'when click on permalink' do
      before { click_link lab.slug }

      it 'redirects to the lab page' do
        expect(page).to have_current_path slug_lab_path(lab.slug), ignore_query: true
      end
    end
  end
end
