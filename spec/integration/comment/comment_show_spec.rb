# coding: utf-8
require 'spec_helper'

describe Comment, "Article#show" do
  let(:user) { FactoryGirl.create :user }
  let!(:article) { FactoryGirl.create :article_published, user: user }
  let(:path) { article_path(article.year, article.month, article.day, article.slug) }
  let!(:comment) { FactoryGirl.create :comment, article: article }

  before { visit path }

  context "when logged" do
    before do
      login with: user.email
      visit path
    end

    context "edit form" do
      context "on viewing" do
        it "hide fields" do
          within '.content' do
            find_field('comment[name]').should_not be_visible
            find_field('comment[email]').should_not be_visible
            find_field('comment[url]').should_not be_visible
            find_field('comment[body]').should_not be_visible
            find_field("bot-#{comment.id}").should_not be_visible
          end
        end

        it "hide update button" do
          find_button('Atualizar').should_not be_visible
        end

        it "hide close link" do
          find_link('Fechar').should_not be_visible
        end
      end

      context "on edition", js: true do
        before { page.execute_script("$('.text:first').dblclick();") }

        it "display fields" do
          within '.content' do
            find_field('comment[name]').should be_visible
            find_field('comment[email]').should be_visible
            find_field('comment[url]').should be_visible
            find_field('comment[body]').should be_visible
            find_field("bot-#{comment.id}").should be_visible
          end
        end

        it "display update button" do
          find_button('Atualizar').should be_visible
        end

        it "display close link" do
          find_link('Fechar').should be_visible
        end
      end

      context "anti bot", js: true do
        before { page.execute_script("$('.text:first').dblclick();") }

        it 'starts checked' do
          find("#bot-#{comment.id}").should be_checked
        end

        it 'starts with bot log' do
          find(%(label[for="bot-#{comment.id}"])).text.should == 'b0t?'
        end

        context "on uncheck" do
          before { uncheck "bot-#{comment.id}" }

          it 'log human message' do
            find(%(label[for="bot-#{comment.id}"])).text.should == 'human! <3'
          end

          context "on check" do
            before { check "bot-#{comment.id}" }

            it 'log human message' do
              find(%(label[for="bot-#{comment.id}"])).text.should == 'stupid! :/'
            end

            context "and submit" do
              before { click_button 'Atualizar' }

              it 'the form is blocked and log looser message' do
                find(%(label[for="bot-#{comment.id}"])).text.should == 'b0t? l00s3r!'
              end
            end
          end
        end
      end
    end
  end

  context "when unlogged" do
    before { visit path }

    context "on try edition", js: true do
      before { page.execute_script("$('.text:first').dblclick();") }

      it "not show fields" do
        within '.content' do
          find_field('comment[name]').should_not be_visible
          find_field('comment[email]').should_not be_visible
          find_field('comment[url]').should_not be_visible
          find_field('comment[body]').should_not be_visible
          find_field("bot-#{comment.id}").should_not be_visible
        end
      end

      it "not show update button" do
        find_button('Atualizar').should_not be_visible
      end

      it "not show close link" do
        find_link('Fechar').should_not be_visible
      end
    end
  end
end
