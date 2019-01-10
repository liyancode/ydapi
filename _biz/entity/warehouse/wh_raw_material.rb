module YDAPI
  module BizEntity
    class WHRawMaterial
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment

      attr_accessor :wh_id
      attr_accessor :wh_id_sub
      attr_accessor :wh_location
      attr_accessor :wh_inner_location
      attr_accessor :principal
      attr_accessor :name
      attr_accessor :specification
      attr_accessor :description
      attr_accessor :count
      attr_accessor :count_unit
      attr_accessor :unit_price
      attr_accessor :weight
      attr_accessor :weight_unit
      attr_accessor :other
    end
  end
end