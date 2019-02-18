module YDAPI
  module BizEntity
    class WHOutRecordItem
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :wh_out_record_id
      attr_accessor :wh_inventory_id
      attr_accessor :packing_count
      attr_accessor :packing_count_unit
      attr_accessor :auxiliary_count
      attr_accessor :auxiliary_count_unit
      attr_accessor :unit_price
      attr_accessor :total_price
      attr_accessor :other
    end
  end
end