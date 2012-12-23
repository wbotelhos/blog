require 'spec_helper'

describe Lab do
  it "has a valid factory" do
    FactoryGirl.build(:lab).should be_valid
  end

  let(:lab_new) { Lab.new }
  let(:lab_draft) { FactoryGirl.build :lab_draft }
  let(:lab_published) { FactoryGirl.build :lab_published }

  describe "getting the status" do
    context "when lab is new" do
      it "return the text 'Novo'" do
        lab_new.status.should == "Novo"
      end
    end

    context "when it is a draft" do
      it "return the text 'Rascunho'" do
        lab_draft.status.should == "Rascunho"
      end
    end

    context "when it is published" do
      it "return the text 'Publicado'" do
        lab_published.status.should == "Publicado"
      end
    end
  end

  describe ":site" do
    context "when it is published" do
      it "return the online url of the site" do
        lab_published.site.should == "http://wbotelhos.com/#{lab_published.slug}"
      end
    end
  end

  describe ":github" do
    context "when it is published" do
      it "return the online url of the github" do
        lab_published.github.should == "http://github.com/wbotelhos/#{lab_published.slug}"
      end
    end
  end

  describe ':scope' do
    context 'when listing' do
      let!(:lab_1) { FactoryGirl.create :lab, created_at: Date.new(2000, 01, 01) }
      let!(:lab_2) { FactoryGirl.create :lab, created_at: Date.new(2000, 01, 02) }

      it "sort by desc :create_at" do
        Lab.all.to_a.should == [lab_2, lab_1]
      end
    end
  end
end
