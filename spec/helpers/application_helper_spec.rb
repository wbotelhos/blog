require 'spec_helper'

describe ApplicationHelper do
  context 'without section and content_for' do
    it 'returns just the author name' do
      helper.title.should == 'Washington Botelho'
    end
  end

  context 'with manual section' do
    it 'returns the author name with the manual name' do
      helper.title('manual-title').should == 'Washington Botelho | manual-title'
    end
  end

  context 'with content_for' do
    before do
      view.stub(:content_for).with(:title).and_return 'content-title'
    end

    xit 'returns it dynamic value' do
      helper.title.should == 'Washington Botelho | content-title'
    end
  end
end
