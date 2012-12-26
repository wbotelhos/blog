# coding: utf-8
require 'spec_helper'

describe Pager do
  let!(:article_1) { FactoryGirl.create :article_published }
  let!(:article_2) { FactoryGirl.create :article_published }
  let(:options) { { collection: Article.published, fullpath: '/?dirty&page=1', params: { page: 2 } } }

  describe 'LIMIT constant' do
    it 'has 10 as default limit' do
      Pager::LIMIT.should == 10
    end
  end

  describe '#page' do
    context 'when is nil' do
      it 'returns 1' do
        options[:params][:page] = nil
        Pager.new(options).page.should == 1
      end
    end

    context 'when is empty' do
      it 'returns 1' do
        options[:params][:page] = ''
        Pager.new(options).page.should == 1
      end
    end

    context 'when is letter' do
      it 'returns 1' do
        options[:params][:page] = 'x'
        Pager.new(options).page.should == 1
      end
    end

    context 'when is negative number' do
      it 'returns 1' do
        options[:params][:page] = -1
        Pager.new(options).page.should == 1
      end
    end

    context 'when is zero' do
      it 'returns 1' do
        options[:params][:page] = 0
        Pager.new(options).page.should == 1
      end
    end

    context 'when has a positive number' do
      it 'returns this value' do
        options[:params][:page] = 3
        Pager.new(options).page.should == 3
      end
    end
  end

  describe '#offset' do
    context 'and LIMIT is 10' do
      before { options[:limit] = 10 }

      context 'when #page is 1' do
        it 'returns 0' do
          options[:params][:page] = 1
          Pager.new(options).offset.should == 0
        end
      end

      context 'when #page is 2' do
        it 'returns 10' do
          options[:params][:page] = 2
          Pager.new(options).offset.should == 10
        end
      end

      context 'when #page is 4' do
        it 'returns 10' do
          options[:params][:page] = 4
          Pager.new(options).offset.should == 30
        end
      end
    end
  end

  describe '#has_back?' do
    context 'on first page' do
      it 'has no back page' do
        options[:params][:page] = 1
        Pager.new(options).has_back?.should be_false
      end
    end

    context 'on second page' do
      it 'has back page' do
        options[:params][:page] = 2
        Pager.new(options).has_back?.should be_true
      end
    end
  end

  describe '#paginate' do
    before { options[:limit] = 1 }

    context 'on first page' do
      it 'returns the first record and the second as has_next' do
        options[:params][:page] = 1
        Pager.new(options).paginate.should have(2).items
      end
    end

    context 'on second page' do
      it 'returns the second record and has not the third as has_next' do
        options[:params][:page] = 2
        Pager.new(options).paginate.should have(1).items
      end
    end
  end

  describe '#has_next?' do
    context 'on first page' do
      before { options[:limit] = 1 }

      it 'has next page' do
        options[:params][:page] = 1
        pager = Pager.new(options)
        pager.paginate
        pager.has_next?.should be_true
      end
    end

    context 'on second page' do
      it 'has no next page' do
        options[:params][:page] = 2
        pager = Pager.new(options)
        pager.paginate
        pager.has_next?.should be_false
      end
    end
  end

  describe '#url' do
    it 'clear the url and return the domain with the actual page number' do
      options[:params][:url] = '/?other=param&page=none'
      Pager.new(options).url.should == '/?page='
    end
  end

  describe '#back_url' do
    it 'will append the page number 1' do
      options[:params][:page] = 2
      Pager.new(options).back_url.should == '/?page=1'
    end
  end

  describe '#next_url' do
    it 'will append the page number 3' do
      options[:params][:page] = 2
      Pager.new(options).next_url.should == '/?page=3'
    end
  end
end
