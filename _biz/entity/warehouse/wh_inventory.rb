module YDAPI
  module BizEntity
    class WHInventory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :wh_inventory_id
      attr_accessor :wh_inventory_type
      attr_accessor :wh_location
      attr_accessor :wh_inner_location
      attr_accessor :principal
      attr_accessor :name
      attr_accessor :specification
      attr_accessor :description
      attr_accessor :count
      attr_accessor :count_unit
      attr_accessor :unit_price
      attr_accessor :auxiliary_count
      attr_accessor :auxiliary_count_unit
      attr_accessor :other
    end
  end
end