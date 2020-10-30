# frozen_string_literal: true

RSpec.describe Article, '.recents' do
  it 'limits the quantity to 10' do
    FactoryBot.create_list(:article, 11)

    expect(described_class.recents.size).to eq 10
  end
end
