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

        def DAO_SQL_Warehouse.select_max_wh_inventory_id_by_type(wh_inventory_type)
          begin
            result=[]
            DB.fetch(
                "select max(wh_inventory_id)
                 from wh_inventory
                 where wh_inventory_type='#{wh_inventory_type}'
                       ").each{|row|
              result<<row
            }
            result[0][:max]
          rescue Exception => e
            @@logger.error("#{self}.select_max_wh_inventory_id_by_type(#{wh_inventory_type}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_Warehouse.select_all_inventories_by_type_and_ids(wh_inventory_type,id_arr)
          begin
            like_str=''
            if id_arr.size>0
              like_str='where id=-1'
              id_arr.each{|id|
                like_str=like_str+" or wh_inventory_id like '%#{id}%'"
              }
            end

            type_str=''
            if wh_inventory_type!='all'
              if like_str==''
                type_str=" where wh_inventory_type='#{wh_inventory_type}'"
              else
                type_str=" and wh_inventory_type='#{wh_inventory_type}'"
              end
            end
            result=[]
            sql="select *
                 from wh_inventory
                 #{like_str}#{type_str}"
            @@logger.info("#{self}.select_all_inventories_by_type_and_ids(#{wh_inventory_type},#{id_arr}) sql=#{sql}")
            DB.fetch(sql).each{|row|
              result<<row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_all_inventories_by_type_and_ids(#{wh_inventory_type},#{id_arr}) Exception:#{e}")
            nil
          end
        end

      end
    end
  end
end