require 'spec_helper'

describe Article do
  it 'has a valid factory' do
    FactoryGirl.build(:article).should be_valid
  end

  it { should belong_to :user }
  it { should has_many(:comments).with_dependent :destroy }

  it { should validate_presence_of :user }
  it { should validate_presence_of :title }

  context :create do
    it 'creates a valid media' do
      expect {
        Article.create! title: 'title', body:  'body'
      }.to_not raise_error
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

    describe :recents do
      let!(:articles) { FactoryGirl.create_list :article, 9 }

      it 'limits the quantity' do
        expect(Article.recents).to eq 10
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
            Time.chain(:now).and_return Time.local(2013, 1, 1, 0, 0, 0)

            @article_now = FactoryGirl.create :article, published_at: Time.now
          end

          it 'is ignored', :focus do
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
end
