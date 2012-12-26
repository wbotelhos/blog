require 'spec_helper'

describe Link, 'validations' do
  it { should_not allow(nil).for :name }
  it { should_not allow(nil).for :url }

  it { should allow('name').for :name }
  it { should allow('http://url.com').for :url }
end
