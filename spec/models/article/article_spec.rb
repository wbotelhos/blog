# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Article do
  it 'has a valid factory' do
    expect(FactoryBot.build(:article)).to be_valid
  end

  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :title }

  it { expect(FactoryBot.build(:article)).to validate_uniqueness_of(:title).case_insensitive }

  describe '#generate_slug' do
    let!(:article) { FactoryBot.create :article, title: 'Some Title' }

    context 'on save' do
      it 'slug the title' do
        expect(article.slug).to eq 'some-title'
      end
    end

    context 'on update' do
      before { article.update!(title: 'New Title') }

      it 'slug the title' do
        expect(article.slug).to eq 'new-title'
      end
    end
  end

  describe :scope do
    let!(:article_1) do
      FactoryBot.create :article, created_at: Time.zone.local(2000, 1, 1), published_at: Time.zone.local(2001, 1, 2)
    end

    let!(:article_2) do
      FactoryBot.create :article, created_at: Time.zone.local(2000, 1, 2), published_at: Time.zone.local(2001, 1, 1)
    end

    describe :home_selected do
      let!(:article) { FactoryBot.create :article }
      let(:result)   { Article.home_selected.first }

      it 'brings only the fields used on home' do
        expect(result).to     have_attribute :published_at
        expect(result).to     have_attribute :slug
        expect(result).to     have_attribute :title
        expect(result).to     have_attribute :id
        expect(result).not_to have_attribute :body
        expect(result).not_to have_attribute :created_at
        expect(result).not_to have_attribute :updated_at
        expect(result).not_to have_attribute :user_id
      end
    end

    describe :by_month do
      let!(:article_1) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o1, 0o1) }
      let!(:article_2) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o1, 0o1) }
      let!(:article_3) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o2, 0o1) }
      let!(:article_4) { FactoryBot.create :article, published_at: Time.zone.local(2013, 0o3, 0o1) }
      let(:result)     { Article.by_month }

      xit 'groups the articles by published month'
    end

    describe :recents do
      let!(:articles) { FactoryBot.create_list :article, 9 }

      it 'limits the quantity' do
        expect(Article.recents.size).to eq 10
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
      let!(:article_draft) { FactoryBot.create :article }

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
            allow(Time).to receive(:now).and_return Time.zone.local(2013, 1, 1, 0, 0, 0)

            @article_now = FactoryBot.create :article, published_at: Time.current
          end

          it 'is ignored' do
            expect(Article.published).to include @article_now
          end
        end

        context 'article without published date' do
          it 'is ignored' do
            expect(Article.published).not_to include article_draft
          end
        end

        context 'article with published date but in the future (scheduled)' do
          let!(:article_scheduled) { FactoryBot.create :article, published_at: Time.zone.local(2500, 1, 1) }

          it 'is ignored' do
            expect(Article.published).not_to include article_scheduled
          end
        end
      end
    end
  end

  describe :published? do
    context 'when unpublished' do
      it 'returns false' do
        expect(Article.new).not_to be_published
      end
    end

    context 'when published' do
      it 'returns true' do
        expect(Article.new(published_at: Time.current)).to be_published
      end
    end
  end

  describe :state do
    let!(:article) { FactoryBot.create :article }

    it 'begins unpublished' do
      expect(article.published_at).to be_nil
    end

    context 'when publish' do
      before { article.publish! }

      it 'becames published' do
        expect(article.published_at).not_to be_nil
      end
    end
  end
end
