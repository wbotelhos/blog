# coding: utf-8
require 'spec_helper'

describe Article do
  it 'has a valid factory' do
    FactoryGirl.build(:article).should be_valid
  end

  let(:title) { 'Some Title' }
  let!(:article) { FactoryGirl.create :article, title: title, body: 'some body' }

  describe '#generate_slug' do
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

  describe 'getting the status' do
    context 'when article is new' do
      before do
        article.created_at = nil
        article.published_at = nil
      end

      it 'return the text "Novo"' do
        article.status.should == 'Novo'
      end
    end

    context 'when it is a draft' do
      before do
        article.created_at = Time.zone.now
        article.published_at = nil
      end

      it 'return the text "Rascunho"' do
        article.status.should == 'Rascunho'
      end
    end

    context 'when it is published' do
      before do
        article.created_at = Time.zone.now
        article.published_at = Time.zone.now
      end

      it 'return the text "Publicado"' do
        article.status.should == 'Publicado'
      end
    end
  end

  describe 'with resuming text' do
    let(:article_more) { FactoryGirl.build :article, title: 'City - São João del-rey', body: "some #{Article::MORE_TAG} body" }

    describe '#text' do
      it "returns :body without #{Article::MORE_TAG} tag" do
        article_more.text.should == 'some body'
      end
    end

    describe '#resume' do
      context "when #{Article::MORE_TAG} is present" do
        it 'resume the text' do
          article_more.resume.should == 'some ...'
        end
      end

      context "when #{Article::MORE_TAG} is missing" do
        it 'not resume the text' do
          article.resume.should == 'some body'
        end
      end
    end
  end

  describe 'building the date uri' do
    subject { article }

    context 'when it is a draft' do
      before { article.published_at = nil }

      its(:day) { should == '00' }
      its(:month) { should == '00' }
      its(:year) { should == '0000' }
    end

    # TODO: fix Time.zone on server. 23/10/1984 became 24/...
    context 'when it is published' do
      before do
        time = mock(Time).as_null_object
        Time.stub(:new).and_return time
        time.stub(:day).and_return 23
        time.stub(:month).and_return 10
        time.stub(:year).and_return 1984
        article.published_at = time
      end

      its(:day) { should eql 23 }
      its(:month) { should eql 10 }
      its(:year) { should eql 1984 }
    end
  end

  describe '#comments_to_mail' do
    before do
      FactoryGirl.create :comment, email: 'email1@email.com', article: article
      FactoryGirl.create :comment, email: 'email2@email.com', article: article
    end

    context 'with duplicated e-mails' do
      before { FactoryGirl.create :comment, email: 'email1@email.com', article: article }

      it 'returns distinct e-mails' do
        article.comments_to_mail.should have(2).comments
      end
    end

    context 'with author comment included' do
      let!(:author_comment) { FactoryGirl.create :comment_with_author, article: article }

      it 'remove his comment' do
        article.comments_to_mail.should_not include author_comment
      end
    end
  end

  describe :scope do
    let!(:category_ruby) { FactoryGirl.create :category, name: 'Ruby' }
    let!(:article_draft) { FactoryGirl.create :article_draft,         category_ids: [category_ruby.id], categories: [category_ruby] }
    let!(:article_published) { FactoryGirl.create :article_published, category_ids: [category_ruby.id], categories: [category_ruby] }

    describe :published do
      subject { described_class.published }

      it 'returns just published' do
        subject.should have(1).item
        subject.should include article_published
      end
    end

    describe :drafts do
      subject { described_class.drafts }

      it 'returns just drafts' do
        subject.should have(2).item
        subject.should include article_draft
      end
    end

    describe :recents do
      subject { described_class.recents }

      before { FactoryGirl.create_list :article, 8 }

      it 'returns just 10' do
        subject.should have(10).item
      end
    end

    describe :by_category do
      let!(:category_java) { FactoryGirl.create :category, name: 'Java' }

      before { FactoryGirl.create :article_published, category_ids: [category_java.id], categories: [category_java] }

      subject { described_class.by_category category_ruby.slug }

      it 'returns published articles of the given category' do
        subject.should have(1).item
        subject.should include article_published
      end
    end
  end
end
