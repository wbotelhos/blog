# frozen_string_literal: true

require 'support/capybara_box'
require 'support/includes/login'

RSpec.describe Lab, '#create' do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    visit new_lab_path
  end

  it 'hides the preview button' do
    expect(current_path).not_to have_button 'Preview'
  end

  context 'submit with valid data' do
    before do
      fill_in 'lab_analytics', with: 'UA-123-4'
      fill_in 'lab_body', with: 'body'
      fill_in 'lab_description', with: 'description'
      fill_in 'lab_keywords', with: 'key,words'
      fill_in 'lab_slug', with: 'slug'
      fill_in 'lab_title', with: 'title'
      fill_in 'lab_version', with: '1.0.0'

      click_button 'Salvar'
    end

    it 'redirects to edit page' do
      expect(page).to have_current_path %r(/labs/\d+)
    end
  end

  context 'with same title' do
    let!(:lab) { FactoryBot.create :lab }

    before do
      fill_in 'lab_title', with: lab.title

      click_button 'Salvar'
    end

    it { expect(page).to have_content %(O valor "#{lab.title}" para o campo "Título" já está em uso!) }
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
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Salvar'
      end

      it 'renders form page again' do
        expect(page).to have_current_path labs_path
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end

    context 'blank slug' do
      before do
        fill_in 'lab_analytics', with: 'UA-123-4'
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Salvar'
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

        click_button 'Salvar'
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

        click_button 'Salvar'
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

        click_button 'Salvar'
      end

      it { expect(page).to have_content 'O campo "Descrição" deve ser preenchido!' }
    end

    context 'blank analytics' do
      before do
        fill_in 'lab_analytics', with: ''
        fill_in 'lab_description', with: 'description'
        fill_in 'lab_keywords', with: 'key,words'
        fill_in 'lab_slug', with: 'slug'
        fill_in 'lab_title', with: 'title'
        fill_in 'lab_version', with: '1.0.0'

        click_button 'Salvar'
      end

      it { expect(page).to have_content 'O campo "Analytics" deve ser preenchido!' }
    end
  end
end
