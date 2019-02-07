require 'rails_helper'

RSpec.describe OrderApproval, type: :model do
  describe 'validations' do
    it 'OrderApproval needs a user - Success' do
      admin = create(:user)
      order = create(:order)
      order_approval = OrderApproval.new(user: admin, order: order)
      expect(order_approval).to be_valid
    end

    it 'OrderApproval needs a user - Failure' do
      order = create(:order)
      order_approval = OrderApproval.new(order: order)
      expect(order_approval).not_to be_valid
    end

    it 'OrderApproval needs an order - Success' do
      admin = create(:user)
      order = create(:order)
      order_approval = OrderApproval.new(user: admin, order: order)
      expect(order_approval).to be_valid
    end

    it 'OrderApproval needs an order - Failure' do
      admin = create(:user)
      order_approval = OrderApproval.new(user: admin)
      expect(order_approval).not_to be_valid
    end
  end
end
