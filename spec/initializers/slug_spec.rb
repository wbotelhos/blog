# coding: utf-8

require 'spec_helper'

describe String do
  it 'slug blank' do
    expect(' '.slug).to be_blank
  end

  it 'slug space' do
    expect('a b'.slug).to eq 'a-b'
  end

  it 'slug last dash' do
    expect('a b !'.slug).to eq 'a-b'
  end

  it 'keeps underscore' do
    expect('_'.slug).to eq '_'
  end

  it 'replaces hyphen separator to just hyphen' do
    expect('a - a'.slug).to eq 'a-a'
  end

  it 'slug none alpha alphanumeric' do
    expect(%(ok!@#$\%ˆ&*()+-={}|[]\\:";'<>?,./).slug).to eq 'ok'
  end
end
