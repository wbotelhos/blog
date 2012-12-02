# coding: utf-8
require 'spec_helper'

describe Article, "#show" do
  let(:user) { FactoryGirl.create :user, bio: 'this is my bio' }
  let(:article) { FactoryGirl.create :article_published, user: user }
  let(:path) { article_path(article.year, article.month, article.day, article.slug) }

  before { visit path }

  it "redirects to show page" do
    current_path.should == path
  end

  it "display the draft record" do
    page.should have_content article.title
    page.should have_content article.text
  end

  it "show tags with commas" do
    page.should have_content article.categories.to_a.map(&:name).join ', '
  end

  it "not display edit link" do
    page.should have_no_link 'Editar Artigo'
  end

  it "display permalink" do
    page.should have_link 'Permalink', href: path
  end

  it "display comments link" do
    page.should have_link 'Nenhum comentário, seja o primeiro! (:', href: "#{path}#comments"
  end

  context "author" do
    it "bio" do
      page.should have_content article.user.bio
    end
  end

  context "comment numbers" do
    context "with zero comments" do
      it "show no one text" do
        find('li.comments a span').should have_content 'Nenhum comentário, seja o primeiro! (:'
      end
    end

    context "with one comment" do
      before do
        FactoryGirl.create :comment, article: article
        visit articles_path
      end

      it "show the number of comments" do
        find('li.comments a span').should have_content '1 comentário'
      end

      context "with two comment" do
        before do
          FactoryGirl.create :comment, article: article
          visit articles_path
        end

        it "show the number of comments" do
          find('li.comments a span').should have_content '2 comentários'
        end
      end
    end
  end

  context "when logged" do
    before do
      login with: user.email
      visit path
    end

    it "display edit link" do
      page.should have_link 'Editar Artigo', href: "/articles/#{article.id}/edit"
    end
  end
end
