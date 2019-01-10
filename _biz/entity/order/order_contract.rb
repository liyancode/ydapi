module YDAPI
  module BizEntity
    class OrderContract
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :contract_id
      attr_accessor :type

      attr_accessor :a_customer_id
      attr_accessor :a_name
      attr_accessor :a_address
      attr_accessor :a_tax_qualification
      attr_accessor :a_tax_number
      attr_accessor :a_bankcard_number
      attr_accessor :a_bankcard_location
      attr_accessor :a_principal_name
      attr_accessor :a_principal_phone_number
      attr_accessor :a_principal_email
      attr_accessor :a_principal_other_contact

      attr_accessor :b_customer_id
      attr_accessor :b_name
      attr_accessor :b_address
      attr_accessor :b_tax_qualification
      attr_accessor :b_tax_number
      attr_accessor :b_bankcard_number
      attr_accessor :b_bankcard_location
      attr_accessor :b_principal_name
      attr_accessor :b_principal_phone_number
      attr_accessor :b_principal_email
      attr_accessor :b_principal_other_contact

      attr_accessor :sign_date
      attr_accessor :sign_location
      attr_accessor :start_date
      attr_accessor :end_date
      attr_accessor :payment_total
      attr_accessor :payment_currency
      attr_accessor :payment_type
      attr_accessor :payment_paid
      attr_accessor :contract_detail_product_items
      attr_accessor :contract_detail_content
      attr_accessor :contract_status
      attr_accessor :review_by
      attr_accessor :review_status
      attr_accessor :review_comment

    end
  end
end