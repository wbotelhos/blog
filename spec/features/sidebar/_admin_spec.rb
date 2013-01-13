require 'spec_helper'

describe '_admin', js: true do
  context 'logged' do
    let(:user) { FactoryGirl.create :user }

    before do
      login with: user.email
      visit root_path
    end

    it 'shows admin dashboard link' do
      within 'aside' do
        page.should have_link 'Painel de Controle', href: '/admin'
      end
    end

    it 'shows logout link' do
      within 'aside' do
        page.should have_link 'Sair', href: '/logout'
      end
    end

    it 'hides login link' do
      within 'aside' do
        page.should_not have_link 'Login'
      end
    end
  end

  context 'unlogged' do
    before { visit root_path }

    it 'hides admin dashboard link' do
      within 'aside' do
        page.should_not have_link 'Painel de Controle', href: '/admin'
      end
    end

    it 'hides logout link' do
      within 'aside' do
        page.should_not have_link 'Sair', href: '/logout'
      end
    end

    it 'shows login link' do
      within 'aside' do
        page.should have_link 'Login', href: '/login'
      end
    end
  end
end
