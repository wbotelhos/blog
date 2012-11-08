# coding: utf-8
require 'spec_helper'

describe Article, "#show" do
  let(:user) { FactoryGirl.create :user }
  let(:article) { FactoryGirl.create :article_published }
  let(:path) { article_path(article.year, article.month, article.day, article.slug) }

  before { visit path }

  context "fields" do
    context "render" do
      it "display name" do
        find_field('comment_name').should be_visible
      end

      it "display e-mail" do
        find_field('comment_email').should be_visible
      end

      it "display URL" do
        find_field('comment_url').should be_visible
      end

      it "display body" do
        find_field('comment_body').should be_visible
      end
    end

    context "labels" do
      it "display on name" do
        find_field('comment_name').value.should == 'Nome *'
      end

      it "display on e-mail" do
        find_field('comment_email').value.should == 'E-mail *'
      end

      it "display on URL" do
        find_field('comment_url').value.should == 'URL'
      end

      it "display on body" do
        find_field('comment_body').value.should == "Seu comentário *\n\n```python\ndef cute:\n  print 'Hello Markdown!'\n```"
      end

      # TODO: Jasmine
      context "on focus" do
        it "display blank on name"
        it "display blank on e-mail"
        it "display blank on URL"
        it "display blank on body"
      end

      # TODO: Jasmine
      context "on blur" do
        it "display label on name"
        it "display label on e-mail"
        it "display label on URL"
        it "display label on body"
      end
    end
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
