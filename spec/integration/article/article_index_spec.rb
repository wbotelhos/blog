# coding: utf-8
require 'spec_helper'

describe Article, "#index" do
  let(:user) { FactoryGirl.create :user }

  context "when logged" do
    before { login with: user.email }

    context "without record" do
      before { visit articles_path }

      it "show read more buttons" do
        page.should have_content 'Nenhum artigo publicado!'
      end
    end

    context "with records" do
      let!(:article_draft) { FactoryGirl.create :article_draft }
      let!(:article_published) { FactoryGirl.create :article_published }
      let(:path) { article_path(article_published.year, article_published.month, article_published.day, article_published.slug) }

      before do
        article_published.categories << FactoryGirl.create(:category, name: 'name-2' )
        article_published.save!

        visit articles_path
      end

      it "access index page" do
        current_path.should == '/articles'
      end

      it "do not display draft record" do
        page.should_not have_content article_draft.title
      end

      it "display the draft record" do
        page.should have_content article_published.title
        page.should have_content article_published.resume
        page.should have_content article_published.categories.first.name
      end

      it "show read more buttons" do
        page.should have_link 'Leia mais...', href: path
      end

      it "show tags with commas" do
        page.should have_content article_published.categories.to_a.map(&:name).join ', '
      end

      it "display edit link" do
        page.should have_link 'Editar Artigo', href: "/articles/#{article_published.id}/edit"
      end

      it "display permalink" do
        page.should have_link 'Permalink', href: path
      end

      it "display comments link" do
        page.should have_selector 'li.comments a', href: "#{path}#comments"
        page.should have_selector 'li.comments a span', text: "a"
      end

      it "display published information" do
        page.should have_selector 'li.published a'
      end

      context "without pagination" do
        it "show page indicator" do
          page.should have_selector 'span', text: 'Página 1'
        end

        it "show disabled back page" do
          page.should have_selector 'li.back-page.disabled'
        end

        it "show disabled next page" do
          page.should have_selector 'li.next-page.disabled'
        end
      end

      context "with pagination" do
        before do
          stub_const('Paginaty::LIMIT', 1)
          2.times.each { FactoryGirl.create :article_published }
          visit articles_path
        end

        context "first page" do
          it "show page indicator" do
            page.should have_selector 'span', text: 'Página 1'
          end

          it "show disabled back page" do
            page.should have_selector 'li.back-page.disabled'
          end

          it "show enabled next page" do
            page.should_not have_selector 'li.next-page.disabled'
            page.should have_selector 'li.next-page'
          end
        end

        context "second page" do
          before { click_link 'Mais antigos >' }

          it "show page indicator" do
            page.should have_selector 'span', text: 'Página 2'
          end

          it "show enabled back page" do
            page.should_not have_selector 'li.back-page.disabled'
            page.should have_selector 'li.back-page'
          end

          it "show enabled next page" do
            page.should_not have_selector 'li.next-page.disabled'
            page.should have_selector 'li.next-page'
          end

          context "third page" do
            before { click_link 'Mais antigos >' }

            it "show page indicator" do
              page.should have_selector 'span', text: 'Página 3'
            end

            it "show enabled back page" do
              page.should_not have_selector 'li.back-page.disabled'
              page.should have_selector 'li.back-page'
            end

            it "show disabled next page" do
              page.should have_selector 'li.next-page.disabled'
            end
          end
        end
      end

      context "when click on article title" do
        it "redirects to the article page" do
          click_link article_published.title
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end

      context "when click on permalink" do
        it "redirects to the article page" do
          click_link 'Permalink'
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end

      context "when click on comment link" do
        it "redirects to the article page" do
          find('li.comments a').click
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end
    end
  end

  context "when unlogged" do
    before { visit articles_path }

    it "access index page" do
      current_path.should == '/articles'
    end

    it "hide edit link" do
      page.should_not have_link 'Editar Artigo'
    end
  end
end
