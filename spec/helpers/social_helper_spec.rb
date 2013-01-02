require 'spec_helper'

describe SocialHelper do
  let(:article) { FactoryGirl.build :article_published }
  let(:url) { article_url article.year, article.month, article.day, article.slug }

  context 'without content_for' do
    it 'returns the default configuration' do
      helper.twitter_button(text: article.title, url: url).should == %(<div id="twitter"><a href="https://twitter.com/intent/tweet?text=%22title+1%22&amp;url=http%3A%2F%2Ftest.host%2F1984%2F10%2F23%2Ftitle-1&amp;via=wbotelhos" target="_blank">Tweet</a></div>)
    end
  end

  context 'with content_for' do
    before do
      view.stub(:content_for).with(:twitter).and_return 'content-twitter'
    end

    xit 'returns it dynamic value' do
      helper.twitter_button.should == %(<iframe allowtransparency="true" frameborder="0" height="20" scrolling="no" src="https://platform.twitter.com/widgets/tweet_button.html?text=content-twitter&amp;via=wbotelhos" width="90"></iframe>)
    end
  end
end
