# coding: utf-8

require 'spec_helper'

describe Article, '#update' do
  let(:article) { FactoryGirl.create :article }

  before do
    login
    visit edit_article_path article
  end

  it 'shows the preview link' do
    expect(page).to have_link 'PREVIEW', href: slug_path(article.slug)
  end

  context 'with valid data' do
    before do
      fill_in 'article_title' , with: 'Some Title'
      fill_in 'article_body'  , with: 'Some body'

      click_button 'ATUALIZAR'
    end

    it 'redirects to edit page' do
      expect(current_path).to eq "/articles/#{article.id}/edit"
    end

    it { expect(find_field('article_title').value).to eq 'Some Title' }
    it { expect(find_field('article_body').value).to  eq 'Some body' }
  end

  context 'with invalid data', :js do
    context 'blank title' do
      before do
        page.execute_script "$('#article_title').removeAttr('required');"

        fill_in 'article_title', with: ''

        click_button 'ATUALIZAR'
      end

      it 'renders form page again' do
        expect(current_path).to eq article_path article
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end
  end

  context 'when unpublished' do
    it 'shows the publish button' do
      expect(page).to have_button 'PUBLICAR'
    end

    context 'and click on publish button' do
      before do
        visit edit_article_path article

        click_button 'PUBLICAR'
      end

      it 'renders index page' do
        expect(current_path).to eq root_path
      end

      it 'shows the actual article on published list' do
        expect(page).to have_content article.title
      end
    end
  end

  context 'when published' do
    before do
      article.publish!

      visit edit_article_path article
    end

    it 'hides the publish button' do
      expect(page).to_not have_button 'PUBLICAR'
    end
  end
end
