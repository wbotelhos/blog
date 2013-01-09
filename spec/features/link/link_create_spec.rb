# coding: utf-8
require 'spec_helper'

describe Link, '#create' do
  let(:user) { FactoryGirl.create :user }

  before do
    login with: user.email
    visit links_new_path
  end

  context 'submit with valid data' do
    before do
      fill_in 'link_name', with: 'name'
      fill_in 'link_url', with: 'http://url.com'
      click_button 'Salvar'
    end

    it 'redirects to root page' do
      current_path.should == '/'
    end

    it 'displays success message' do
      page.should have_content 'Link criado com sucesso!'
    end
  end

  context 'with invalid data' do
    context 'blank name' do
      before do
        fill_in 'link_name', with: ''
        fill_in 'link_url', with: 'http://url.com'
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == links_path
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context 'blank url' do
      before do
        fill_in 'link_name', with: 'name'
        fill_in 'link_url', with: ''
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == links_path
      end

      it { page.should have_content 'O campo "URL *" deve ser preenchido!' }
    end

    context 'Name already taken' do
      let!(:link) { FactoryGirl.create :link }

      before do
        fill_in 'link_name', with: link.name
        fill_in 'link_url', with: 'http://new-url.com'
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == links_path
      end

      it { page.should have_content %(O valor "#{link.name}" para o campo "Nome *" já esta em uso!) }
    end

    context 'URL already taken' do
      let!(:link) { FactoryGirl.create :link }

      before do
        fill_in 'link_name', with: 'new-name'
        fill_in 'link_url', with: link.url
        click_button 'Salvar'
      end

      it 'renders form page again' do
        current_path.should == links_path
      end

      it { page.should have_content %(O valor "#{link.url}" para o campo "URL *" já esta em uso!) }
    end
  end
end
