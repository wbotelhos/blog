# coding: utf-8
require 'spec_helper'

describe Link, '#edit' do
  let!(:link) { FactoryGirl.create :link, name: 'yLab', url: 'http://wbotelhos.com/labs' }

  context "visiting the root page" do
    before { visit root_path }

    it "show edit link on link line" do
      page.should have_link 'Edit', href: links_edit_path(link.id)
    end
  end

  context 'when logged' do
    let(:user) { FactoryGirl.create :user }

    before { login with: user.email }

    context 'page' do
      before { visit links_edit_path link }

      it { current_path.should == "/links/#{link.id}/edit" }

      it 'display title' do
        find('#title h2').should have_content 'Editar Link'
      end
    end

    context 'form' do
      before { visit links_edit_path link }

      it { find('#link_name').value.should == link.name }
      it { find('#link_url').value.should == link.url }
      it { page.should have_button 'Atualizar' }
    end
  end

  context 'when unlogged' do
    before { visit links_edit_path link.id }

    it 'redirects to the login page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      within '#container-login' do
        page.should have_content 'Você precisa estar logado!'
      end
    end
  end
end
