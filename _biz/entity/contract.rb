module YDAPI
  module BizEntity
    class Contract
      attr_accessor :id
      attr_accessor :contract_id
      attr_accessor :added_by_user_name
      attr_accessor :sign_by_user_name
      attr_accessor :customer_id
      attr_accessor :sign_at
      attr_accessor :start_date
      attr_accessor :end_date
      attr_accessor :total_value
      attr_accessor :description
      attr_accessor :contract_status #合同当前是否生效中1/0
      attr_accessor :comment
      attr_accessor :status
    end
  end
end