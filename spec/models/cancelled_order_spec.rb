require 'rails_helper'

RSpec.describe CancelledOrder, type: :model do
  describe 'validation' do
    it 'internal reason is optional' do
      cancelled_order = build(CancelledOrder, internal_reason: '')

      expect(cancelled_order).to be_valid
    end

    it 'client reason must be present' do
      cancelled_order = build(CancelledOrder, client_reason: '')

      expect(cancelled_order).not_to be_valid
    end
  end
end
