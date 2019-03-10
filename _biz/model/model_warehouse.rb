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

      def Model_Warehouse.update_wh_raw_material_count(wh_id_sub, new_count)
        @@logger.info("#{self}.update_wh_raw_material_count, wh_id_sub=#{wh_id_sub},count=#{new_count}")
        @@dao_wh_raw_material.func_update_count(wh_id_sub, new_count)
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
          items = @@dao_wh_raw_material.func_get_one_rm(wh_id)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_raw_material_by_wh_id, wh_id=#{wh_id} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_materials
        @@logger.info("#{self}.get_all_wh_raw_materials")

        begin
          items = @@dao_wh_raw_material.func_get_all
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
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
          items = @@dao_wh_raw_material_history.func_get_all_by_wh_id(wh_id)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_wh_id(#{wh_id}) Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_wh_id_sub(wh_id_sub)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_wh_id, wh_id_sub=#{wh_id_sub}")
        begin
          items = @@dao_wh_raw_material_history.func_get_all_by_wh_id_sub(wh_id_sub)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_wh_id(#{wh_id_sub}) Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_wh_id_type(wh_id, type)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_wh_id, wh_id=#{wh_id},type=#{type}")
        begin
          items = @@dao_wh_raw_material_history.func_get_all_by_wh_id_and_type(wh_id, type)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.func_get_all_by_wh_id_and_type(#{wh_id},#{type}) Exception:#{e}")
          nil
        end
      end

      @@dao_sql_warehouse = YDAPI::BizModel::DBModel::DAO_SQL_Warehouse

      def Model_Warehouse.get_all_wh_raw_material_history
        @@logger.info("#{self}.get_all_wh_raw_material_history")
        begin
          items = @@dao_sql_warehouse.select_all_raw_materials_history_no_update
          arr = []
          if items
            items.each {|row|
              arr << row
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_raw_material_history Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_raw_material_history_by_record_type(record_type)
        @@logger.info("#{self}.get_all_wh_raw_material_history_by_record_type, record_type=#{record_type}")
        begin
          items = @@dao_sql_warehouse.select_all_raw_materials_history(record_type)
          arr = []
          if items
            items.each {|row|
              arr << row
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_raw_material_history_by_record_type, record_type=#{record_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.select_wh_raw_material_history_by_id(id)
        @@logger.info("#{self}.select_wh_raw_material_history_by_id, id=#{id}")
        @@dao_sql_warehouse.select_raw_materials_history_by_id(id)
      end


      # ====== wh_inventory
      @@wh_inventory = YDAPI::BizEntity::WHInventory
      @@dao_wh_inventory = YDAPI::BizModel::DBModel::DAO_WHInventory

      def Model_Warehouse.add_wh_inventory(wh_inventory)
        @@_common_model_func.common_add(
            @@wh_inventory,
            wh_inventory,
            @@dao_wh_inventory,
            @@logger,
            self,
            'add_wh_inventory'
        )
      end

      def Model_Warehouse.delete_wh_inventory_by_inventory_id(wh_inventory_id)
        @@logger.info("#{self}.delete_wh_inventory_by_inventory_id(#{wh_inventory_id})")
        @@dao_wh_inventory.func_delete_by_wh_inventory_id(wh_inventory_id)
      end

      def Model_Warehouse.update_wh_inventory(wh_inventory)
        @@logger.info("#{self}.update_wh_inventory_id, wh_inventory_id=#{wh_inventory.wh_inventory_id}")
        @@dao_wh_inventory.func_update(wh_inventory)
      end

      def Model_Warehouse.update_wh_inventory_count(wh_inventory_id, new_count, new_auxiliary_count)
        @@logger.info("#{self}.update_wh_inventory, wh_inventory_id=#{wh_inventory_id},count=#{new_count},new_auxiliary_count=#{new_auxiliary_count}")
        @@dao_wh_inventory.func_update_count(wh_inventory_id, new_count, new_auxiliary_count)
      end

      def Model_Warehouse.update_wh_inventory_count_in_or_out(wh_inventory_id, count_diff, auxiliary_count_diff, in_or_out)
        @@logger.info("#{self}.update_wh_inventory_count_in_or_out, wh_inventory_id=#{wh_inventory_id},count_diff=#{count_diff},auxiliary_count_diff=#{auxiliary_count_diff},in_or_out=#{in_or_out}")
        @@dao_wh_inventory.func_update_count_in_or_out(wh_inventory_id, count_diff, auxiliary_count_diff, in_or_out)
      end

      def Model_Warehouse.get_wh_inventory_by_inventory_id(wh_inventory_id)
        @@logger.info("#{self}.get_wh_inventory_by_inventory_id, wh_inventory_id=#{wh_inventory_id}")
        @@dao_wh_inventory.func_get_by_wh_inventory_id(wh_inventory_id)
      end

      def Model_Warehouse.get_wh_inventories_by_inventory_type(wh_inventory_type)
        @@logger.info("#{self}.get_wh_inventories_by_inventory_type, wh_inventory_type=#{wh_inventory_type}")
        begin
          items = @@dao_wh_inventory.func_get_all_by_inventory_type(wh_inventory_type)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventories_by_inventory_type, wh_inventory_type=#{wh_inventory_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_inventories_by_type_ids(wh_inventory_type,id_arr)
        @@logger.info("#{self}.get_all_wh_inventories_by_type_ids")
        begin
          items = @@dao_sql_warehouse.select_all_inventories_by_type_and_ids(wh_inventory_type,id_arr)
          arr = []
          if items
            items.each {|row|
              arr << row
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_inventories_by_type_ids Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_inventories
        @@logger.info("#{self}.get_all_wh_inventories")
        begin
          items = @@dao_wh_inventory.func_get_all
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_inventories Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_max_wh_inventory_id_by_type(wh_inventory_type)
        @@logger.info("#{self}.get_max_wh_inventory_id_by_type")
        begin
          @@dao_sql_warehouse.select_max_wh_inventory_id_by_type(wh_inventory_type)
        rescue Exception => e
          @@logger.error("#{self}.get_max_wh_inventory_id_by_type Exception:#{e}")
          nil
        end
      end

      # ====== wh_inventory_batch
      @@wh_inventory_batch = YDAPI::BizEntity::WHInventoryBatch
      @@dao_wh_inventory_batch = YDAPI::BizModel::DBModel::DAO_WHInventoryBatch

      def Model_Warehouse.add_wh_inventory_batch(wh_inventory_batch)
        @@_common_model_func.common_add(
            @@wh_inventory_batch,
            wh_inventory_batch,
            @@dao_wh_inventory_batch,
            @@logger,
            self,
            'add_wh_inventory_batch'
        )
      end

      def Model_Warehouse.delete_wh_inventory_batch_by_inventory_batch_id(wh_inventory_batch_id)
        @@logger.info("#{self}.delete_wh_inventory_batch_by_inventory_batch_id(#{wh_inventory_batch_id})")
        @@dao_wh_inventory_batch.func_delete_by_wh_inventory_batch_id(wh_inventory_batch_id)
      end

      def Model_Warehouse.update_wh_inventory_batch(wh_inventory_batch)
        @@logger.info("#{self}.update_wh_inventory_batch_id, wh_inventory_batch_id=#{wh_inventory_batch.wh_inventory_batch_id}")
        @@dao_wh_inventory_batch.func_update(wh_inventory_batch)
      end

      def Model_Warehouse.get_wh_inventory_batch_by_inventory_batch_id(wh_inventory_batch_id)
        @@logger.info("#{self}.get_wh_inventory_batch_by_inventory_batch_id, wh_inventory_batch_id=#{wh_inventory_batch_id}")
        @@dao_wh_inventory_batch.func_get_by_wh_inventory_batch_id(wh_inventory_batch_id)
      end

      def Model_Warehouse.get_wh_inventory_batches_by_inventory_type(wh_inventory_type)
        @@logger.info("#{self}.get_wh_inventory_batches_by_inventory_type, wh_inventory_type=#{wh_inventory_type}")
        begin
          items = @@dao_wh_inventory_batch.func_get_all_by_inventory_type(wh_inventory_type)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventory_batches_by_inventory_type, wh_inventory_type=#{wh_inventory_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_wh_inventory_batches_by_inventory_type_batch_type(wh_inventory_type, batch_type)
        @@logger.info("#{self}.get_wh_inventory_batches_by_inventory_type_batch_type, wh_inventory_type=#{wh_inventory_type}")
        begin
          items = @@dao_wh_inventory_batch.func_get_all_by_inventory_type_and_batch_type(wh_inventory_type, batch_type)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventory_batches_by_inventory_type, wh_inventory_type=#{wh_inventory_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_wh_inventory_batches_by_batch_type(batch_type)
        @@logger.info("#{self}.get_wh_inventory_batches_by_batch_type, batch_type=#{batch_type}")
        begin
          items = @@dao_wh_inventory_batch.func_get_all_by_batch_type(batch_type)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventory_batches_by_inventory_type, wh_inventory_type=#{wh_inventory_type} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_wh_inventory_batches_by_inventory_id(wh_inventory_id)
        @@logger.info("#{self}.get_wh_inventory_batches_by_inventory_id, wh_inventory_id=#{wh_inventory_id}")
        begin
          items = @@dao_wh_inventory_batch.func_get_all_by_inventory_id(wh_inventory_id)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventory_batches_by_inventory_id, wh_inventory_id=#{wh_inventory_id} Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_all_wh_inventory_batches
        @@logger.info("#{self}.get_all_wh_inventory_batches")
        begin
          items = @@dao_wh_inventory_batch.func_get_all
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_all_wh_inventory_batches Exception:#{e}")
          nil
        end
      end

      # ====== wh_inventory_history
      @@wh_inventory_history = YDAPI::BizEntity::WHInventoryHistory
      @@dao_wh_inventory_history = YDAPI::BizModel::DBModel::DAO_WHInventoryHistory

      def Model_Warehouse.add_wh_inventory_history(wh_inventory_history)
        @@_common_model_func.common_add(
            @@wh_inventory_history,
            wh_inventory_history,
            @@dao_wh_inventory_history,
            @@logger,
            self,
            'add_wh_inventory_history'
        )
      end

      def Model_Warehouse.delete_wh_inventory_history_by_history_id(history_id)
        @@logger.info("#{self}.delete_wh_inventory_history_by_history_id(#{history_id})")
        @@dao_wh_inventory_history.func_delete_by_history_id(history_id)
      end

      def Model_Warehouse.update_wh_inventory_history(wh_inventory_history)
        @@logger.info("#{self}.update_wh_inventory_history_id, history_id=#{wh_inventory_history.history_id}")
        @@dao_wh_inventory_history.func_update(wh_inventory_history)
      end

      def Model_Warehouse.get_wh_inventory_history_by_history_id(history_id)
        @@logger.info("#{self}.get_wh_inventory_history_by_history_id, history_id=#{history_id}")
        @@dao_wh_inventory_history.func_get_by_history_id(history_id)
      end

      def Model_Warehouse.get_wh_inventory_histories_by_inventory_id(wh_inventory_id)
        @@logger.info("#{self}.get_wh_inventory_histories_by_inventory_id, wh_inventory_id=#{wh_inventory_id}")
        begin
          items = @@dao_wh_inventory_history.func_get_all_by_inventory_id(wh_inventory_id)
          arr = []
          if items
            items.each {|row|
              arr << row.values
            }
            arr
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_inventory_histories_by_inventory_id, wh_inventory_id=#{wh_inventory_id} Exception:#{e}")
          nil
        end
      end

      # ====== wh_out_record related
      @@wh_out_record = YDAPI::BizEntity::WHOutRecord
      @@wh_out_record_history = YDAPI::BizEntity::WHOutRecordHistory
      @@wh_out_record_item = YDAPI::BizEntity::WHOutRecordItem

      @@dao_wh_out_record = YDAPI::BizModel::DBModel::DAO_WHOutRecord
      @@dao_wh_out_record_history = YDAPI::BizModel::DBModel::DAO_WHOutRecordHistory
      @@dao_wh_out_record_item = YDAPI::BizModel::DBModel::DAO_WHOutRecordItem

      def Model_Warehouse.add_wh_out_record(wh_out_record, items_arr)
        begin
          if @@_common_model_func.common_add(
              @@wh_out_record,
              wh_out_record,
              @@dao_wh_out_record,
              @@logger,
              self,
              'add_wh_out_record'
          ) != nil
            items_arr.each {|item|
              begin
                if @@_common_model_func.common_add(
                    @@wh_out_record_item,
                    item,
                    @@dao_wh_out_record_item,
                    @@logger,
                    self,
                    'add_wh_out_record item'
                )
                  @@dao_wh_inventory.func_update_count_in_or_out(
                      item.wh_inventory_id, item.packing_count, item.auxiliary_count, 'out')

                  hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                  hist_obj.created_by = item.created_by
                  hist_obj.last_update_by = item.last_update_by
                  hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                  hist_obj.wh_inventory_id = item.wh_inventory_id
                  hist_obj.history_type = 'outbound'
                  hist_obj.count_diff = item.packing_count
                  hist_obj.auxiliary_count_diff = item.auxiliary_count
                  hist_obj.unit_price_diff = 0
                  hist_obj.wh_inventory_batch_id = wh_out_record.wh_out_record_id

                  @@_common_model_func.common_add(
                      @@wh_inventory_history,
                      hist_obj,
                      @@dao_wh_inventory_history,
                      @@logger,
                      self,
                      'add_wh_out_record item history'
                  )
                end
              rescue Exception => e
                @@logger.error("#{self}.add_wh_out_record item Exception:#{e}")
                nil
              end
            }
            history = YDAPI::BizEntity::WHOutRecordHistory.new
            history.history_type = 'add'
            history.created_by = wh_out_record.created_by
            history.last_update_by = wh_out_record.last_update_by
            history.wh_out_record_id = wh_out_record.wh_out_record_id
            history.wh_out_record_status = wh_out_record.wh_out_record_status
            history.ship_to_name = wh_out_record.ship_to_name
            history.ship_to_address = wh_out_record.ship_to_address
            history.ship_to_phone_number = wh_out_record.ship_to_phone_number
            history.ship_to_user = wh_out_record.ship_to_user
            history.order_id = wh_out_record.order_id
            history.item_count = wh_out_record.item_count
            history.item_total_price = wh_out_record.item_total_price
            history.salesman = wh_out_record.salesman
            history.delivery_by = wh_out_record.delivery_by
            history.other = wh_out_record.other
            @@dao_wh_out_record_history.func_add(history)
            true
          else
            @@logger.error("#{self}.add_wh_out_record error#{wh_out_record}")
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.add_wh_out_record Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.update_wh_out_record(wh_out_record, items_arr)
        @@logger.info("#{self}.update_wh_out_record, wh_out_record_id=#{wh_out_record.wh_out_record_id}")
        begin
          if @@dao_wh_out_record.func_update(wh_out_record)
            items_arr.each {|item|
              begin
                existed_item = @@dao_wh_out_record_item.func_is_existed(item.wh_out_record_id, item.wh_inventory_id)
                count_diff = item.packing_count
                auxiliary_count_diff = item.auxiliary_count

                tmp = nil
                if existed_item
                  tmp = @@dao_wh_out_record_item.func_update(item)
                  count_diff -= existed_item[:packing_count]
                  auxiliary_count_diff -= existed_item[:auxiliary_count]
                else
                  tmp = @@_common_model_func.common_add(
                      @@wh_out_record_item,
                      item,
                      @@dao_wh_out_record_item,
                      @@logger,
                      self,
                      'update_wh_out_record item'
                  )
                end
                if tmp
                  @@dao_wh_inventory.func_update_count_in_or_out(
                      item.wh_inventory_id, count_diff, auxiliary_count_diff, 'out')
                  hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                  hist_obj.created_by = item.created_by
                  hist_obj.last_update_by = item.last_update_by
                  hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                  hist_obj.wh_inventory_id = item.wh_inventory_id
                  hist_obj.history_type = 'outbound'
                  hist_obj.count_diff = count_diff
                  hist_obj.auxiliary_count_diff = auxiliary_count_diff
                  hist_obj.unit_price_diff = 0
                  hist_obj.wh_inventory_batch_id = wh_out_record.wh_out_record_id

                  @@_common_model_func.common_add(
                      @@wh_inventory_history,
                      hist_obj,
                      @@dao_wh_inventory_history,
                      @@logger,
                      self,
                      'update_wh_out_record item history'
                  )
                end
              rescue Exception => e
                @@logger.error("#{self}.update_wh_out_record item Exception:#{e}")
                return nil
              end
            }
            history = YDAPI::BizEntity::WHOutRecordHistory.new
            history.history_type = 'update'
            history.created_by = wh_out_record.created_by
            history.last_update_by = wh_out_record.last_update_by
            history.wh_out_record_id = wh_out_record.wh_out_record_id
            history.wh_out_record_status = wh_out_record.wh_out_record_status
            history.ship_to_name = wh_out_record.ship_to_name
            history.ship_to_address = wh_out_record.ship_to_address
            history.ship_to_phone_number = wh_out_record.ship_to_phone_number
            history.ship_to_user = wh_out_record.ship_to_user
            history.order_id = wh_out_record.order_id
            history.item_count = wh_out_record.item_count
            history.item_total_price = wh_out_record.item_total_price
            history.salesman = wh_out_record.salesman
            history.delivery_by = wh_out_record.delivery_by
            history.other = wh_out_record.other
            @@dao_wh_out_record_history.func_add(history)
            true
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.update_wh_out_record Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.update_wh_out_record_status(wh_out_record_id, new_status)
        @@logger.info("#{self}.update_wh_out_record_status, wh_out_record_id=#{wh_out_record_id},new_status=#{new_status}")
        begin
          wh_out_record=@@dao_wh_out_record.func_update_status(wh_out_record_id,new_status)
          if wh_out_record
            history = YDAPI::BizEntity::WHOutRecordHistory.new
            history.history_type = 'update_status'
            history.created_by = wh_out_record.created_by
            history.last_update_by = wh_out_record.last_update_by
            history.wh_out_record_id = wh_out_record.wh_out_record_id
            history.wh_out_record_status = wh_out_record.wh_out_record_status
            history.ship_to_name = wh_out_record.ship_to_name
            history.ship_to_address = wh_out_record.ship_to_address
            history.ship_to_phone_number = wh_out_record.ship_to_phone_number
            history.ship_to_user = wh_out_record.ship_to_user
            history.order_id = wh_out_record.order_id
            history.item_count = wh_out_record.item_count
            history.item_total_price = wh_out_record.item_total_price
            history.salesman = wh_out_record.salesman
            history.delivery_by = wh_out_record.delivery_by
            history.other = wh_out_record.other
            @@dao_wh_out_record_history.func_add(history)
            true
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.update_wh_out_record_status Exception:#{e}")
          nil
        end
      end
      def Model_Warehouse.get_wh_out_record_by_id(wh_out_record_id)
        @@logger.info("#{self}.get_wh_out_record_by_id, wh_out_record_id=#{wh_out_record_id}")
        begin
          wh_out_record = @@dao_wh_out_record.func_get_by_wh_out_record_id(wh_out_record_id)
          if wh_out_record
            items = @@dao_wh_out_record_item.func_get_all_by_wh_out_record_id(wh_out_record_id)
            if items
              items_arr = []
              items.each {|row|
                items_arr << row.values
              }
              {
                  :wh_out_record => wh_out_record.values,
                  :items => items_arr
              }
            else
              nil
            end
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_out_record_by_id(#{wh_out_record_id}) Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_wh_out_records_all
        @@logger.info("#{self}.get_wh_out_records_all")
        begin
          wh_out_records = @@dao_wh_out_record.func_get_all
          result = []
          if wh_out_records
            wh_out_records.each {|row|
              result << row.values
            }
            {:wh_out_records => result}
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_wh_out_records_all Exception:#{e}")
          nil
        end
      end

      def Model_Warehouse.get_max_wh_out_record_id
        @@logger.info("#{self}.get_max_wh_out_record_id")
        @@dao_wh_out_record.func_get_max_wh_out_record_id
      end
    end
  end
end