module YDAPI
  module BizModel
    module DBModel
      class ProductsType < Sequel::Model(:products_type)
        @@logger=BIZ_MODEL_LOGGER
        def ProductsType.func_add(product_type)
          begin
            ProductsType.create do |p|
              p.product_type_id = product_type.product_type_id
              p.added_by_user_name = product_type.added_by_user_name
              p.name = product_type.name
              p.description = product_type.description
              p.comment = product_type.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(product_type) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_delete(product_type_id)
          begin
            ProductsType[product_type_id: product_type_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(product_type_id) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_update(product_type)
          begin
            exist_product_type=ProductsType[product_type_id: product_type.product_type_id]
            new_product_type=exist_product_type.update(
                description: product_type.description,
                comment: product_type.comment,
            )
            if new_product_type
              new_product_type
            else
              exist_product_type
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(product) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_get(product_type_id)
          begin
            ProductsType[product_type_id: product_type_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(ProductsType) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_get_all
          begin
            ProductsType.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_get_all_by_user_name(added_by_user_name)
          begin
            ProductsType.dataset.where(added_by_user_name:added_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(added_by_user_name) Exception:#{e}")
            nil
          end
        end

        def ProductsType.func_get_max_product_type_id
          begin
            ProductsType.last.product_type_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_product_type_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end