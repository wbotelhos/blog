# coding: utf-8
require 'spec_helper'

describe 'About' do
  let!(:user) { FactoryGirl.create :user, bio: 'A cool guy!' }

  context 'profile display' do
    before { visit about_path }

    it 'redirects to the about page' do
      current_path.should == about_path
    end

     it 'shows the bio fo the author bio' do
       page.should have_content 'A cool guy!'
     end
  end
end
