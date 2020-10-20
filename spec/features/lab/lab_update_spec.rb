# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Lab, '#update' do
  let(:lab) { FactoryBot.create :lab }
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    visit edit_lab_path lab.id
  end

  it 'shows the preview link' do
    expect(page).to have_link 'PREVIEW', href: slug_lab_path(lab.slug)
  end

  context 'with valid data' do
    before do
      fill_in 'lab_analytics', with: 'UA-432-1'
      fill_in 'lab_body', with: 'Some body'
      fill_in 'lab_css', with: 'Some CSS'
      fill_in 'lab_css_import', with: 'Some CSS import'
      fill_in 'lab_description', with: 'Some description'
      fill_in 'lab_js', with: 'Some JS'
      fill_in 'lab_js_import', with: 'Some JS import'
      fill_in 'lab_js_ready', with: 'Some JS ready'
      fill_in 'lab_keywords', with: 'key,words'
      fill_in 'lab_slug', with: 'Some slug'
      fill_in 'lab_title', with: 'Some title'
      fill_in 'lab_version', with: '2.0.0'

      click_button 'Atualizar'
    end

    it 'redirects to edit page' do
      expect(page).to have_current_path "/labs/#{lab.id}/edit", ignore_query: true
    end

    it { expect(find_field('lab_analytics').value).to   eq 'UA-432-1' }
    it { expect(find_field('lab_body').value).to        eq 'Some body' }
    it { expect(find_field('lab_css').value).to         eq 'Some CSS' }
    it { expect(find_field('lab_css_import').value).to  eq 'Some CSS import' }
    it { expect(find_field('lab_description').value).to eq 'Some description' }
    it { expect(find_field('lab_js').value).to          eq 'Some JS' }
    it { expect(find_field('lab_js_import').value).to   eq 'Some JS import' }
    it { expect(find_field('lab_js_ready').value).to    eq 'Some JS ready' }
    it { expect(find_field('lab_keywords').value).to    eq 'key,words' }
    it { expect(find_field('lab_slug').value).to        eq 'Some slug' }
    it { expect(find_field('lab_title').value).to       eq 'Some title' }
    it { expect(find_field('lab_version').value).to     eq '2.0.0' }
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$(':input').removeAttr('required');"
    end

    context 'blank title' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: ''
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Atualizar'
      end

      it 'renders form page again' do
        expect(page).to have_current_path lab_path lab, ignore_query: true
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end

    context 'blank slug' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: ''
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "Slug" deve ser preenchido!' }
    end

    context 'blank version' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: ''

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "Versão" deve ser preenchido!' }
    end

    context 'blank keywords' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: ''
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "Palavras-chave" deve ser preenchido!' }
    end

    context 'blank description' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: ''
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "Descrição" deve ser preenchido!' }
    end

    context 'blank lab_analytics' do
      before do
        fill_in 'lab_analytics', with: ''
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Atualizar'
      end

      it { expect(page).to have_content 'O campo "Analytics" deve ser preenchido!' }
    end
  end
end
