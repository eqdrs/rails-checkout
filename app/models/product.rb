class Product < ApplicationRecord
  def set_infos(plan_id, plan_name, plan_description)
    self.plan_id = plan_id
    self.plan_name = plan_name
    self.plan_description = plan_description
  end
end
