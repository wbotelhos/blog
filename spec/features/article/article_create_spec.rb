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

      click_button 'Salvar'
    end

    it 'redirects to edit page' do
      expect(current_path).to match %r(/articles/\d+)
    end
  end

  context 'with invalid data', :js do
    context 'blank title' do
      before do
        page.execute_script "$('#article_title').removeAttr('required');"

        click_button 'Salvar'
      end

      it 'renders form page again' do
        expect(current_path).to eq articles_path
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end
  end
end
