require 'spec_helper'

describe Donator, 'assignment' do
  subject do
    Donator.new(
      name: 'name',
      email: 'mail@mail.com',
      amount: 10.00,
      about: 'about',
      country: 'country',
      message: 'message',
      url: 'http://url.com'
    )
  end

  its(:name) { should == 'name' }
  its(:email) { should == 'mail@mail.com' }
  its(:amount) { should eq 10.00 }
  its(:about) { should == 'about' }
  its(:country) { should == 'country' }
  its(:message) { should == 'message' }
  its(:url) { should == 'http://url.com' }
end
