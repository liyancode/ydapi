module YDAPI
  module BizModel
    module DBModel
      class DAO_WHOutRecordItem < Sequel::Model(:wh_out_record_item)
        @@logger = BIZ_MODEL_LOGGER

        def DAO_WHOutRecordItem.func_add(wh_out_record_item)
          begin
            DAO_WHOutRecordItem.create do |obj|
              obj.created_by = wh_out_record_item.created_by
              obj.last_update_by = wh_out_record_item.last_update_by
              obj.comment = wh_out_record_item.comment

              obj.wh_out_record_id = wh_out_record_item.wh_out_record_id
              obj.wh_inventory_id = wh_out_record_item.wh_inventory_id
              obj.name = wh_out_record_item.name
              obj.specific = wh_out_record_item.specific
              obj.packing_count = wh_out_record_item.packing_count
              obj.packing_count_unit = wh_out_record_item.packing_count_unit
              obj.auxiliary_count = wh_out_record_item.auxiliary_count
              obj.auxiliary_count_unit = wh_out_record_item.auxiliary_count_unit
              obj.unit_price = wh_out_record_item.unit_price
              obj.total_price = wh_out_record_item.total_price
              obj.other = wh_out_record_item.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_out_record_item.wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordItem.func_delete_by_id(id)
          begin
            DAO_WHOutRecordItem[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordItem.func_update(wh_out_record_item)
          begin
            exist_item = DAO_WHOutRecordItem[wh_out_record_id: wh_out_record_item.wh_out_record_id,wh_inventory_id:wh_out_record_item.wh_inventory_id]
            new_item = exist_item.update(
                last_update_by: wh_out_record_item.last_update_by,
                comment: wh_out_record_item.comment,

                packing_count: wh_out_record_item.packing_count,
                packing_count_unit: wh_out_record_item.packing_count_unit,
                auxiliary_count: wh_out_record_item.auxiliary_count,
                auxiliary_count_unit: wh_out_record_item.auxiliary_count_unit,
                unit_price: wh_out_record_item.unit_price,
                total_price: wh_out_record_item.total_price,
                other: wh_out_record_item.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_out_record_item.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordItem.func_get_all_by_wh_out_record_id(wh_out_record_id)
          begin
            DAO_WHOutRecordItem.dataset.where(wh_out_record_id: wh_out_record_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_wh_out_record_id Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordItem.func_is_existed(wh_out_record_id, wh_inventory_id)
          begin
            DAO_WHOutRecordItem.where(wh_out_record_id: wh_out_record_id).where(wh_inventory_id: wh_inventory_id).all[0]
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_wh_out_record_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end