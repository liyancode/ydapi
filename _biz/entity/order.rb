module YDAPI
  module BizEntity
    class Order
      attr_accessor :id
      attr_accessor :order_id
      attr_accessor :added_by_user_name
      attr_accessor :contract_id
      attr_accessor :sign_by_user_name
      attr_accessor :customer_id
      attr_accessor :start_date
      attr_accessor :end_date
      attr_accessor :total_value
      attr_accessor :pay_type
      attr_accessor :paid_value
      attr_accessor :order_status
      attr_accessor :order_status_update_by
      attr_accessor :is_finished
      attr_accessor :description
      attr_accessor :comment
      attr_accessor :status
    end
  end
end