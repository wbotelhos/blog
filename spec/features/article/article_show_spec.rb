# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Article, '#show' do
  let(:article) { FactoryBot.create :article, :published }

  before { visit slug_path article.slug }

  it 'shows the title' do
    within 'header' do
      expect(page).to have_link article.title
    end
  end

  it 'shows published date' do
    within 'header' do
      expect(page).to have_content "#{article.published_at.day} de Outubro de #{article.published_at.year}"
    end
  end

  it 'shows twitter button' do
    expect(page).to have_selector '.share .twitter'
  end

  it 'changes the title' do
    expect(page).to have_title article.title
  end

  context 'clicking on title' do
    before { click_link article.title }

    it 'sends to the same page' do
      expect(page).to have_current_path "/#{article.slug}", ignore_query: true
    end
  end

  it 'redirects to show page' do
    expect(page).to have_current_path "/#{article.slug}", ignore_query: true
  end

  it 'does not display edit link' do
    within 'header' do
      expect(page).not_to have_link 'Editar'
    end
  end

  context 'trying to access an inexistent record' do
    before { visit slug_path 'invalid' }

    it 'redirects to root page' do
      expect(page).to have_current_path root_path, ignore_query: true
    end

    it 'display not found message' do
      expect(page).to have_content 'O artigo "invalid" não foi encontrado!'
    end
  end

  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      login(user)
      visit slug_path article.slug
    end

    it 'displays edit link' do
      within 'header' do
        expect(page).to have_link 'Editar', href: edit_article_path(article)
      end
    end
  end
end
