module YDAPI
  module BizEntity
    class WHOutRecordHistory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :history_type
      attr_accessor :wh_out_record_id
      attr_accessor :wh_out_record_status
      attr_accessor :ship_to_name
      attr_accessor :ship_date
      attr_accessor :ship_to_address
      attr_accessor :ship_to_phone_number
      attr_accessor :ship_to_user
      attr_accessor :order_id
      attr_accessor :item_count
      attr_accessor :item_total_price
      attr_accessor :salesman
      attr_accessor :delivery_by
      attr_accessor :other
    end
  end
end