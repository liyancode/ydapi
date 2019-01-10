module YDAPI
  module BizEntity
    class WHRawMaterialHistory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :wh_id
      attr_accessor :wh_id_sub
      attr_accessor :record_type
      attr_accessor :update_what
      attr_accessor :order_contract_id
      attr_accessor :inbound_count
      attr_accessor :inbound_weight
      attr_accessor :inbound_unit_price
      attr_accessor :inbound_total_price
      attr_accessor :inbound_from
      attr_accessor :inbound_principal
      attr_accessor :inbound_at
      attr_accessor :outbound_count
      attr_accessor :outbound_weight
      attr_accessor :outbound_unit_price
      attr_accessor :outbound_total_price
      attr_accessor :outbound_to
      attr_accessor :outbound_principal
      attr_accessor :outbound_at
      attr_accessor :other
    end
  end
end