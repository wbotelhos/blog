# coding: utf-8

require 'spec_helper'

describe Comment, '#update' do
  let!(:article) { FactoryGirl.create :article_published }
  let!(:comment) { FactoryGirl.create :comment, commentable: article }

  before do
    @user = login

    visit slug_path article.slug

    within "#comment-#{comment.id}" do
      click_link 'Editar'
    end
  end

  it 'redirects to edit page' do
    expect(current_path).to eq "/articles/#{article.id}/comments/#{comment.id}/edit"
  end

  context 'change the values' do
    let(:new_comment) { FactoryGirl.create :comment }

    before do
      fill_in 'comment_body'  , with: new_comment.body
      fill_in 'comment_email' , with: new_comment.email
      fill_in 'comment_name'  , with: new_comment.name
      fill_in 'comment_url'   , with: new_comment.url

      click_button 'ATUALIZAR'
    end

    it 'redirects to the article page' do
      expect(current_path).to eq slug_path(article.slug)
    end

    it 'does not displays the author indicator' do
      within "#comment-#{comment.id}" do
        expect(page).to_not have_content 'autor'
      end
    end

    it 'displays the time' do
      within "#comment-#{comment.id}" do
        expect(page).to have_content 'menos de um minuto atrás'
      end
    end

    it 'displays the self anchor' do
      within "#comment-#{comment.id}" do
        expect(page).to have_selector '.anchor'
      end
    end

    it 'displays the edit link' do
      within "#comment-#{comment.id}" do
        expect(page).to have_link 'Editar'
      end
    end

    it 'displays the answer link' do
      within "#comment-#{comment.id}" do
        expect(page).to have_link 'Responder'
      end
    end

    it 'displays the commenter name' do
      within "#comment-#{comment.id}" do
        expect(page).to have_link new_comment.name, href: new_comment.url
      end
    end
  end
end
