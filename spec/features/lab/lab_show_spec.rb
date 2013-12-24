# coding: utf-8

require 'spec_helper'

describe Lab, '#show' do
  let(:lab) { FactoryGirl.create :lab_published }

  before { visit slug_path lab.slug }

  it 'shows the title' do
    within 'header' do
      expect(page).to have_link lab.title
    end
  end

  it 'shows published date' do
    within 'header' do
      expect(page).to have_content "#{lab.published_at.day} de Outubro de #{lab.published_at.year}"
    end
  end

  it 'shows twitter button' do
    expect(page).to have_link 'Tweet'
  end

  context 'clicking on title' do
    before { click_link lab.title }

    it 'sends to the same page' do
      expect(current_path).to eq "/#{lab.slug}"
    end
  end

  it 'redirects to show page' do
    expect(current_path).to eq "/#{lab.slug}"
  end

  it 'does not display edit link' do
    within 'header' do
      expect(page).to_not have_link 'Editar'
    end
  end

  context 'trying to access an inexistent record' do
    before { visit slug_path 'invalid' }

    it 'redirects to root page' do
      expect(current_path).to eq root_path
    end

    it 'display not found message' do
      expect(page).to have_content 'O artigo "invalid" não foi encontrado!'
    end
  end

  context 'when logged' do
    before do
      login
      visit slug_path lab.slug
    end

    it 'does not display edit link' do
      within 'header' do
        expect(page).to have_link 'Editar'
      end
    end
  end
end
