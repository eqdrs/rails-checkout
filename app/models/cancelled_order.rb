class CancelledOrder < ApplicationRecord
  belongs_to :order

  validates :client_reason, presence: true
end
