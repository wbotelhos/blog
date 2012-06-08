# -*- encoding: utf-8 -*-

require "spec_helper"

# mailcatcher -f

describe Mailer do

  describe "#comment" do
    let!(:mail) {
      Mailer.comment({
        :name => "Botelho",
        :email => "botelho@gmail.com",
        :url => "http://wbotelhos.com.br/article#comment"
      })
    }

    subject { mail }

    it { should_not be_multipart }

    its(:subject) { should eql("Artigo respondido") }
    its(:from) { should include("noreply@wbotelhos.com.br") }

    #context "text mail" do
    #  subject { mail.parts.first }

    #  its(:body) { should have_content("Olá Washington Botelho,") }
    #  its(:body) { should have_content("Artigo respondido") }
    #  its(:body) { should have_content("noreply@wbotelhos.com.br") }
    #end
  end

end
