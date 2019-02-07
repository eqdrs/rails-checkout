require 'rails_helper'

describe Individual, type: :model do
  describe 'validation' do
    it 'individual needs a valid cpf - Successfully' do
      user = build(:individual)

      expect(user).to be_valid
    end

    it 'individual needs a valid cpf - Failed' do
      user = build(:individual, cpf: '')
      expect(user).not_to be_valid
    end

    it 'cpf to be only numbers' do
    user = build(:individual, cpf: '288.135.104-20')
      user.save
      
      expect(user.cpf).to eq('28813510420')
    end
  end
end
