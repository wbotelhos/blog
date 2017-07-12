require 'rails_helper'

describe CommentHelper do
  describe '#anchor' do
    let(:comment) { FactoryGirl.build :comment, id: 1 }

    it 'builds an anchor with id' do
      expect(helper.anchor comment).to eq '#comment-1'
    end
  end

  describe '#self_anchor' do
    let(:comment) { FactoryGirl.build :comment, id: 1 }

    it 'builds the href with self anchor' do
      expect(helper.self_anchor comment).to match 'href="#comment-1'
    end

    it 'builds the href html with id' do
      expect(helper.self_anchor comment).to match '#1</a>'
    end
  end
end
