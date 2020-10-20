# frozen_string_literal: true

require 'support/shoulda'

RSpec.describe Lab do
  it 'has a valid factory' do
    expect(FactoryBot.build(:lab)).to be_valid
  end

  it { is_expected.to validate_presence_of :analytics }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :keywords }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :version }

  context :uniqueness do
    let(:lab) { FactoryBot.create :lab }

    it 'does not allow the same title'  do
      expect(FactoryBot.build(:lab, title: lab.title)).to be_invalid
    end
  end

  describe :scope do
    let!(:lab_1) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 1), published_at: Time.zone.local(2001, 1, 2) }
    let!(:lab_2) { FactoryBot.create :lab, created_at: Time.zone.local(2000, 1, 2), published_at: Time.zone.local(2001, 1, 1) }

    describe :home_selected do
      let!(:lab)   { FactoryBot.create :lab }
      let(:result) { Lab.home_selected.first }

      it 'brings only the fields used on home' do
        expect(result).to     have_attribute :published_at
        expect(result).to     have_attribute :slug
        expect(result).to     have_attribute :title
        expect(result).not_to have_attribute :body
        expect(result).not_to have_attribute :created_at
        expect(result).not_to have_attribute :css_import
        expect(result).not_to have_attribute :js
        expect(result).not_to have_attribute :js_import
        expect(result).not_to have_attribute :js_ready
        expect(result).not_to have_attribute :updated_at
        expect(result).not_to have_attribute :user_id
        expect(result).not_to have_attribute :version
        expect(result.id).to  be_nil
      end
    end

    describe :by_month do
      let!(:lab_1) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o1, 0o1) }
      let!(:lab_2) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o1, 0o1) }
      let!(:lab_3) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o2, 0o1) }
      let!(:lab_4) { FactoryBot.create :lab, published_at: Time.zone.local(2013, 0o3, 0o1) }
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
      let!(:lab_draft) { FactoryBot.create :lab }

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
            allow(Time).to receive(:now).and_return Time.zone.local(2013, 1, 1, 0, 0, 0)

            @lab_now = FactoryBot.create :lab, published_at: Time.current
          end

          it 'is ignored' do
            expect(Lab.published).to include @lab_now
          end
        end

        context 'lab without published date' do
          it 'is ignored' do
            expect(Lab.published).not_to include lab_draft
          end
        end

        context 'lab with published date but in the future (scheduled)' do
          let!(:lab_scheduled) { FactoryBot.create :lab, published_at: Time.zone.local(2500, 1, 1) }

          it 'is ignored' do
            expect(Lab.published).not_to include lab_scheduled
          end
        end
      end
    end
  end

  describe '.url' do
    let(:lab) { FactoryBot.build :lab }

    it 'return the online url of the url' do
      expect(lab.url).to eq "#{CONFIG['url_http']}/#{lab.slug}"
    end
  end

  describe '.github' do
    let(:lab) { FactoryBot.build :lab }

    it 'return the online url of the github' do
      expect(lab.github).to eq "http://github.com/#{CONFIG['github']}/#{lab.slug}"
    end
  end

  describe '.download' do
    let(:lab) { FactoryBot.build :lab }

    it 'return the github download url' do
      expect(lab.download).to eq "http://github.com/#{CONFIG['github']}/#{lab.slug}/archive/#{lab.version}.zip"
    end
  end

  describe '.javascripts' do
    context 'with value' do
      context 'with single file' do
        let(:lab) { FactoryBot.build :lab, js_import: 'http://example.org' }

        it 'returns the urls wrapped with script tag' do
          expect(lab.javascripts).to eq %(<script src="http://example.org"></script>)
        end
      end

      context 'with multiple files' do
        context 'with spaces' do
          let(:lab) { FactoryBot.create :lab, js_import: 'http://example.org, http://example.com' }

          it 'returns the urls wrapped with script tag' do
            expect(lab.javascripts).to eq %(<script src="http://example.org"></script><script src="http://example.com"></script>)
          end
        end

        context 'without spaces' do
          let(:lab) { FactoryBot.build :lab, js_import: 'http://example.org,http://example.com' }

          it 'returns the urls wrapped with script tag' do
            expect(lab.javascripts).to eq %(<script src="http://example.org"></script><script src="http://example.com"></script>)
          end
        end
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, js_import: nil }

      it 'returns nothing' do
        expect(lab.javascripts).to be_nil
      end
    end
  end

  describe '.javascripts_inline' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js: '$("div").raty();' }

      it 'returns the content without wrap' do
        expect(lab.javascripts_inline).to eq '$("div").raty();'
      end
    end

    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js: nil }

      it 'returns nothing' do
        expect(lab.javascripts_inline).to be_nil
      end
    end
  end

  describe '.javascripts_ready' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js_ready: '$("div").raty();' }

      it 'returns the content without wrap' do
        expect(lab.javascripts_ready).to eq '$("div").raty();'
      end
    end

    context 'with value' do
      let(:lab) { FactoryBot.build :lab, js_ready: nil }

      it 'returns nothing' do
        expect(lab.javascripts_ready).to be_nil
      end
    end
  end

  describe '.stylesheets' do
    context 'with value' do
      context 'with single file' do
        let(:lab) { FactoryBot.build :lab, css_import: 'http://example.org' }

        it 'returns the urls wrapped with link tag' do
          expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org">)
        end
      end

      context 'with multiple files' do
        context 'with spaces' do
          let(:lab) { FactoryBot.create :lab, css_import: 'http://example.org, http://example.com' }

          it 'returns the urls wrapped with link tag' do
            expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org"><link rel="stylesheet" href="http://example.com">)
          end
        end

        context 'without spaces' do
          let(:lab) { FactoryBot.build :lab, css_import: 'http://example.org,http://example.com' }

          it 'returns the urls wrapped with link tag' do
            expect(lab.stylesheets).to eq %(<link rel="stylesheet" href="http://example.org"><link rel="stylesheet" href="http://example.com">)
          end
        end
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, css_import: nil }

      it 'returns nothing' do
        expect(lab.stylesheets).to be_nil
      end
    end
  end

  describe '.stylesheets_inline' do
    context 'with value' do
      let(:lab) { FactoryBot.build :lab, css: 'i { float: left }' }

      it 'returns the original content' do
        expect(lab.stylesheets_inline).to eq %(<style>i { float: left }</style>)
      end
    end

    context 'without value' do
      let(:lab) { FactoryBot.build :lab, css: nil }

      it 'returns nothing' do
        expect(lab.stylesheets_inline).to be_nil
      end
    end
  end
end
