require 'spec_helper'

describe Lab, '#index' do
  context 'when logged' do
    let!(:draft) { FactoryGirl.create :lab }
    let!(:lab)   { FactoryGirl.create :lab_published }

    before do
      login
      visit labs_path
    end

    it 'access index page' do
      expect(current_path).to eq '/labs'
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
        expect(current_path).to eq slug_path(lab.slug)
      end
    end

    context 'when click on permalink' do
      before { click_link lab.slug }

      it 'redirects to the lab page' do
        expect(current_path).to eq slug_path(lab.slug)
      end
    end
  end
end
