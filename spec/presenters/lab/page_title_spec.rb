# frozen_string_literal: true

RSpec.describe LabPresenter, '#page_title' do
  let!(:lab) { FactoryBot.create(:lab, description: 'description', title: 'title') }

  it 'builds a page title' do
    expect(described_class.new(lab).page_title).to eq('title | description')
  end
end
