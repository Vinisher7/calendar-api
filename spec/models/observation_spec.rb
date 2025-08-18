require 'rails_helper'

RSpec.describe Observation, type: :model do
  context 'Testing attributes' do
    let(:observation) { Observation.new(description: '', date_time: '') }
    it 'Nil attributes' do
      expect(observation).to_not be_valid
    end

    it 'Description have less than 5 characters' do
      observation.description = 'ddd'
      expect(observation).to_not be_valid
    end

    it 'Description have more than 100 characteres' do
      101.times do
        observation.description += 'A' 
      end
      expect(observation).to_not be_valid
    end
  end
end