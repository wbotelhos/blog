# coding: utf-8

require 'rails_helper'

describe Comment, '#update' do
  let!(:article) { FactoryGirl.create :article_published }
  let!(:comment) { FactoryGirl.create :comment, commentable: article }

  before do
    @user = login

    visit slug_path article.slug

    within '.comments' do
      click_link 'Editar'
    end
  end

  it 'redirects to edit page' do
    expect(current_path).to eq "/articles/#{article.id}/comments/#{comment.id}/edit"
  end

  context 'change the values' do
    before do
      fill_in 'comment_body'  , with: 'new body'
      fill_in 'comment_email' , with: 'new-john@example.org'
      fill_in 'comment_name'  , with: 'new name'
      fill_in 'comment_url'   , with: 'http://example.org/new'

      uncheck 'comment_pending'

      click_button 'ATUALIZAR'
    end

    it 'redirects to the article page' do
      expect(current_path).to eq slug_path(article.slug)
    end

    it 'does not displays the author indicator' do
      expect(page).to_not have_content 'autor'
    end

    it 'displays the time' do
      expect(page).to have_content 'menos de um minuto atrás'
    end

    it 'displays the self anchor' do
      expect(page).to have_selector '.anchor'
    end

    it 'displays the edit link' do
      expect(page).to have_link 'Editar'
    end

    it 'displays the answer link' do
      expect(page).to have_link 'Responder'
    end

    it 'displays the commenter name' do
      expect(page).to have_link 'new name', href: 'http://example.org/new'
    end

    it 'hides the pending message' do
      expect(page).to_not have_content 'pendente'
    end
  end
end
