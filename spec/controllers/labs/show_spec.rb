# frozen_string_literal: true

RSpec.describe LabsController, '#show' do
  let!(:lab) { FactoryBot.create(:lab) }

  it 'assigns lab represented' do
    get :show, params: { slug: lab.slug }

    record = assigns(:lab)

    expect(record).to       eq lab
    expect(record.class).to eq LabPresenter
  end

  it 'assigns root comments represented ordered by created at desc' do
    comment_1 = FactoryBot.create(:comment, commentable: lab)
    comment_2 = FactoryBot.create(:comment, commentable: lab)

    # ignored: not root comment
    FactoryBot.create(:comment, commentable: lab, parent: comment_2)

    get :show, params: { slug: lab.slug }

    records = assigns(:root_comments)

    expect(records.size).to eq 2

    expect(records[0]).to       eq comment_2
    expect(records[0].class).to eq CommentPresenter

    expect(records[1]).to       eq comment_1
    expect(records[1].class).to eq CommentPresenter
  end

  it 'sets the locale to en-US' do
    I18n.locale = :'pt-BR'

    get :show, params: { slug: lab.slug }

    expect(I18n.locale).to eq :'en-US'
  end
end
