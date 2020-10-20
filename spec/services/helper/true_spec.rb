# frozen_string_literal: true

RSpec.describe Helper, '#true?' do
  it { expect(described_class.true?('true')).to  be true }
  it { expect(described_class.true?('false')).to be false }

  it { expect(described_class.true?(true)).to  be true }
  it { expect(described_class.true?(false)).to be false }

  it { expect(described_class.true?('1')).to be true }
  it { expect(described_class.true?('0')).to be false }

  it { expect(described_class.true?('on')).to  be true }
  it { expect(described_class.true?('off')).to be false }

  it { expect(described_class.true?(1)).to be true }
  it { expect(described_class.true?(0)).to be false }
end
