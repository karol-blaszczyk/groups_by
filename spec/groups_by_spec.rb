require 'spec_helper'

RSpec.describe GroupsBy do
  subject { GroupsBy.new }

  describe '#group' do
    let(:source) do
      [
        { v1: 10, v2: 1, name: 'ni',  sub: 'ap', id: '-1-' },
        { v1: 10, v2: 1, name: 'ni',  sub: 'ap', id: '-3-' },
        { v1: 10, v2: 1, name: 'na', sub: 'ap', id: '-3-' }
      ]
    end

    let(:summarizer) do
      lambda do |metrics|
        {
          v1: metrics.map { |m| m[:v1].to_f }.reduce(&:+).round(2),
          v2: metrics.map { |m| m[:v2].to_f }.reduce(&:+)
        }
      end
    end

    let(:groupers) do
      [
        :name, # names as Symbol
        :sub, # sub as Symbol
        ->(el) { el[:id][/\d+/
          ] } # id Proc wth Regexp
      ]
    end

    shared_context 'groups and pritifies' do
      after do
        GroupsBy.pritify result
      end

      let(:grouped) do
        GroupsBy.new.groups_by(source,
                               group_by_rules: groupers,
                               summarizer: summarizer)
      end

      it 'groups correctly' do
        expect(grouped).to eq(result)
      end
    end

    context 'with summary' do
      let(:result) do
        {
          'ni' => {
            'ap' => {
              '1' => { values:
                [{ v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-1-' }
                  ] },
              '3' => { values:
                [{ v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-3-' }
                  ] },
              :totals => { v1: 20.0, v2: 2.0 }
            },
            :totals => { v1: 20.0, v2: 2.0 }
          },
          'na' => {
            'ap' => {
              '3' => { values:
                [{ v1: 10, v2: 1, name: 'na', sub: 'ap', id: '-3-' }
                  ] },
              :totals => { v1: 10.0, v2: 1.0 }
            },
            :totals => { v1: 10.0, v2: 1.0 }
          },
          :totals => { v1: 30.0, v2: 3.0 }
        }
      end
      it_behaves_like 'groups and pritifies'
    end

    context 'without summary' do
      let(:summarizer) { nil }
      let(:result) do
        {
          'ni' => {
            'ap' => {
              '1' => [{ v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-1-' }],
              '3' => [{ v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-3-' }]
            }
          },
          'na' => {
            'ap' => {
              '3' => [{ v1: 10, v2: 1, name: 'na', sub: 'ap', id: '-3-' }]
            }
          }
        }
      end
      it_behaves_like 'groups and pritifies'
    end

    context 'invalid grouping' do
      let(:groupers) { [:name, ->(el) { el[:a
        ] }
        ] }
      let(:result) do
        {
          'ni' => {
            '_unknown_group_' => { values:
              [{ v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-1-' },
                { v1: 10, v2: 1, name: 'ni', sub: 'ap', id: '-3-' }],
                totals: { v1: 20.0, v2: 2.0 } },
            :totals => { v1: 20.0, v2: 2.0 }
          },
          'na' => {
            '_unknown_group_' => { values:
              [{ v1: 10, v2: 1, name: 'na', sub: 'ap', id: '-3-' }
                ] },
            :totals => { v1: 10.0, v2: 1.0 }
          },
          :totals => { v1: 30.0, v2: 3.0 }
        }
      end
      it_behaves_like 'groups and pritifies'
    end
  end
end
