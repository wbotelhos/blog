require 'rails_helper'

describe CommentHelper do
  describe '#anchor' do
    let(:comment) { FactoryGirl.build :comment, id: 1 }

    it 'builds an anchor with id' do
      expect(helper.anchor comment).to eq '#comment-1'
    end
  end

  describe '#id_for' do
    let(:comment) { FactoryGirl.build :comment, id: 1 }

    it 'builds a string with id' do
      expect(helper.id_for comment).to eq 'comment-1'
    end
  end

  describe '#comment_name' do
    it 'builds the href html with the name' do
      expect(helper.comment_name double(name: 'John').as_null_object).to match %r(John</a>)
    end

    context 'with options' do
      let(:comment) { double(name: 'John').as_null_object }

      it 'appends the options as key value' do
        expect(helper.comment_name comment, key: :value).to match %r(key="value")
      end
    end

    context 'with url on commnet' do
      let(:comment) { FactoryGirl.build :comment, url: 'example.org' }

      it 'builds the href with url' do
        expect(helper.comment_name comment).to match %r(href="example.org)
      end

      it 'opens on new window' do
        expect(helper.comment_name comment).to match %r(target="_blank)
      end
    end

    context 'without url on commnet' do
      let(:comment) { FactoryGirl.build :comment, url: nil }

      it 'builds the href with void' do
        expect(helper.comment_name comment).to match %r(void)
      end

      it 'does not open on new window' do
        expect(helper.comment_name comment).to_not match %r(href="_blank)
      end
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
