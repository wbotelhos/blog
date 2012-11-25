require 'spec_helper'

describe Category, "validations" do
  it { should_not allow(nil).for :name }

  it { should allow('name').for :name }

  context 'uniqueness fields' do
    let(:category) { Category.create name: 'name' }

    it { should_not allow(category.name).for :name }
  end
end
