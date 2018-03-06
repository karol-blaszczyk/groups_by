require 'spec_helper'
require 'groups_by/core_ext/array'

RSpec.describe Array do
  subject do
    [
      { name: '--2222--', age: '18-24', gender: 'Male', views: 1 },
      { name: '--1111--', age: '18-24', gender: 'Female', views: 2 },
      { name: '--2222--', age: '25-34', gender: 'Female', views: 1 },
      { name: '--1111--', age: '25-34', gender: 'Male', views: 1 }
    ]
  end

  let(:expected_result) do
    {
      '18-24' =>
        {
          'Male' => {
            '2222' => [{ name: '--2222--', age: '18-24', gender: 'Male', views: 1 }]
          },
          'Female' => {
            '1111' => [{ name: '--1111--', age: '18-24', gender: 'Female', views: 2 }]
          }
        },
      '25-34' =>
        {
          'Female' => {
            '2222' => [{ name: '--2222--', age: '25-34', gender: 'Female', views: 1 }]
          },
          'Male' => {
            '1111' => [{ name: '--1111--', age: '25-34', gender: 'Male', views: 1 }]
          }
        }
    }
  end

  describe '#groups_by' do
    # let(:options) { { ignore: [] } }
    let(:grouping_rules) { [:age, :gender, ->(el) { el[:name][/\d+/] }] }

    let(:output) { subject.groups_by(*grouping_rules) }

    it 'returns an valid result' do
      expect(output).to eq(
        expected_result
      )
    end
  end
end
