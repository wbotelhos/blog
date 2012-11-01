# coding: utf-8
require 'spec_helper'

describe Article, "#show" do
  let(:user) { FactoryGirl.create :user }
  let(:article) { FactoryGirl.create :article_published }
  let(:path) { article_path(article.year, article.month, article.day, article.slug) }

  before { visit path }

  it "display name field" do
    find_field('comment_name').should be_visible
  end

  it "display e-mail field" do
    find_field('comment_email').should be_visible
  end

  it "display URL field" do
    find_field('comment_url').should be_visible
  end

  it "display body field" do
    find_field('comment_body').should be_visible
  end

  context "comment numbers" do
    context "with zero comments" do
      it "show no one text" do
        find('.comments').text.should == 'Nenhum comentário, seja o primeiro! (:'
      end
    end

    context "with one comment" do
      let!(:comment_1) { FactoryGirl.create :comment, article: article }

      before { visit path }

      it "show the number of comments" do
        find('.comments').text.should == '1 comentário'
      end

      it "show the number" do
        page.should have_link "##{comment_1.id}"
      end

      it "show name" do
        page.should have_link comment_1.name
      end

      it "show the time" do
        find('.name-date span').text.should == 'menos de um minuto atrás'
      end

      it "show body" do
        find('.comment .text').text.gsub("\n", '').should == comment_1.body
      end

      it "show bottom comment counter" do
        find('h3#comments').text.strip.gsub("\n", '').squeeze(' ').should == '1 comentário #'
      end

      context "with one comment and one response" do
        let!(:comment_2) { FactoryGirl.create :comment, article: article, comment_id: comment_1.id }

        before { visit path }

        it "show the number of comments" do
          find('.comments').text.should == '2 comentários'
        end

        it "show response link" do
          find('.anchors div').text.strip.squeeze(' ').should == "Resposta ao comentário ##{comment_1.id}"
        end

        it "formats first level" do
          page.should have_selector '.comment.level-1'
        end

        context "with two response and one author response" do
          let!(:comment_3) { FactoryGirl.create :comment_with_author, article: article, comment_id: comment_2.id }

          before { visit path }

          it "formats second level authored" do
            page.should have_selector '.comment.authored.level-2'
          end
        end
      end
    end
  end

  context "when logged" do
    before do
      login with: user.email
      visit path
    end

    it { page.should_not have_field 'comment_name' }
    it { page.should_not have_field 'comment_email' }
    it { page.should_not have_field 'comment_url' }
    it { page.should have_field 'comment_body' }
  end
end
