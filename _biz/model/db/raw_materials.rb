module YDAPI
  module BizModel
    module DBModel
      class RawMaterials < Sequel::Model(:raw_materials)
        @@logger=BIZ_MODEL_LOGGER
        def RawMaterials.func_add(raw_material)
          begin
            RawMaterials.create do |rm|
              rm.raw_material_id = raw_material.raw_material_id
              rm.added_by_user_name = raw_material.added_by_user_name
              rm.name = raw_material.name
              rm.raw_material_type_id = raw_material.raw_material_type_id
              rm.measurement_unit = raw_material.measurement_unit
              rm.specification = raw_material.specification
              rm.features = raw_material.features
              rm.use_for = raw_material.use_for
              rm.description = raw_material.description
              rm.comment = raw_material.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(raw_material) Exception:#{e}")
            nil
          end
        end

        def RawMaterials.func_delete(raw_material_id)
          begin
            RawMaterials[raw_material_id: raw_material_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def RawMaterials.func_update(raw_material)
          begin
            exist_raw_material=RawMaterials[raw_material_id: raw_material.raw_material_id]
            new_raw_material=exist_raw_material.update(
                raw_material_type_id: raw_material.raw_material_type_id,
                measurement_unit: raw_material.measurement_unit,
                specification: raw_material.specification,
                features: raw_material.features,
                use_for: raw_material.use_for,
                description: raw_material.description,
                comment: raw_material.comment
            )
            if new_raw_material
              new_raw_material
            else
              exist_raw_material
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(raw_material) Exception:#{e}")
            nil
          end
        end

        def RawMaterials.func_get(raw_material_id)
          begin
            RawMaterials[raw_material_id: raw_material_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def RawMaterials.func_get_by_id_arr(raw_material_id_arr)
          begin
            RawMaterials.dataset.where([[:raw_material_id,raw_material_id_arr]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id_arr(rdaw_material_id_arr) Exception:#{e}")
            nil
          end
        end

        def RawMaterials.func_get_max_raw_material_id
          begin
            RawMaterials.last.raw_material_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_raw_material_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end