require 'spec_helper'

describe Donator, 'validations' do
  it { should_not allow(nil).for :name }
  it { should_not allow('invalid', nil).for :email }
  it { should_not allow(nil).for :amount }

  it { should allow('name').for :name }
  it { should allow('email@email.com').for :email }
  it { should allow(1.00).for :amount }
  it { should allow('about').for :about }
  it { should allow('country').for :country }
  it { should allow('message').for :message }

  context 'e-mail none uniqueness' do
    let(:donator) {
      Donator.create!(
        name: 'name',
        email: 'email@email.com',
        amount: 1.00
      )
    }

    it { should allow(donator.email).for :email }
  end
end
