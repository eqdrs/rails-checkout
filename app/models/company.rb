class Company < Customer
  validates :cnpj, :contact, presence: true
  validates :cnpj, uniqueness: true
  validate :cnpj_validation

  def save
    self.cnpj = CNPJ.new(cnpj).stripped
    super
  end

  def formatted_cnpj
    CNPJ.new(cnpj).formatted
  end

  private

  def cnpj_validation
    return if CNPJ.valid?(cnpj)

    errors.add(:cnpj, I18n.t('errors.messages.invalid'))
  end
end
