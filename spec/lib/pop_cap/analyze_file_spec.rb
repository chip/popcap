require 'spec_helper'
require 'pop_cap/analyze_file'
require 'fileutils'

module PopCap
  describe AnalyzeFile do
    let(:bad_file) { "#{File.expand_path('spec/fixtures/bad_file.img')}" }

    before { FileUtils.touch bad_file }
    after { FileUtils.rm_f bad_file }

    context ".examine" do
      let(:response) { AnalyzeFile.examine(bad_file) }

      it 'has a datetime stamp' do
        date_regex = %r(FFprobe read error on \d{4}-\d{2}-\d{2} at \d{2}:\d{2}:\d{2})
        expect(response[0]).to match date_regex
      end

      it 'has the error message' do
        expect(response).
          to include "#{bad_file}: Invalid data found when processing input"
      end
    end
  end
end
