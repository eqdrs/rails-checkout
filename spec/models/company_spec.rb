require 'rails_helper'

describe Company, type: :model do
  describe 'validation' do
    it 'company needs a valid cnpj - Successfully' do
      user = build(:company)

      expect(user).to be_valid
    end

    it 'company needs a valid cnpj - Failed' do
      user = build(:company, cnpj: '12314124')
      expect(user).not_to be_valid
    end

    it 'cnpj to be only numbers' do
      company = build(:company, cnpj: '17.298.092/0001-30')
      company.save

      expect(company.cnpj).to eq('17298092000130')
    end
  end
end
