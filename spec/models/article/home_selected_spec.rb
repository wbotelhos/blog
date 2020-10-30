# frozen_string_literal: true

RSpec.describe Article, '.home_selected' do
  it 'brings only the fields used on home' do
    FactoryBot.create(:article)

    result = described_class.home_selected.first

    expect(result).to     have_attribute(:published_at)
    expect(result).to     have_attribute(:slug)
    expect(result).to     have_attribute(:title)
    expect(result).to     have_attribute(:id)
    expect(result).not_to have_attribute(:body)
    expect(result).not_to have_attribute(:created_at)
    expect(result).not_to have_attribute(:updated_at)
    expect(result).not_to have_attribute(:user_id)
  end
end
