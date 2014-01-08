require 'spec_helper'

describe Comment, '#index' do
  context 'with pending comment' do
    let!(:pending) { FactoryGirl.create :comment }

    context 'when unlogged' do
      before do
        logout
        visit slug_path pending.commentable.slug
      end

      it 'does not shows pending label' do
        expect(page).to_not have_content 'pendente'
      end
    end

    context 'when unlogged' do
      before do
        login
        visit slug_path pending.commentable.slug
      end

      it 'shows pending label' do
        expect(page).to have_content 'pendente'
      end
    end
  end
end
