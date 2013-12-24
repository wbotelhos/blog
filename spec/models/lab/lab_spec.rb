require 'spec_helper'

describe Lab do
  it 'has a valid factory' do
    expect(FactoryGirl.build :lab).to be_valid
  end

  it { should validate_presence_of :title }

  context :create do
    it 'creates a valid media' do
      lab = Lab.new title: 'title', slug: 'title'

      expect(lab).to be_valid
    end
  end

  context :uniqueness do
    let(:lab) { FactoryGirl.create :lab }

    it 'does not allow the same title'  do
      expect(FactoryGirl.build(:lab, title: lab.title)).to be_invalid
    end
  end

  describe :scope do
    let!(:lab_1) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 1), published_at: Time.local(2001, 1, 2) }
    let!(:lab_2) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 2), published_at: Time.local(2001, 1, 1) }

    describe :home_selected do
      let!(:lab) { FactoryGirl.create :lab }
      let(:result)   { Lab.home_selected.first }

      it 'brings only the fields used on home' do
        expect(result).to     have_attribute :published_at
        expect(result).to     have_attribute :slug
        expect(result).to     have_attribute :title
        expect(result).to_not have_attribute :body
        expect(result).to_not have_attribute :created_at
        expect(result).to_not have_attribute :id
        expect(result).to_not have_attribute :updated_at
        expect(result).to_not have_attribute :user_id
      end
    end

    describe :by_month do
      let!(:lab_1) { FactoryGirl.create :lab, published_at: Time.local(2013, 01, 01) }
      let!(:lab_2) { FactoryGirl.create :lab, published_at: Time.local(2013, 01, 01) }
      let!(:lab_3) { FactoryGirl.create :lab, published_at: Time.local(2013, 02, 01) }
      let!(:lab_4) { FactoryGirl.create :lab, published_at: Time.local(2013, 03, 01) }
      let(:result) { Lab.by_month }

      xit 'groups the labs by published month'
    end

    context :sort do
      describe :by_created do
        it 'sort by created_at desc' do
          expect(Lab.by_created).to eq [lab_2, lab_1]
        end
      end

      describe :by_published do
        it 'sort by published_at desc' do
          expect(Lab.by_published).to eq [lab_1, lab_2]
        end
      end
    end

    context :state do
      let!(:lab_draft) { FactoryGirl.create :lab }

      describe :drafts do
        it 'returns drafts' do
          expect(Lab.drafts).to eq [lab_draft]
        end
      end

      describe :published do
        context 'lab without published date on the past' do
          it 'is ignored' do
            expect(Lab.published).to include lab_1, lab_2
          end
        end

        context 'lab without published date in the same time' do
          before do
            Time.stub(:now).and_return Time.local(2013, 1, 1, 0, 0, 0)

            @lab_now = FactoryGirl.create :lab, published_at: Time.now
          end

          it 'is ignored' do
            expect(Lab.published).to include @lab_now
          end
        end

        context 'lab without published date' do
          it 'is ignored' do
            expect(Lab.published).to_not include lab_draft
          end
        end

        context 'lab with published date but in the future (scheduled)' do
          let!(:lab_scheduled) { FactoryGirl.create :lab, published_at: Time.local(2500, 1, 1) }

          it 'is ignored' do
            expect(Lab.published).to_not include lab_scheduled
          end
        end
      end
    end
  end

  describe '.url' do
    context 'when it is published' do
      let(:lab) { FactoryGirl.build :lab }

      it 'return the online url of the url' do
        expect(lab.url).to eq "http://wbotelhos.com/#{lab.slug}"
      end
    end
  end

  describe '.github' do
    context 'when it is published' do
      let(:lab) { FactoryGirl.build :lab }

      it 'return the online url of the github' do
        expect(lab.github).to eq "http://github.com/wbotelhos/#{lab.slug}"
      end
    end
  end
end
