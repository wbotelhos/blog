# coding: utf-8

require 'spec_helper'

describe User, '#update' do
  before do
    @user = login
    visit profile_path
  end

  it { expect(current_path).to eq '/profile' }

  it { expect(find('#user_email').value).to                 eq @user.email }
  it { expect(find('#user_name').value).to                  eq @user.name }
  it { expect(find('#user_password').value).to              be_nil }
  it { expect(find('#user_password_confirmation').value).to be_nil }

  context 'with valid data' do
    context 'filling all fields' do
      before do
        fill_in 'user_email'                 , with: 'botelho@example.org'
        fill_in 'user_name'                  , with: 'Washington Botelho'
        fill_in 'user_password'              , with: 'some-password'
        fill_in 'user_password_confirmation' , with: 'some-password'

        click_button 'ATUALIZAR'
      end

      it 'redirects to edit page' do
        expect(current_path).to eq profile_path
      end

      it { expect(find_field('user_email').value).to                 eq 'botelho@example.org' }
      it { expect(find_field('user_name').value).to                  eq 'Washington Botelho' }
      it { expect(find_field('user_password').value).to              be_blank }
      it { expect(find_field('user_password_confirmation').value).to be_blank }
    end

    context 'filling only name and email' do
      before do
        fill_in 'user_email'                 , with: 'washington@example.org'
        fill_in 'user_name'                  , with: 'Botelho'
        fill_in 'user_password'              , with: ''
        fill_in 'user_password_confirmation' , with: ''

        click_button 'ATUALIZAR'
      end

      it 'redirects to edit page' do
        expect(current_path).to eq profile_path
      end

      it { expect(find_field('user_email').value).to eq 'washington@example.org' }
      it { expect(find_field('user_name').value).to  eq 'Botelho' }

      it { expect(page).to_not have_content 'O campo "Password" deve ser preenchido!' }
    end
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$('.edit_user :visible:input').removeAttr('required');"
    end

    context 'blank name' do
      before do
        fill_in 'user_email'                 , with: 'botelho@example.org'
        fill_in 'user_name'                  , with: ''
        fill_in 'user_password'              , with: 'some-password'
        fill_in 'user_password_confirmation' , with: 'some-password'

        click_button 'ATUALIZAR'
      end

      it 'renders form page again' do
        expect(current_path).to eq "/users/#{@user.id}"
      end

      it { expect(page).to have_content 'O campo "Nome" deve ser preenchido!' }
      it { expect(page).to_not have_content 'O campo "Password" deve ser preenchido!' }
    end

    context 'blank email' do
      before do
        fill_in 'user_email'                 , with: ''
        fill_in 'user_name'                  , with: 'Washington Botelho'
        fill_in 'user_password'              , with: 'some-password'
        fill_in 'user_password_confirmation' , with: 'some-password'

        click_button 'ATUALIZAR'
      end

      it { expect(page).to have_content 'O campo "E-mail" deve ser preenchido!' }
      it { expect(page).to_not have_content 'O campo "Password" deve ser preenchido!' }
    end

    context 'filling password with blank confirmation' do
      before do
        fill_in 'user_email'                 , with: 'botelho@example.org'
        fill_in 'user_name'                  , with: 'Washington Botelho'
        fill_in 'user_password'              , with: 'some-password'
        fill_in 'user_password_confirmation' , with: ''

        click_button 'ATUALIZAR'
      end

      it { expect(page).to have_content 'A confirmação de senha não confere com o digitado no campo "Senha"!' }
    end
  end
end
