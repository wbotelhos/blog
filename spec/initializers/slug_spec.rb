# coding: utf-8

require 'rails_helper'

describe String do
  it 'slugs blank' do
    expect(' '.slug).to be_blank
  end

  it 'slugs space' do
    expect('a b'.slug).to eq 'a-b'
  end

  it 'slugs last dash' do
    expect('a b !'.slug).to eq 'a-b'
  end

  it 'keeps underscore' do
    expect('_'.slug).to eq '_'
  end

  it 'replaces hyphen separator to just hyphen' do
    expect('a - a'.slug).to eq 'a-a'
  end

  it 'slugs none alpha alphanumeric' do
    expect(%(ok!@#$\%ˆ&*()+-={}|[]\\:";'<>?,./).slug).to eq 'ok'
  end

  it 'slugs hyphen on begin' do
    expect('-a'.slug).to eq 'a'
  end

  it 'slugs hyphen on the end' do
    expect('a-'.slug).to eq 'a'
  end

  context 'slugging it twice' do
    let(:slug) { 'The First Time'.slug }

    it 'slugs right' do
      expect(slug.slug).to eq 'the-first-time'
    end
  end
end
