# coding: utf-8
require 'spec_helper'

describe Category, '#index' do
  context 'when access the #index' do
    before { visit categories_path }

    it 'redirects to root path' do
      current_path.should == root_path
    end
  end
end
