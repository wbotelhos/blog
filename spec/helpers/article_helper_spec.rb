require 'spec_helper'

describe ArticleHelper do
  let(:category_1) { FactoryGirl.create :category, name: 'Banana' }
  let(:category_2) { FactoryGirl.create :category, name: 'Abacaxi' }
  let!(:article) {
    FactoryGirl.build :article_published,
      slug:         'some-slug',
      published_at: Time.local(1984, 10, 23),
      category_ids: [category_2.id, category_1.id]
  }

  describe '#article_slug' do
    context 'without anchor' do
      it 'builds the path without anchor' do
        helper.article_slug(article).should == '/1984/10/23/some-slug'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        helper.article_slug(article, 'anchor').should == '/1984/10/23/some-slug#anchor'
      end
    end
  end

  describe '#article_slug_url' do
    before { @request.host = 'url.com' }

    context 'without anchor' do
      it 'builds the path without anchor' do
        helper.article_slug_url(article).should == 'http://url.com/1984/10/23/some-slug'
      end
    end

    context 'with anchor' do
      it 'builds the path with anchor' do
        helper.article_slug_url(article, 'anchor').should == 'http://url.com/1984/10/23/some-slug#anchor'
      end
    end
  end

  describe '#tags' do
    let(:link_1) { '<a href="/categories/abacaxi" title="Abacaxi">Abacaxi</a>' }
    let(:link_2) { '<a href="/categories/banana" title="Banana">Banana</a>' }

    it 'builds the tags as link separated by comma' do
      helper.tags(article).should == "#{link_1}, #{link_2}"
    end
  end

end
