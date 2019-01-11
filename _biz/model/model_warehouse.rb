module YDAPI
  module BizModel
    class Model_Warehouse
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@_common_model_func = YDAPI::BizModel::CommonModelFunc

      # ====== wh_raw_material
      @@wh_raw_material = YDAPI::BizEntity::WHRawMaterial
      @@dao_wh_raw_material = YDAPI::BizModel::DBModel::DAO_WHRawMaterial

      # wh_raw_material
      def Model_Warehouse.add_wh_raw_material(wh_raw_material)
        @@_common_model_func.common_add(
            @@wh_raw_material,
            wh_raw_material,
            @@dao_wh_raw_material,
            @@logger,
            self,
            'add_wh_raw_material'
        )
      end

      def Model_Warehouse.delete_wh_raw_material_by_id(id)
        @@logger.info("#{self}.delete_wh_raw_material_by_id(#{id})")
        @@dao_wh_raw_material.func_delete(id)
      end

      def Model_Warehouse.update_wh_raw_material(wh_raw_material)
        @@logger.info("#{self}.update_wh_raw_material, name=#{wh_raw_material.name}")
        @@dao_wh_raw_material.func_update(wh_raw_material)
      end

      def Model_Warehouse.update_wh_raw_material_count(wh_id_sub,new_count)
        @@logger.info("#{self}.update_wh_raw_material_count, wh_id_sub=#{wh_id_sub},count=#{new_count}")
        @@dao_wh_raw_material.func_update_count(wh_id_sub,new_count)
      end

      def Model_Warehouse.get_wh_raw_material_by_id(id)
        @@logger.info("#{self}.get_wh_raw_material_by_id, id=#{id}")
        @@dao_wh_raw_material.func_get(id)
      end

      def Model_Warehouse.get_wh_raw_material_by_wh_id_sub(wh_id_sub)
        @@logger.info("#{self}.get_wh_raw_material_by_wh_id_sub, wh_id_sub=#{wh_id_sub}")
        @@dao_wh_raw_material.func_get_by_wh_id_sub(wh_id_sub)
      end

      def Model_Warehouse.get_wh_raw_material_by_wh_id(wh_id)
        @@logger.info("#{self}.get_wh_raw_material_by_wh_id, wh_id=#{wh_id}")

        begin
          items=@@dao_wh_raw_material.func_get_one_rm(wh_id)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_wh_raw_material_by_wh_id, wh_id=#{wh_id} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_materials
        @@logger.info("#{self}.get_all_wh_raw_materials")

        begin
          items=@@dao_wh_raw_material.func_get_all
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_all_wh_raw_materials Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.is_wh_raw_materials_wh_id_sub_exist(wh_id_sub)
        @@logger.info("#{self}.is_wh_raw_materials_wh_id_sub_exist")
        @@dao_wh_raw_material.func_is_wh_id_sub_exist(wh_id_sub)
      end

      # ====== wh_raw_material_history
      @@wh_raw_material_history = YDAPI::BizEntity::WHRawMaterialHistory
      @@dao_wh_raw_material_history = YDAPI::BizModel::DBModel::DAO_WHRawMaterialHistory

      # wh_raw_material_history
      def Model_Warehouse.add_wh_raw_material_history(wh_raw_material_history)
        @@_common_model_func.common_add(
            @@wh_raw_material_history,
            wh_raw_material_history,
            @@dao_wh_raw_material_history,
            @@logger,
            self,
            'add_wh_raw_material_history'
        )
      end

      def Model_Warehouse.delete_wh_raw_material_history_by_id(id)
        @@logger.info("#{self}.delete_wh_raw_material_history_by_id(#{id})")
        @@dao_wh_raw_material_history.func_delete(id)
      end

      def Model_Warehouse.update_wh_raw_material_history(wh_raw_material_history)
        @@logger.info("#{self}.update_wh_raw_material, id=#{wh_raw_material_history.id}")
        @@dao_wh_raw_material_history.func_update(wh_raw_material_history)
      end

      def Model_Warehouse.get_wh_raw_material_history_by_id(id)
        @@logger.info("#{self}.get_wh_raw_material_history_by_id, id=#{id}")
        @@dao_wh_raw_material_history.func_get(id)
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_wh_id(wh_id)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_wh_id, wh_id=#{wh_id}")
        begin
          items=@@dao_wh_raw_material_history.func_get_all_by_wh_id(wh_id)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_wh_id(#{wh_id}) Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_wh_id_sub(wh_id_sub)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_wh_id, wh_id_sub=#{wh_id_sub}")
        begin
          items=@@dao_wh_raw_material_history.func_get_all_by_wh_id_sub(wh_id_sub)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_wh_id(#{wh_id_sub}) Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_wh_id_type(wh_id,type)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_wh_id, wh_id=#{wh_id},type=#{type}")
        begin
          items=@@dao_wh_raw_material_history.func_get_all_by_wh_id_and_type(wh_id,type)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.func_get_all_by_wh_id_and_type(#{wh_id},#{type}) Exception:#{e}")
          nil
        end
      end

      @@dao_sql_warehouse=YDAPI::BizModel::DBModel::DAO_SQL_Warehouse
      def Model_Warehouse.get_all_wh_raw_material_history
        @@logger.info("#{self}.get_all_wh_raw_material_history")
        begin
          items=@@dao_sql_warehouse.select_all_raw_materials_history_no_update
          arr=[]
          if items
            items.each{|row|
              arr<<row
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_all_wh_raw_material_history Exception:#{e}")
          nil
        end
      end
      def Model_Warehouse.get_all_wh_raw_material_history_by_record_type(record_type)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_record_type, record_type=#{record_type}")
        begin
          items=@@dao_sql_warehouse.select_all_raw_materials_history(record_type)
          arr=[]
          if items
            items.each{|row|
              arr<<row
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_record_type, record_type=#{record_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.select_wh_raw_material_history_by_id(id)
        @@logger.info("#{self}.select_wh_raw_material_history_by_id, id=#{id}")
        @@dao_sql_warehouse.select_raw_materials_history_by_id(id)
      end
    end
  end
end