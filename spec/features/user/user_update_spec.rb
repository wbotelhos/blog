# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe User, '#update' do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    visit profile_path
  end

  it { expect(page).to have_current_path '/profile' }

  it { expect(find('#user_email').value).to                 eq user.email }
  it { expect(find('#user_password').value).to              be_nil }
  it { expect(find('#user_password_confirmation').value).to be_nil }

  context 'with valid data' do
    context 'filling all fields' do
      before do
        fill_in 'user_email', with: 'botelho@example.org'
        fill_in 'user_password', with: 'some-password'
        fill_in 'user_password_confirmation', with: 'some-password'

        click_button 'Atualizar'
      end

      it 'redirects to edit page' do
        expect(page).to have_current_path profile_path, ignore_query: true
      end

      it { expect(find_field('user_email').value).to                 eq 'botelho@example.org' }
      it { expect(find_field('user_password').value).to              be_blank }
      it { expect(find_field('user_password_confirmation').value).to be_blank }
    end

    context 'filling only email' do
      let!(:new_user)     { FactoryBot.build :user, email: 'washington@example.org' }
      let!(:old_password) { user.password }

      before do
        fill_in 'user_email', with: new_user.email
        fill_in 'user_password', with: nil
        fill_in 'user_password_confirmation', with: nil

        click_button 'Atualizar'
      end

      it 'redirects to edit page' do
        expect(page).to have_current_path profile_path, ignore_query: true
      end

      it { expect(find_field('user_email').value).to eq 'washington@example.org' }

      it { expect(page).not_to have_content 'O campo "Password" deve ser preenchido!' }

      context 'coming back to login page' do
        before do
          visit logout_path
          visit login_path
        end

        context 'and try to login with old password', :js do
          it 'keeps the unchanged password' do
            fill_in 'email', with: new_user.email
            fill_in 'password', with: old_password

            uncheck 'not_human'

            click_button 'Acessar'

            expect(page).not_to have_content I18n.t('session.denied')
          end
        end
      end
    end
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$('.edit_user :visible:input').removeAttr('required');"
    end

    context 'blank email' do
      before do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: 'some-password'
        fill_in 'user_password_confirmation', with: 'some-password'

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "E-mail" deve ser preenchido!' }
      it { expect(page).not_to have_content 'O campo "Password" deve ser preenchido!' }
    end

    context 'filling password with blank confirmation' do
      before do
        fill_in 'user_email', with: 'botelho@example.org'
        fill_in 'user_password', with: 'some-password'
        fill_in 'user_password_confirmation', with: ''

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'A confirmação de senha não confere com o digitado no campo "Senha"!' }
    end
  end
end
