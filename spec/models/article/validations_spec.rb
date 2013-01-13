require 'spec_helper'

describe Article, 'validations' do
  it { should_not allow(nil).for :title }
  it { should_not allow([]).for :categories }
  it { should_not allow(nil).for :user }

  it { should allow('title').for :title }
  it { should allow('body').for :body }
  it { should allow([FactoryGirl.build(:category)]).for :categories }
  it { should allow('1984-10-23 11:30:00').for :published_at }
  it { should allow('slug', nil).for :slug }

  context 'uniqueness fields' do
    let(:article) { FactoryGirl.create :article }

    it { should_not allow(article.title).for :title }
  end
end
