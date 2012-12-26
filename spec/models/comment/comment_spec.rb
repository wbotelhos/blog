require 'spec_helper'

describe Comment do
  it 'has a valid factory' do
    FactoryGirl.build(:comment).should be_valid
  end
end
