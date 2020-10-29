# frozen_string_literal: true

RSpec.describe HighlighterService, '#highlight' do
  context 'when using markdown' do
    let!(:text) do
      <<~HEREDOC
      # Code

      ```ruby
      def say
        print 'Hello World!'
      end
      ```
      HEREDOC
    end

    it 'converts to markdown with syntax highlight' do
      expect(described_class.highlight(text).squish).to eq %(
        <h1>Code</h1>

        <div class="highlight"><pre class="highlight ruby"><code><span class="k">def</span> <span class="nf">say</span>
          <span class="nb">print</span> <span class="s1">'Hello World!'</span>
          <span class="k">end</span>
          </code></pre></div>
      ).squish
    end
  end

  context 'when using html' do
    let!(:text) { '<div id="identification">content<div>' }

    it 'does not scapes html' do
      expect(described_class.highlight(text).squish).to eq '<p><div id="identification">content<div></p>'
    end
  end
end
