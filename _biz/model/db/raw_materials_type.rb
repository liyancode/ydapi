module YDAPI
  module BizModel
    module DBModel
      class RawMaterialsType < Sequel::Model(:raw_materials_type)
        @@logger=BIZ_MODEL_LOGGER
        def RawMaterialsType.func_add(raw_material_type)
          begin
            RawMaterialsType.create do |rm|
              rm.raw_material_type_id = raw_material_type.raw_material_type_id
              rm.added_by_user_name = raw_material_type.added_by_user_name
              rm.name = raw_material_type.name
              rm.description = raw_material_type.description
              rm.comment = raw_material_type.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(raw_material_type) Exception:#{e}")
            nil
          end
        end

        def RawMaterialsType.func_delete(raw_material_type_id)
          begin
            RawMaterialsType[raw_material_type_id: raw_material_type_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(raw_material_type_id) Exception:#{e}")
            nil
          end
        end

        def RawMaterialsType.func_update(raw_material_type)
          begin
            exist_raw_material_type=RawMaterialsType[raw_material_type_id: raw_material_type.raw_material_type_id]
            new_raw_material_type=exist_raw_material_type.update(
                description: raw_material_type.description,
                comment: raw_material_type.comment
            )
            if new_raw_material_type
              new_raw_material_type
            else
              exist_raw_material_type
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(raw_material_type) Exception:#{e}")
            nil
          end
        end

        def RawMaterialsType.func_get(raw_material_type_id)
          begin
            RawMaterialsType[raw_material_type_id: raw_material_type_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def RawMaterialsType.func_get_all
          begin
            RawMaterialsType.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get(raw_material_id) Exception:#{e}")
            nil
          end
        end

        def RawMaterialsType.func_get_max_raw_material_type_id
          begin
            RawMaterialsType.last.raw_material_type_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_raw_material_type_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end