require 'spec_helper'

describe Donator do
  it 'has a valid factory' do
    FactoryGirl.build(:donator).should be_valid
  end

  describe ':plan' do
    let(:donator) { FactoryGirl.build :donator, amount: 9 }

    subject { donator }

    context 'when Tiny' do
      before { donator.amount = 10 }
      its(:plan) { should == 'Tiny' }
    end

    context 'when Small' do
      before { donator.amount = 20 }
      its(:plan) { should == 'Small' }
    end

    context 'when Medium' do
      before { donator.amount = 30 }
      its(:plan) { should == 'Medium' }
    end

    context 'when Big' do
      before { donator.amount = 50 }
      its(:plan) { should == 'Big' }
    end

    context 'when Huge' do
      before { donator.amount = 51 }
      its(:plan) { should == 'Huge' }
    end
  end

  describe ':scope' do
    context 'when listing' do
      let!(:donator_1) { FactoryGirl.create :donator, created_at: Date.new(2000, 01, 01) }
      let!(:donator_2) { FactoryGirl.create :donator, created_at: Date.new(2000, 01, 02) }

      it 'sort by desc :create_at' do
        Donator.all.to_a.should == [donator_2, donator_1]
      end
    end
  end
end
