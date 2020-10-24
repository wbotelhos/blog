# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Article, '#create' do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    visit new_article_path
  end

  it 'hides the preview button' do
    expect(current_path).not_to have_button 'Preview'
  end

  context 'submit with valid data', :js do
    it 'redirects to edit page' do
      fill_in 'article_title', with: 'Some Title'
      fill_in 'article_body', with: 'Some body'

      click_button 'Salvar'

      expect(page).to have_current_path %r(/articles/\d+)
    end
  end

  context 'with same title' do
    let!(:article) { FactoryBot.create :article }

    it 'shows error' do
      fill_in 'article_title', with: article.title

      click_button 'Salvar'

      expect(page).to have_content %(O valor "#{article.title}" para o campo "Título" já está em uso!)
    end
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$('#article_title').removeAttr('required');"
    end

    context 'blank title' do
      it 'renders form page again' do
        click_button 'Salvar'

        expect(page).to have_current_path articles_path
      end

      it 'shows error' do
        click_button 'Salvar'

        expect(page).to have_content 'O campo "Título" deve ser preenchido!'
      end
    end
  end
end
