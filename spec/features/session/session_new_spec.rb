# frozen_string_literal: true

RSpec.describe User, 'session#new', :js do
  let(:user) { FactoryBot.create :user }

  before { visit login_path }

  context 'with wrong password' do
    before do
      fill_in 'email', with: 'john@example.org'
      fill_in 'password', with: 'wrong'

      uncheck 'not_human'

      click_button 'ACESSAR'
    end

    it 'redirects to the same page' do
      expect(page).to have_current_path login_path, ignore_query: true
    end

    it 'displays error message' do
      expect(page).to have_content 'E-mail ou senha inválida!'
    end
  end

  context 'with right password' do
    before do
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password

      uncheck 'not_human'

      click_button 'ACESSAR'
    end

    it 'redirects to admin page' do
      expect(page).to have_current_path admin_path, ignore_query: true
    end
  end

  describe '#AntiBOT' do
    it 'starts checked' do
      expect(page).to have_checked_field 'not_human'
    end

    it 'starts with bot log' do
      expect(page).to have_content 'BOT!'
    end

    context 'on uncheck' do
      before { uncheck 'not_human' }

      it 'logs human message' do
        expect(page).to have_content 'Humanos! <3'
      end

      context 'on check' do
        before { check 'not_human' }

        it 'log human message' do
          expect(page).to have_content 'Sério?'
        end

        context 'and submit' do
          before { click_button 'ACESSAR' }

          it 'blocks and shows exclamation message' do
            expect(page).to have_content 'Hey! Me desmarque.'
          end
        end
      end
    end
  end

  context 'when logged' do
    before { login }

    context 'and visit login page' do
      before { visit login_path }

      it 'redirects to index page' do
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end
end
