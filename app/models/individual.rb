class Individual < Customer
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :cpf_validation

  private

  def cpf_validation
    errors.add(:cpf, I18n.t('errors.messages.invalid')) unless CPF.valid?(cpf)
  end
end
