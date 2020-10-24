# frozen_string_literal: true

RSpec.describe LabsController, '#show' do
  let!(:lab) { FactoryBot.create(:lab) }

  it 'assigns lab represented' do
    get :show, params: { slug: lab.slug }

    record = assigns(:lab)

    expect(record).to       eq lab
    expect(record.class).to eq LabPresenter
  end
end
