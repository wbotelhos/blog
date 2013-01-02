require 'spec_helper'

describe SocialHelper do
  let(:article) { FactoryGirl.build :article_published }
  let(:url) { article_url article.year, article.month, article.day, article.slug }

  context 'sharing via Twitter Button' do
    it 'mount a twitt with article title, article link and via sender' do
      helper.twitter_button(text: article.title, url: url).should == %(<div id="twitter"><a href="https://twitter.com/intent/tweet?text=%22#{CGI.escape article.title}%22&amp;url=#{CGI.escape url}&amp;via=wbotelhos" target="_blank">Tweet</a></div>)
    end
  end
end
