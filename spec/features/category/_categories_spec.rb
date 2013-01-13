require 'spec_helper'

describe Category, '_categories' do
  context 'with category' do
    let!(:category) { FactoryGirl.create :category }

    before { visit root_path }

    it 'shows the section title' do
      within 'aside' do
        page.should have_content 'Categorias'
      end
    end

    it 'shows the category' do
      within 'aside' do
        page.should have_link category.name, href: "/categories/#{category.name.slug}"
      end
    end
  end

  context 'without category' do
    before { visit root_path }

    it 'hides the section name' do
      within 'aside' do
        page.should_not have_content 'Categorias'
      end
    end
  end
end
