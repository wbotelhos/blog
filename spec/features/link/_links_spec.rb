require 'spec_helper'

describe Link, '_links' do
  context 'with link' do
    let!(:link) { FactoryGirl.create :link }

    before { visit root_path }

    it 'shows the section title' do
      within 'aside' do
        page.should have_content 'Links'
      end
    end

    it 'shows the link' do
      within 'aside' do
        page.should have_link link.name, href: link.url
      end
    end
  end

  context 'without link' do
    before { visit root_path }

    it 'hides the section name' do
      within 'aside' do
        page.should_not have_content 'Links'
      end
    end
  end
end
