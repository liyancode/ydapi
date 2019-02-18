module YDAPI
  module BizEntity
    class WHInventoryHistory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :history_id
      attr_accessor :wh_inventory_id
      attr_accessor :history_type
      attr_accessor :count_diff
      attr_accessor :auxiliary_count_diff
      attr_accessor :unit_price_diff
      attr_accessor :wh_inventory_batch_id
      attr_accessor :other
    end
  end
end