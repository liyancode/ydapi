module YDAPI
  module BizEntity
    class WHInventoryBatch
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :wh_inventory_batch_id
      attr_accessor :wh_inventory_id
      attr_accessor :wh_inventory_type
      attr_accessor :wh_location
      attr_accessor :wh_inner_location
      attr_accessor :production_order_id
      attr_accessor :principal
      attr_accessor :batch_number
      attr_accessor :batch_at
      attr_accessor :batch_type
      attr_accessor :batch_from
      attr_accessor :batch_to
      attr_accessor :batch_status
      attr_accessor :count
      attr_accessor :count_unit
      attr_accessor :unit_price
      attr_accessor :auxiliary_count
      attr_accessor :auxiliary_count_unit
      attr_accessor :other
    end
  end
end