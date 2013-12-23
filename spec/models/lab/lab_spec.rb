require 'spec_helper'

describe Lab do
  it 'has a valid factory' do
    expect(FactoryGirl.build :lab).to be_valid
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }

  context :create do
    it 'creates a valid media' do
      expect(Lab.new name: 'The Lab', image: 'example.jpg', slug: 'the-lab').to be_valid
    end
  end

  context :uniqueness do
    let(:lab) { FactoryGirl.create :lab }

    it 'does not allow the same name'  do
      expect(FactoryGirl.build :lab, name: lab.name).to be_invalid
    end

    it 'does not allow the same slug'  do
      expect(FactoryGirl.build :lab, slug: lab.slug).to be_invalid
    end
  end

  describe :scope do
    let!(:lab_1) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 1), published_at: Time.local(2001, 1, 2) }
    let!(:lab_2) { FactoryGirl.create :lab, created_at: Time.local(2000, 1, 2), published_at: Time.local(2001, 1, 1) }

    context :sort do
      describe :by_id do
        it 'sort by id_at desc' do
          expect(Lab.by_id).to eq [lab_2, lab_1]
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
