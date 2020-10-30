# frozen_string_literal: true

RSpec.describe Lab, '.home_selected' do
  let!(:lab) { FactoryBot.create :lab }
  let(:result) { described_class.home_selected.first }

  it 'brings only the fields used on home' do
    expect(result).to     have_attribute :published_at
    expect(result).to     have_attribute :slug
    expect(result).to     have_attribute :title
    expect(result).not_to have_attribute :body
    expect(result).not_to have_attribute :created_at
    expect(result).not_to have_attribute :css_import
    expect(result).not_to have_attribute :js
    expect(result).not_to have_attribute :js_import
    expect(result).not_to have_attribute :js_ready
    expect(result).not_to have_attribute :updated_at
    expect(result).not_to have_attribute :user_id
    expect(result).not_to have_attribute :version
    expect(result.id).to  be_nil
  end
end
