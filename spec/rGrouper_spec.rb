require 'spec_helper'

RSpec.describe RGrouper do
  subject { RGrouper.new }

  describe '#group' do
    let(:source) do
      [
        { cost: 10, views: 1, objective: 'itaque',  creative: 'aperiam', name: 'T006049A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'aperiam', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'aperiam', name: 'D123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'aperiam', name: 'BR123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'occaecati', name: 'I123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'itaque',  creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'excepturi', creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'excepturi', creative: 'occaecati', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'excepturi', creative: 'aperiam', name: 'F123456A ' },
        { cost: 10, views: 1, objective: 'excepturi', creative: 'aperiam', name: 'F123456A ' }
      ]
    end

    let(:groupers) do
      [
        :objective, # objectives as Symbol
        :creative, # creatives as Symbol
        ->(el) { el[:name][/(?:T|A|F|I|BR)\d{6}[A-Z]?(?=\ )/] }
      ] # name Proc wth Regexp
    end

    it 'works' do
      subject.pritify subject.group(source, *groupers)
      # expect(subject.group(source, *groupers))
      #   .to eq([])
    end
  end
end
