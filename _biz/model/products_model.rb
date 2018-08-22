module YDAPI
  module BizModel
    class ProductsModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@product=YDAPI::BizEntity::Product
      @@products=YDAPI::BizModel::DBModel::Products

      @@product_type=YDAPI::BizEntity::ProductType
      @@products_type=YDAPI::BizModel::DBModel::ProductsType

      @@raw_materials=YDAPI::BizModel::DBModel::RawMaterials

      def ProductsModel.add_new_product(product)
        if product.is_a?(@@product)
          new_id = @@helper.new_product_id(@@products.func_get_max_product_id)
          if new_id != nil
            product.product_id = new_id
            @@logger.info("#{self}.add_new_product, product=#{product}")
            @@products.func_add(product)
          else
            @@logger.error("#{self}.add_new_product, new_product_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_product, product is not a #{@@product}")
          nil
        end
      end

      def ProductsModel.add_new_product_type(product_type)
        if product_type.is_a?(@@product_type)
          new_id = @@helper.new_step1_id(@@products_type.func_get_max_product_type_id)
          if new_id != nil
            product_type.product_type_id = new_id
            @@logger.info("#{self}.add_new_product_type, product=#{product}")
            @@products_type.func_add(product_type)
          else
            @@logger.error("#{self}.add_new_product_type, new_product_type_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_product_type, usproduct_typeer is not a #{@@product_type}")
          nil
        end
      end

      def ProductsModel.delete_product_by_product_id(product_id)
        @@logger.info("#{self}.delete_product_by_product_id(#{product_id})")
        @@products.func_delete(product_id)
      end

      def ProductsModel.delete_product_type_by_product_type_id(product_type_id)
        @@logger.info("#{self}.delete_product_type_by_product_type_id(#{product_type_id})")
        @@products_type.func_delete(product_type_id)
      end

      def ProductsModel.update_product(product)
        @@logger.info("#{self}.update_product, product=#{product}")
        @@products.func_update(product)
      end

      def ProductsModel.update_product_type(product_type)
        @@logger.info("#{self}.update_product_type, product_type=#{product_type}")
        @@products_type.func_update(product_type)
      end

      def ProductsModel.get_product_by_product_id(product_id)
        @@logger.info("#{self}.get_product_by_product_id(#{product_id})")
        product = @@products.func_get(product_id)
        if product
          tmp_id_arr=[]
          product.raw_material_ids.size>0?tmp_id_arr=product.raw_material_ids.split(','):tmp_id_arr=[]
          raw_materials = @@raw_materials.func_get_by_id_arr(tmp_id_arr)
          raw_materials_array = []
          if raw_materials
            raw_materials.each {|row|
              raw_materials_array << row.values
            }
          end
          {:product => product.values, :raw_materials => raw_materials_array}
        else
          nil
        end
      end

      def ProductsModel.get_products_by_product_type_id(product_type_id)
        @@logger.info("#{self}.get_products_by_product_type_id(#{product_type_id})")
        products = @@products.func_get_all_by_product_type_id(product_type_id)
        if products
          products_array = []
          products.each{|row|
            products_array<<row.values
          }
          {:products => products_array}
        else
          nil
        end
      end

      def ProductsModel.get_all_products
        @@logger.info("#{self}.get_all_products")
        products = @@products.func_get_all
        if products
          products_array = []
          products.each{|row|
            products_array<<row.values
          }
          {:products => products_array}
        else
          nil
        end
      end

      def ProductsModel.get_all_product_types
        @@logger.info("#{self}.get_all_product_types")
        product_types = @@products_type.func_get_all
        if product_types
          product_types_array = []
          product_types.each{|row|
            product_types_array<<row.values
          }
          {:product_types => product_types_array}
        else
          nil
        end
      end
    end
  end
end