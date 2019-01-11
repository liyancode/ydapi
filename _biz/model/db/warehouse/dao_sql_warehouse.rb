module YDAPI
  module BizModel
    module DBModel
      class DAO_SQL_Warehouse
        @@logger=BIZ_MODEL_LOGGER
        def DAO_SQL_Warehouse.select_all_raw_materials_history_no_update
          begin
            result=[]
            DB.fetch(
                "select *
                 from wh_raw_material_history
                 where status=1 and record_type<>'update'").each{|row|
              result<<row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_all_raw_materials_history_no_update(#{department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_Warehouse.select_raw_materials_history_by_id(id)
          begin
            result={}
            DB.fetch(
                "select rm.wh_id_sub,rm.name,rm.specification,hist.*
                 from wh_raw_material_history as hist,wh_raw_material as rm
                 where hist.id='#{id}'").each{|row|
              result=row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_all_raw_materials_history(#{record_type}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_Warehouse.select_all_raw_materials_history(record_type)
          begin
            result=[]
            DB.fetch(
                "select rm.wh_id_sub,rm.name,rm.specification,hist.*
                 from wh_raw_material_history as hist,wh_raw_material as rm
                 where record_type='#{record_type}'
                       and hist.wh_id_sub=rm.wh_id_sub
                       and hist.status=1").each{|row|
              result<<row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_all_raw_materials_history(#{record_type}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end