# coding: utf-8
require 'spec_helper'

describe Lab, '#update' do
  let(:user) { FactoryGirl.create :user }
  let(:lab) { FactoryGirl.create :lab_published }

  before do
    login with: user.email
    visit labs_edit_path lab
  end

  context 'with valid data' do
    before do
      fill_in 'lab_name', with: 'name-new'
      fill_in 'lab_slug', with: 'slug-new'
      fill_in 'lab_description', with: 'description-new'
      fill_in 'lab_image', with: 'image-new.jpg'
      click_button 'Atualizar'
    end

    it 'redirects to index page' do
      current_path.should == '/labs'
    end

    it 'displays success message' do
      page.should have_content 'Projeto atualizado com sucesso!'
    end

    it { find('.name').should have_link 'name-new', href: 'http://wbotelhos.com/slug-new' }
    it { find('.description').text.should == 'description-new' }
    it { find('.image').should have_link '', href: 'http://wbotelhos.com/slug-new' }
  end

  context 'with invalid data' do
    context 'blank name' do
      before do
        fill_in 'lab_name', with: ''
        click_button 'Atualizar'
      end

      it 'renders form page again' do
        current_path.should == "/labs/#{lab.id}"
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context 'blank slug' do
      before do
        fill_in 'lab_slug', with: ''
        click_button 'Atualizar'
      end

      it 'renders form page again' do
        current_path.should == "/labs/#{lab.id}"
      end

      it { page.should have_content 'O campo "Slug *" deve ser preenchido!' }
    end

    context 'name already taken' do
      let(:lab_persited) { FactoryGirl.create :lab_published }

      before do
        fill_in 'lab_name', with: lab_persited.name
        click_button 'Atualizar'
      end

      it 'renders form page again' do
        current_path.should == "/labs/#{lab.id}"
      end

      it { page.should have_content %(O valor "#{lab_persited.name}" para o campo "Nome *" já esta em uso!) }
    end
  end
end
