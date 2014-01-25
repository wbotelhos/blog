require 'spec_helper'

describe Article do
  it 'has a valid factory' do
    expect(FactoryGirl.build :article).to be_valid
  end

  it { should belong_to :user }

  it { should validate_presence_of :user }
  it { should validate_presence_of :title }

  context :create do
    let(:user) { FactoryGirl.create :user }

    it 'creates a valid media' do
      article      = Article.new title: 'title', body: 'body'
      article.user = user

      expect(article).to be_valid
    end
  end

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
        expect(article.slug).to eq 'some-title'
      end
    end

    context 'on update' do
      before do
        article.title = 'New Title'
        article.save
      end

      it 'slug the title' do
        expect(article.slug).to eq 'new-title'
      end
    end
  end

  describe :scope do
    let!(:article_1) { FactoryGirl.create :article, created_at: Time.local(2000, 1, 1), published_at: Time.local(2001, 1, 2) }
    let!(:article_2) { FactoryGirl.create :article, created_at: Time.local(2000, 1, 2), published_at: Time.local(2001, 1, 1) }

    describe :home_selected do
      let!(:article) { FactoryGirl.create :article }
      let(:result)   { Article.home_selected.first }

      it 'brings only the fields used on home' do
        expect(result).to     have_attribute :published_at
        expect(result).to     have_attribute :slug
        expect(result).to     have_attribute :title
        expect(result).to     have_attribute :id
        expect(result).to_not have_attribute :body
        expect(result).to_not have_attribute :created_at
        expect(result).to_not have_attribute :updated_at
        expect(result).to_not have_attribute :user_id
      end
    end

    describe :by_month do
      let!(:article_1) { FactoryGirl.create :article, published_at: Time.local(2013, 01, 01) }
      let!(:article_2) { FactoryGirl.create :article, published_at: Time.local(2013, 01, 01) }
      let!(:article_3) { FactoryGirl.create :article, published_at: Time.local(2013, 02, 01) }
      let!(:article_4) { FactoryGirl.create :article, published_at: Time.local(2013, 03, 01) }
      let(:result)     { Article.by_month }

      xit 'groups the articles by published month'
    end

    describe :recents do
      let!(:articles) { FactoryGirl.create_list :article, 9 }

      it 'limits the quantity' do
        expect(Article.recents).to have(10).items
      end
    end

    context :sort do
      describe :by_created do
        it 'sort by created_at desc' do
          expect(Article.by_created).to eq [article_2, article_1]
        end
      end

      describe :by_published do
        it 'sort by published_at desc' do
          expect(Article.by_published).to eq [article_1, article_2]
        end
      end
    end

    context :state do
      let!(:article_draft) { FactoryGirl.create :article }

      describe :drafts do
        it 'returns drafts' do
          expect(Article.drafts).to eq [article_draft]
        end
      end

      describe :published do
        context 'article without published date on the past' do
          it 'is ignored' do
            expect(Article.published).to include article_1, article_2
          end
        end

        context 'article without published date in the same time' do
          before do
            Time.stub(:now).and_return Time.local(2013, 1, 1, 0, 0, 0)

            @article_now = FactoryGirl.create :article, published_at: Time.now
          end

          it 'is ignored' do
            expect(Article.published).to include @article_now
          end
        end

        context 'article without published date' do
          it 'is ignored' do
            expect(Article.published).to_not include article_draft
          end
        end

        context 'article with published date but in the future (scheduled)' do
          let!(:article_scheduled) { FactoryGirl.create :article, published_at: Time.local(2500, 1, 1) }

          it 'is ignored' do
            expect(Article.published).to_not include article_scheduled
          end
        end
      end
    end
  end

  describe :published? do
    context 'when unpublished' do
      it 'returns false' do
        expect(Article.new).to_not be_published
      end
    end

    context 'when published' do
      it 'returns true' do
        expect(Article.new published_at: Time.now).to be_published
      end
    end
  end

  describe :state do
    let!(:article) { FactoryGirl.create :article }

    it 'begins unpublished' do
      expect(article.published_at).to be_nil
    end

    context 'when publish' do
      before { article.publish! }

      it 'becames published' do
        expect(article.published_at).to_not be_nil
      end
    end
  end
end
