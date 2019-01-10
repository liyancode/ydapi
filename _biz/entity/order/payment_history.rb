module YDAPI
  module BizEntity
    class PaymentHistory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :payment_id
      attr_accessor :type
      attr_accessor :type_comment
      attr_accessor :contract_id
      attr_accessor :other_ref_id
      attr_accessor :payment_method
      attr_accessor :payment_payer_id
      attr_accessor :payment_beneficiary_id
      attr_accessor :payment_currency
      attr_accessor :payment_value
      attr_accessor :payment_at
      attr_accessor :payment_message
      attr_accessor :payment_screenshot
      attr_accessor :payment_review_by
      attr_accessor :payment_review_status
      attr_accessor :payment_operator
      attr_accessor :payment_status
      attr_accessor :other
    end
  end
end