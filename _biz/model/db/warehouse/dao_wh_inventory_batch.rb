module YDAPI
  module BizModel
    module DBModel
      class DAO_WHInventoryBatch < Sequel::Model(:wh_inventory_batch)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHInventoryBatch.func_add(wh_inventory_batch)
          begin
            DAO_WHInventoryBatch.create do |obj|
              obj.created_by = wh_inventory_batch.created_by
              obj.last_update_by = wh_inventory_batch.last_update_by
              obj.comment = wh_inventory_batch.comment

              obj.wh_inventory_batch_id = wh_inventory_batch.wh_inventory_batch_id
              obj.wh_inventory_id = wh_inventory_batch.wh_inventory_id
              obj.wh_inventory_type = wh_inventory_batch.wh_inventory_type
              obj.wh_location = wh_inventory_batch.wh_location
              obj.wh_inner_location = wh_inventory_batch.wh_inner_location
              obj.production_order_id = wh_inventory_batch.production_order_id
              obj.principal = wh_inventory_batch.principal
              obj.batch_number = wh_inventory_batch.batch_number
              obj.batch_at = wh_inventory_batch.batch_at
              obj.batch_type = wh_inventory_batch.batch_type
              obj.batch_from = wh_inventory_batch.batch_from
              obj.batch_to = wh_inventory_batch.batch_to
              obj.batch_status = wh_inventory_batch.batch_status
              obj.count = wh_inventory_batch.count
              obj.count_unit = wh_inventory_batch.count_unit
              obj.unit_price = wh_inventory_batch.unit_price
              obj.auxiliary_count = wh_inventory_batch.auxiliary_count
              obj.auxiliary_count_unit = wh_inventory_batch.auxiliary_count_unit
              obj.other = wh_inventory_batch.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_inventory_batch.wh_inventory_batch_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_delete_by_wh_inventory_batch_id(wh_inventory_batch_id)
          begin
            DAO_WHInventoryBatch[wh_inventory_batch_id: wh_inventory_batch_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_wh_inventory_batch_id(#{wh_inventory_batch_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_update(wh_inventory_batch)
          begin
            exist_item=DAO_WHInventoryBatch[wh_inventory_batch_id: wh_inventory_batch.wh_inventory_batch_id]
            new_item=exist_item.update(
                last_update_by: wh_inventory_batch.last_update_by,
                comment: wh_inventory_batch.comment,

                wh_location: wh_inventory_batch.wh_location,
                wh_inner_location: wh_inventory_batch.wh_inner_location,
                production_order_id: wh_inventory_batch.production_order_id,
                principal: wh_inventory_batch.principal,
                batch_number: wh_inventory_batch.batch_number,
                batch_at: wh_inventory_batch.batch_at,
                batch_type: wh_inventory_batch.batch_type,
                batch_from: wh_inventory_batch.batch_from,
                batch_to: wh_inventory_batch.batch_to,
                batch_status: wh_inventory_batch.batch_status,
                count: wh_inventory_batch.count,
                count_unit: wh_inventory_batch.count_unit,
                unit_price: wh_inventory_batch.unit_price,
                auxiliary_count: wh_inventory_batch.auxiliary_count,
                auxiliary_count_unit: wh_inventory_batch.auxiliary_count_unit,
                other: wh_inventory_batch.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_inventory_batch.wh_inventory_batch_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_by_wh_inventory_batch_id(wh_inventory_batch_id)
          begin
            DAO_WHInventoryBatch[wh_inventory_batch_id: wh_inventory_batch_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_wh_inventory_batch_id(#{wh_inventory_batch_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_all
          begin
            DAO_WHInventoryBatch.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_all_by_inventory_type(wh_inventory_type)
          begin
            DAO_WHInventoryBatch.dataset.where(wh_inventory_type:wh_inventory_type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_inventory_type Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_all_by_inventory_id(wh_inventory_id)
          begin
            DAO_WHInventoryBatch.dataset.where(wh_inventory_id:wh_inventory_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_inventory_id(#{wh_inventory_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_all_by_inventory_type_and_batch_type(wh_inventory_type,batch_type)
          begin
            DAO_WHInventoryBatch.dataset.where(wh_inventory_type:wh_inventory_type).where(batch_type:batch_type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_inventory_type_and_batch_type(#{wh_inventory_type}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryBatch.func_get_all_by_batch_type(batch_type)
          begin
            DAO_WHInventoryBatch.dataset.where(batch_type:batch_type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_batch_type(#{batch_type}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end