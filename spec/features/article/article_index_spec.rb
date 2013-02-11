# coding: utf-8
require 'spec_helper'

describe Article, '#index' do
  let(:user) { FactoryGirl.create :user }

  context 'when logged' do
    before { login with: user.email }

    context 'without record' do
      before { visit articles_path }

      it 'show no result message' do
        page.should have_content 'Nenhum artigo publicado!'
      end
    end

    context 'with records' do
      let!(:article_draft) { FactoryGirl.create :article_draft }
      let!(:article_published) { FactoryGirl.create :article_published, category_ids: [FactoryGirl.create(:category).id, FactoryGirl.create(:category).id] }
      let(:path) { article_path(article_published.year, article_published.month, article_published.day, article_published.slug) }

      before { visit articles_path }

      it 'access index page' do
        current_path.should == '/articles'
      end

      it 'do not display draft record' do
        page.should have_no_content article_draft.title
      end

      it 'display the published record' do
        page.should have_content article_published.title
        page.should have_content article_published.resume
        page.should have_content article_published.categories.first.name
      end

      it 'show read more buttons' do
        find('.read-more').should have_link 'Leia mais...', href: path
      end

      it 'show tags with commas' do
        page.should have_content article_published.categories.to_a.map(&:name).join ' '
      end

      it 'display edit link' do
        page.should have_link 'Editar', href: "/articles/#{article_published.id}/edit"
      end

      it 'display permalink' do
        page.should have_link 'Permalink', href: path
      end

      it 'display comments link' do
        page.should have_link 'Nenhum comentário até o momento', href: "#{path}#comments"
      end

      context 'comment numbers' do
        context 'with zero comments' do
          it 'show no one text' do
            page.should have_content 'Nenhum comentário até o momento'
          end
        end

        context 'with one comment' do
          before do
            FactoryGirl.create :comment, article: article_published
            visit articles_path
          end

          it 'show the number of comments' do
            page.should have_content '1 comentário'
          end

          context 'with two comment' do
            before do
              FactoryGirl.create :comment, article: article_published
              visit articles_path
            end

            it 'show the number of comments' do
              page.should have_content '2 comentários'
            end
          end
        end
      end

      context ':published_at' do
        it 'format as pt_BR' do
          page.text.should match %r(\d\d\/\d\d\/\d\d às \d\d:\d\d)
        end
      end

      context 'without pagination' do
        it 'show page indicator' do
          find('li.page').should have_content 'Página 1'
        end

        it 'show disabled back page' do
          page.should have_selector 'li.previous-page.disabled'
        end

        it 'show disabled next page' do
          page.should have_selector 'li.next-page.disabled'
        end
      end

      context 'with pagination' do
        before do
          stub_const 'Pager::LIMIT', 1
          2.times.each { FactoryGirl.create :article_published }
          visit articles_path
        end

        context 'first page' do
          it 'show page indicator' do
            find('li.page').should have_content 'Página 1'
          end

          it 'show disabled back page' do
            page.should have_selector 'li.previous-page.disabled'
          end

          it 'show enabled next page' do
            page.should have_no_selector 'li.next-page.disabled'
            page.should have_selector 'li.next-page'
          end
        end

        context 'second page' do
          before { click_link 'Próxima >' }

          it 'show page indicator' do
            find('li.page').should have_content 'Página 2'
          end

          it 'show enabled back page' do
            page.should have_no_selector 'li.previous-page.disabled'
            page.should have_selector 'li.previous-page'
          end

          it 'show enabled next page' do
            page.should have_no_selector 'li.next-page.disabled'
            page.should have_selector 'li.next-page'
          end

          context 'third page' do
            before { click_link 'Próxima >' }

            it 'show page indicator' do
              find('li.page').should have_content 'Página 3'
            end

            it 'show enabled back page' do
              page.should have_no_selector 'li.previous-page.disabled'
              page.should have_selector 'li.previous-page'
            end

            it 'show disabled next page' do
              page.should have_selector 'li.next-page.disabled'
            end
          end
        end
      end

      context 'when click on article title' do
        it 'redirects to the article page' do
          find('h2.title').click_link article_published.title
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end

      context 'when click on permalink' do
        it 'redirects to the article page' do
          click_link 'Permalink'
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end

      context 'when click on comment link' do
        it 'redirects to the article page' do
          find_link('Nenhum comentário até o momento').click
          current_path.should == article_path(article_published.year, article_published.month, article_published.day, article_published.slug)
        end
      end
    end
  end

  context 'when unlogged' do
    before { visit articles_path }

    it 'access index page' do
      current_path.should == '/articles'
    end

    it 'hide edit link' do
      page.should have_no_link 'Editar Artigo'
    end
  end
end
