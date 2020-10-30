# frozen_string_literal: true

RSpec.describe FeedsController, '#show' do
  render_views

  it 'assigns maximum of 10 published article represented ordered by published_at' do
    article_1  = FactoryBot.create(:article, published_at: Time.zone.local(1991))
    article_2  = FactoryBot.create(:article, published_at: Time.zone.local(1992))
    article_3  = FactoryBot.create(:article, published_at: Time.zone.local(1993))
    article_4  = FactoryBot.create(:article, published_at: Time.zone.local(1994))
    article_5  = FactoryBot.create(:article, published_at: Time.zone.local(1995))
    article_6  = FactoryBot.create(:article, published_at: Time.zone.local(1996))
    article_7  = FactoryBot.create(:article, published_at: Time.zone.local(1997))
    article_8  = FactoryBot.create(:article, published_at: Time.zone.local(1998))
    article_9  = FactoryBot.create(:article, published_at: Time.zone.local(1999))
    article_10 = FactoryBot.create(:article, published_at: Time.zone.local(2000))

    # ignored: no between 10 more recents
    FactoryBot.create(:article, published_at: Time.zone.local(1990))

    get :index

    records = assigns(:articles)

    expect(records.size).to eq 10

    expect(records[0]).to       eq article_10
    expect(records[0].class).to eq ArticlePresenter

    expect(records[1]).to       eq article_9
    expect(records[1].class).to eq ArticlePresenter

    expect(records[2]).to       eq article_8
    expect(records[2].class).to eq ArticlePresenter

    expect(records[3]).to       eq article_7
    expect(records[3].class).to eq ArticlePresenter

    expect(records[4]).to       eq article_6
    expect(records[4].class).to eq ArticlePresenter

    expect(records[5]).to       eq article_5
    expect(records[5].class).to eq ArticlePresenter

    expect(records[6]).to       eq article_4
    expect(records[6].class).to eq ArticlePresenter

    expect(records[7]).to       eq article_3
    expect(records[7].class).to eq ArticlePresenter

    expect(records[8]).to       eq article_2
    expect(records[8].class).to eq ArticlePresenter

    expect(records[9]).to       eq article_1
    expect(records[9].class).to eq ArticlePresenter
  end

  it 'renders rss with markdown and syntax highlight' do
    body = <<~HEREDOC
      # Code

      `hello`
    HEREDOC

    FactoryBot.create(:article,
      body:         body,
      published_at: Time.zone.local(1991),
      title:        'The Title',
      user:         FactoryBot.create(:user, name: 'User')
    )

    get :index

    expect(response.body).to eq <<~HEREDOC
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
        <channel>
          <title>Washington Botelho</title>
          <description>Artigos sobre Ruby, Rails, Java, VRaptor, Python, jQuery, JavaScript, CSS e muito mais.</description>
          <language>pt-BR</language>
          <link>https://www.wbotelhos.com</link>
          <item>
            <title>The Title</title>
            <pubDate>Tue, 01 Jan 1991 00:00:00 -0200</pubDate>
            <link>http://test.host/the-title</link>
            <guid isPermalink="true">http://test.host/the-title</guid>
            <creator>User</creator>
            <description>
              <![CDATA[<h1>Code</h1>

      <p><code>hello</code></p>
      ]]>
            </description>
          </item>
        </channel>
      </rss>
    HEREDOC
  end
end
