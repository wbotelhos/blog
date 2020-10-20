# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Comment, '#index' do
  context 'with pending comment' do
    let!(:pending) { FactoryBot.create :comment }

    context 'when unlogged' do
      before do
        logout
        visit slug_path pending.commentable.slug
      end

      it 'does not shows pending label' do
        expect(page).not_to have_content 'pendente'
      end
    end

    context 'when unlogged' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        login(user)
        visit slug_path pending.commentable.slug
      end

      it 'shows pending label' do
        expect(page).to have_content 'pendente'
      end
    end
  end
end
