# coding: utf-8

require 'spec_helper'

describe Lab, '#update' do
  let(:lab) { FactoryGirl.create :lab }

  before do
    login
    visit edit_lab_path lab
  end

  it 'shows the preview link' do
    expect(page).to have_link 'PREVIEW', href: slug_path(lab.slug)
  end

  context 'with valid data' do
    before do
      fill_in 'lab_body'        , with: 'Some body'
      fill_in 'lab_description' , with: 'Some description'
      fill_in 'lab_title'       , with: 'Some Title'
      fill_in 'lab_version'     , with: '1.0.0'

      click_button 'ATUALIZAR'
    end

    it 'redirects to edit page' do
      expect(current_path).to eq "/labs/#{lab.id}/edit"
    end

    it { expect(find_field('lab_title').value).to       eq 'Some Title' }
    it { expect(find_field('lab_body').value).to        eq 'Some body' }
    it { expect(find_field('lab_description').value).to eq 'Some description' }
  end

  context 'with invalid data', :js do
    before do
      page.execute_script "$(':input').removeAttr('required');"
    end

    context 'blank title' do
      before do
        fill_in 'lab_slug'    , with: 'slug'
        fill_in 'lab_title'   , with: ''
        fill_in 'lab_version' , with: '1.0.0'

        click_button 'ATUALIZAR'
      end

      it 'renders form page again' do
        expect(current_path).to eq lab_path lab
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end

    context 'blank slug' do
      before do
        fill_in 'lab_slug'    , with: ''
        fill_in 'lab_title'   , with: 'title'
        fill_in 'lab_version' , with: '1.0.0'

        click_button 'ATUALIZAR'
      end

      it { expect(page).to have_content 'O campo "Slug" deve ser preenchido!' }
    end

    context 'blank version' do
      before do
        fill_in 'lab_slug'    , with: 'slug'
        fill_in 'lab_title'   , with: 'title'
        fill_in 'lab_version' , with: ''

        click_button 'ATUALIZAR'
      end

      it { expect(page).to have_content 'O campo "Versão" deve ser preenchido!' }
    end
  end
end
