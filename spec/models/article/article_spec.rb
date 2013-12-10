require 'spec_helper'

describe Article do
  it 'has a valid factory' do
    FactoryGirl.build(:article).should be_valid
  end

  it { should validate_presence_of :user }
  it { should validate_presence_of :title }

  context :uniqueness do
    let(:article) { FactoryGirl.create :article }

    it 'does not allow the same title'  do
      expect(FactoryGirl.build(:article, title: article.title)).to be_invalid
    end
  end

  describe '#generate_slug' do
    let!(:article) { FactoryGirl.create :article, title: 'Some Title' }

    context 'on save' do
      it 'slug the title' do
        article.slug.should == 'some-title'
      end
    end

    context 'on update' do
      before do
        article.title = 'New Title'
        article.save
      end

      it 'slug the title' do
        article.slug.should == 'new-title'
      end
    end
  end

  describe :scope do
    let!(:article_1) { FactoryGirl.create :article, created_at: Time.local(2000, 1, 1), published_at: Time.local(2001, 1, 2) }
    let!(:article_2) { FactoryGirl.create :article, created_at: Time.local(2000, 1, 2), published_at: Time.local(2001, 1, 1) }

    describe :by_created, :focus do
      it 'sort by created_at desc' do
        expect(Article.by_created).to eq [article_2, article_1]
      end
    end

    describe :by_published do
      it 'sort by published_at desc' do
        expect(Article.by_published).to eq [article_1, article_2]
      end
    end

    let!(:article_draft) { FactoryGirl.create :article }

    describe :drafts do
      it 'returns drafts' do
        expect(Article.drafts).to eq [article_draft]
      end
    end

    describe :published do
      subject { described_class.published }

      xit 'returns just published' do
        subject.should have(1).item
        subject.should include article
      end
    end



    describe :recents do
      subject { described_class.recents }

      before { FactoryGirl.create_list :article, 8 }

      xit 'returns just 10' do
        subject.should have(10).item
      end
    end
  end
end
