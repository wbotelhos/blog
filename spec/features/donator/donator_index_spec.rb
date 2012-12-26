# coding: utf-8
require 'spec_helper'

describe Donator, '#index' do
  let(:user) { FactoryGirl.create :user }

  context 'with records' do
    let!(:donator) { FactoryGirl.create :donator, url: 'http://url.com', amount: 1, country: 'country', message: 'message' }

    before { visit donators_path }

    it 'display the created record' do
      within '#donations' do
        find('.name').should have_link donator.name, href: donator.url
        find('.country').should have_content 'country'
        find('.amount').should have_content '$1'
        find('.message').should have_content 'message'
      end
    end

    context 'when logged' do
      before do
        login with: user.email
        visit donators_path
      end

      it 'show edit link' do
        find('.edit').should have_link '', href: donators_edit_path(donator)
      end

      context 'following edit link' do
        before { find('.edit').click_link '' }

        it { current_path.should == "/donators/#{donator.id}/edit" }
      end
    end

    context 'when unlogged' do
      it 'hide edit link' do
        page.should have_no_selector '.edit'
      end
    end

    context 'page' do
      before do
        visit root_path
        find('header nav ul').click_link 'Donators'
      end

      it { current_path.should == '/donators' }

      it 'show title' do
        page.should have_content 'Thank you, folks!'
      end
    end
  end

  context 'without record' do
    before { visit donators_path }

    it { current_path.should == '/donators' }

    it 'show no result message' do
      page.should have_content 'Nenhum doador cadastrado!'
    end
  end
end
