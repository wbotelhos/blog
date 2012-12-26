# coding: utf-8
require 'spec_helper'

describe User, '#edit' do
  context 'when logged' do
    let(:user) { FactoryGirl.create :user, name: 'name', email: 'email@mail.com', bio: 'bio', url: 'url', github: 'github', linkedin: 'linkedin', twitter: 'twitter', facebook: 'facebook', password: 'password', password_confirmation: 'password' }

    before do
      login with: user.email
      visit users_edit_path user
    end

    context 'page' do
      it { current_path.should == "/users/#{user.id}/edit" }

      it 'display title' do
        find('#title h2').should have_content 'Editar Usuário'
      end
    end

    context 'form' do
      before { visit users_edit_path user }

      it { find('#user_name').value.should == user.name }
      it { find('#user_email').value.should == user.email }
      it { find('#user_bio').value.should == user.bio }
      it { find('#user_url').value.should == user.url }
      it { find('#user_github').value.should == user.github }
      it { find('#user_linkedin').value.should == user.linkedin }
      it { find('#user_twitter').value.should == user.twitter }
      it { find('#user_facebook').value.should == user.facebook }
      it { find('#user_password').value.should be_nil }
      it { find('#user_password_confirmation').value.should be_nil }
    end
  end

  context 'when unlogged' do
    before { visit users_new_path }

    it 'redirects to the login page' do
      current_path.should == login_path
    end

    it 'displays error message' do
      page.should have_content 'Você precisa estar logado!'
    end
  end
end
