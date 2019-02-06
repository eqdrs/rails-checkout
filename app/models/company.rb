class Company < Customer
  validates :company_name, :cnpj, :contact, presence: true
  validates :cnpj, uniqueness: true
  validate :cnpj_validation

  private

  def cnpj_validation
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, I18n.t('errors.messages.invalid'))
  end
end
