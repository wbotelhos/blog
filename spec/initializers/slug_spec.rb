# coding: utf-8

require 'spec_helper'

describe String do
  let(:text) { "City - São João del-rey ('!@#$alive%ˆ&*~^]}" }

  it 'slug blank' do
    ' '.slug.should == ''
  end

  it 'slug space' do
    'a b'.slug.should == 'a-b'
  end

  it 'slug last dash' do
    'a b !'.slug.should == 'a-b'
  end

  it 'keeps underscore' do
    '_'.slug.should == '_'
  end

  it 'replaces hyphen separator to just hyphen' do
    'a - a'.slug.should == 'a-a'
  end

  it 'slug none alpha alphanumeric' do
    %(ok!@#$\%ˆ&*()+-={}|[]\\:";'<>?,./).slug.should == 'ok'
  end
end
