module YDAPI
  module BizEntity
    class Product
      attr_accessor :id
      attr_accessor :product_id
      attr_accessor :added_by_user_name
      attr_accessor :name
      attr_accessor :product_type_id
      attr_accessor :measurement_unit
      attr_accessor :specification
      attr_accessor :raw_material_ids # 1,2,3 by ,
      attr_accessor :features
      attr_accessor :use_for
      attr_accessor :description
      attr_accessor :comment
      attr_accessor :status
    end
  end
end