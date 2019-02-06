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
  end
end
