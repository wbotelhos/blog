# coding: utf-8

require 'spec_helper'

describe Article, '#create' do
  before do
    login
    visit new_article_path
  end

  it 'hides the preview button' do
    expect(current_path).to_not have_button 'Preview'
  end

  context 'submit with valid data' do
    before do
      fill_in 'article_title' , with: 'Some Title'
      fill_in 'article_body'  , with: 'Some body'

      click_button 'SALVAR'
    end

    it 'redirects to edit page' do
      expect(current_path).to match %r(/articles/\d+)
    end
  end

  context 'with same title' do
    let!(:article) { FactoryGirl.create :article }

    before do
      fill_in 'article_title', with: article.title

      click_button 'SALVAR'
    end

    it { expect(page).to have_content %(O valor "#{article.title}" para o campo "Título" já está em uso!) }
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$('#article_title').removeAttr('required');"
    end

    context 'blank title' do
      before { click_button 'SALVAR' }

      it 'renders form page again' do
        expect(current_path).to eq articles_path
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end
  end
end
