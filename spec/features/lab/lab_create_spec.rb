# coding: utf-8

require 'spec_helper'

describe Lab, '#create' do
  before do
    login
    visit new_lab_path
  end

  it 'hides the preview button' do
    expect(current_path).to_not have_button 'Preview'
  end

  context 'submit with valid data' do
    before do
      fill_in 'lab_body'  , with: 'body'
      fill_in 'lab_slug'  , with: 'slug'
      fill_in 'lab_title' , with: 'title'

      click_button 'SALVAR'
    end

    it 'redirects to edit page' do
      expect(current_path).to match %r(/labs/\d+)
    end
  end

  context 'with same title' do
    let!(:lab) { FactoryGirl.create :lab }

    before do
      fill_in 'lab_title', with: lab.title

      click_button 'SALVAR'
    end

    it { expect(page).to have_content %(O valor "#{lab.title}" para o campo "Título" já esta em uso!) }
  end

  context 'with invalid data', :js do
    context 'blank title' do
      before do
        fill_in 'lab_slug', with: 'slug'

        page.execute_script "$(':input').removeAttr('required');"

        click_button 'SALVAR'
      end

      it 'renders form page again' do
        expect(current_path).to eq labs_path
      end

      it { expect(page).to have_content 'O campo "Título" deve ser preenchido!' }
    end

    context 'blank slug' do
      before do
        fill_in 'lab_title', with: 'title'

        page.execute_script "$(':input').removeAttr('required');"

        click_button 'SALVAR'
      end

      it 'renders form page again' do
        expect(current_path).to eq labs_path
      end

      it { expect(page).to have_content 'O campo "Slug" deve ser preenchido!' }
    end
  end
end
