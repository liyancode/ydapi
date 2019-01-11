module YDAPI
  module BizModel
    module DBModel
      class DAO_WHRawMaterial < Sequel::Model(:wh_raw_material)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHRawMaterial.func_add(wh_raw_material)
          begin
            DAO_WHRawMaterial.create do |obj|
              obj.created_by = wh_raw_material.created_by
              obj.last_update_by = wh_raw_material.last_update_by
              obj.comment = wh_raw_material.comment

              obj.wh_id = wh_raw_material.wh_id
              obj.wh_id_sub = wh_raw_material.wh_id_sub
              obj.wh_location = wh_raw_material.wh_location
              obj.wh_inner_location = wh_raw_material.wh_inner_location
              obj.principal = wh_raw_material.principal
              obj.name = wh_raw_material.name
              obj.specification = wh_raw_material.specification
              obj.description = wh_raw_material.description
              obj.count = wh_raw_material.count
              obj.count_unit = wh_raw_material.count_unit
              obj.unit_price = wh_raw_material.unit_price
              obj.weight = wh_raw_material.weight
              obj.weight_unit = wh_raw_material.weight_unit
              obj.other = wh_raw_material.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_raw_material.wh_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_delete(id)
          begin
            DAO_WHRawMaterial[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_update(wh_raw_material)
          begin
            exist_item=DAO_WHRawMaterial[id: wh_raw_material.id]
            new_item=exist_item.update(
                # password: wh_raw_material.password,
                last_update_by: wh_raw_material.last_update_by,
                comment: wh_raw_material.comment,
                wh_location: wh_raw_material.wh_location,
                wh_inner_location: wh_raw_material.wh_inner_location,
                principal: wh_raw_material.principal,
                name: wh_raw_material.name,
                specification: wh_raw_material.specification,
                description: wh_raw_material.description,
                count: wh_raw_material.count,
                count_unit: wh_raw_material.count_unit,
                unit_price: wh_raw_material.unit_price,
                weight: wh_raw_material.weight,
                weight_unit: wh_raw_material.weight_unit,
                other: wh_raw_material.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_raw_material.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_get(id)
          begin
            DAO_WHRawMaterial[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_get_one_rm(wh_id)
          begin
            DAO_WHRawMaterial.dataset.where(wh_id:wh_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_one_rm(#{wh_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_get_by_wh_id_sub(wh_id_sub)
          begin
            DAO_WHRawMaterial[wh_id_sub: wh_id_sub]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_wh_id_sub(#{wh_id_sub}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_get_all
          begin
            DAO_WHRawMaterial.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_is_wh_id_exist(wh_id)
          begin
            if DAO_WHRawMaterial[wh_id: wh_id]
              true
            else
              false
            end
          rescue Exception => e
            @@logger.error("#{self}.func_is_wh_id_exist Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterial.func_is_wh_id_sub_exist(wh_id_sub)
          begin
            if DAO_WHRawMaterial[wh_id_sub: wh_id_sub]
              true
            else
              false
            end
          rescue Exception => e
            @@logger.error("#{self}.func_is_wh_id_sub_exist Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end