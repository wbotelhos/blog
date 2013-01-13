require 'spec_helper'

describe Category, 'validations' do
  it { should_not allow(nil).for :name }

  it { should allow('name').for :name }
  it { should allow('slug', nil).for :slug }

  context 'uniqueness fields' do
    let(:category) { FactoryGirl.create :category }

    it { should_not allow(category.name).for :name }
  end
end
