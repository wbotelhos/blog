# coding: utf-8

require 'rails_helper'

describe 'Admin', '#index' do
  context 'when logged' do
    before { login }

    context 'article' do
      let!(:draft)     { FactoryGirl.create :article, published_at: nil }
      let!(:published) { FactoryGirl.create :article_published }

      before { visit admin_path }

      it 'access index page' do
        expect(current_path).to eq '/admin'
      end

      it 'do not display published record' do
        expect(page).to have_no_content published.title
      end

      it 'display the drafts' do
        expect(page).to have_content draft.title
        expect(page).to have_content draft.slug
      end

      it 'shows the drafts title' do
        expect(page).to have_content 'Rascunhos'
      end

      context 'when click on title' do
        before { click_link draft.title }

        it 'redirects to edit page' do
          expect(current_path).to eq edit_article_path(draft.id)
        end
      end

      context 'when click on permalink' do
        before { click_link draft.slug }

        it 'redirects to the draft page' do
          expect(current_path).to eq slug_path(draft.slug)
        end
      end
    end

    context 'comment' do
      let!(:pending)  { FactoryGirl.create :comment }
      let!(:answered) { FactoryGirl.create :comment_answered }

      before { visit admin_path }

      it 'access index page' do
        expect(current_path).to eq '/admin'
      end

      it 'do not display answered record' do
        expect(page).to have_no_content answered.email
      end

      it 'display pendings' do
        expect(page).to have_content pending.email
        expect(page).to have_content "#{pending.commentable.slug}#comment-#{pending.id}"
      end

      it 'shows the drafts title' do
        expect(page).to have_content 'Comentários'
      end

      context 'when click on email' do
        before { click_link pending.email }

        it 'redirects to edit page' do
          expect(current_path).to eq "/articles/#{pending.commentable.id}/comments/#{pending.id}/edit"
        end
      end

      context 'when click on permalink' do
        before { click_link slug_url(pending.commentable.slug, anchor: "comment-#{pending.id}") }

        it 'redirects to the article page' do
          expect(current_path).to eq "/#{pending.commentable.slug}"
        end
      end
    end
  end
end
