require 'spec_helper'

describe Comment, 'validations' do
  it { should_not allow(nil).for :name }
  it { should_not allow(nil).for :email }
  it { should_not allow(nil).for :body }
  it { should_not allow(nil).for :article }

  it { should allow('name').for :name }
  it { should allow('mail@mail.com').for :email }
  it { should allow('http://url.com').for :url }
  it { should allow('body').for :body }
  it { should allow(Article.new).for :article }
end
