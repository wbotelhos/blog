# coding: utf-8
require 'spec_helper'

describe Article, "#create" do
  let(:user) { FactoryGirl.create :user }

  before do
    login with: user.email
    visit users_new_path
  end

  context "submit with valid data" do
    before do
      fill_in 'user_name', with: 'name'
      fill_in 'user_email', with: 'email2@mail.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Salvar'
    end

    it "redirects to edit page" do
      current_path.should == '/users'
    end

    it "displays success message" do
      page.should have_content 'Usuário criado com sucesso!'
    end
  end

  context "with invalid data" do
    before do
      fill_in 'user_name', with: ''
      click_button 'Salvar'
    end

    it "renders form page again" do
      current_path.should == users_path
    end

    context "blank name" do
      before do
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: 'email2@mail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Salvar'
      end

      it { page.should have_content 'O campo "Nome *" deve ser preenchido!' }
    end

    context "blank e-mail" do
      before do
        fill_in 'user_name', with: 'name'
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Salvar'
      end

      it { page.should have_content 'O campo "E-mail *" deve ser preenchido!' }
    end

    context "invalid e-mail" do
      before do
        fill_in 'user_name', with: 'name'
        fill_in 'user_email', with: 'invalid'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Salvar'
      end

      it { page.should have_content 'O valor "invalid" para o campo "E-mail *" é inválido!' }
    end

    context "password blank" do
      before do
        fill_in 'user_name', with: 'name'
        fill_in 'user_email', with: 'email2@mail.com'
        fill_in 'user_password', with: ''
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Salvar'
      end

      it { page.should have_content 'O campo "Senha *" deve ser preenchido!' }
    end

    context "password_confirmation blank" do
      before do
        fill_in 'user_name', with: 'name'
        fill_in 'user_email', with: 'email2@mail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: ''
        click_button 'Salvar'
      end

      it { page.should have_content 'A confirmação de senha não confere com o digitado no campo "Senha *"!' }
    end

    context "password_confirmation different of the password" do
      before do
        fill_in 'user_name', with: 'name'
        fill_in 'user_email', with: 'email2@mail.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'different'
        click_button 'Salvar'
      end

      it { page.should have_content 'A confirmação de senha não confere com o digitado no campo "Senha *"!' }
    end
  end
end
