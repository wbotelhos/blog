# frozen_string_literal: true

RSpec.describe LabsController, '#export' do
  context 'when is unlogged' do
    it 'redirect' do
      get :export, params: { id: 0 }

      expect(response).to redirect_to login_path
    end
  end

  context 'when logged' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:lab) { FactoryBot.create(:lab) }
    let!(:extractor) { instance_double('PageExtractorService') }

    before do
      session[:user_id] = user.id

      allow(PageExtractorService).to receive(:new).and_return(extractor)
      allow(extractor).to receive(:process)
    end

    it 'heads ok' do
      get :export, params: { id: lab }

      expect(response.body).to   eq('')
      expect(response.status).to be(200)
    end

    it 'executes the page extractor' do
      allow(PageExtractorService).to receive(:new).and_return(extractor)
      allow(extractor).to receive(:process)

      get :export, params: { id: lab }

      expect(extractor).to have_received(:process)
    end

    it 'sets the locale to en-US' do
      I18n.locale = :'pt-BR'

      get :export, params: { id: lab }

      expect(I18n.locale).to eq :'en-US'
    end
  end
end
