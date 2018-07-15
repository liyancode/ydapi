module YDAPI
  module BizModel
    module DBModel
      class Products < Sequel::Model(:products)
        @@logger=BIZ_MODEL_LOGGER
        def Products.func_add(product)
          begin
            Products.create do |p|
              p.product_id = product.product_id
              p.added_by_user_name = product.added_by_user_name
              p.name = product.name
              p.product_type_id = product.product_type_id
              p.measurement_unit = product.measurement_unit
              p.specification = product.specification
              p.raw_material_ids = product.raw_material_ids
              p.features = product.features
              p.use_for = product.use_for
              p.description = product.description
              p.comment = product.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(product) Exception:#{e}")
            nil
          end
        end

        def Products.func_delete(product_id)
          begin
            Products[product_id: product_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(product_id) Exception:#{e}")
            nil
          end
        end

        def Products.func_update(product)
          begin
            exist_product=Products[product_id: product.product_id]
            new_product=exist_product.update(
                product_type_id: product.product_type_id,
                measurement_unit: product.measurement_unit,
                specification: product.specification,
                raw_material_ids: product.raw_material_ids,
                features: product.features,
                use_for: product.use_for,
                description: product.description,
                comment: product.comment,
            )
            if new_product
              new_product
            else
              exist_product
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(product) Exception:#{e}")
            nil
          end
        end

        def Products.func_get(product_id)
          begin
            Products[product_id: product_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(product_id) Exception:#{e}")
            nil
          end
        end

        def Products.func_get_all
          begin
            Products.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def Products.func_get_all_by_product_type_id(product_type_id)
          begin
            Products.dataset.where(product_type_id:product_type_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_product_type_id(product_type_id) Exception:#{e}")
            nil
          end
        end

        def Products.func_get_all_by_user_name(added_by_user_name)
          begin
            Products.dataset.where(added_by_user_name:added_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(added_by_user_name) Exception:#{e}")
            nil
          end
        end

        def Products.func_get_max_product_id
          begin
            Products.last.product_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_product_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end