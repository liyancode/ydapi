module YDAPI
  module BizModel
    module DBModel
      class DAO_WHInventoryHistory < Sequel::Model(:wh_inventory_history)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHInventoryHistory.func_add(wh_inventory_history)
          begin
            DAO_WHInventoryHistory.create do |obj|
              obj.created_by = wh_inventory_history.created_by
              obj.last_update_by = wh_inventory_history.last_update_by
              obj.comment = wh_inventory_history.comment

              obj.history_id = wh_inventory_history.history_id
              obj.wh_inventory_id = wh_inventory_history.wh_inventory_id
              obj.history_type = wh_inventory_history.history_type
              obj.count_diff = wh_inventory_history.count_diff
              obj.auxiliary_count_diff = wh_inventory_history.auxiliary_count_diff
              obj.unit_price_diff = wh_inventory_history.unit_price_diff
              obj.wh_inventory_batch_id = wh_inventory_history.wh_inventory_batch_id
              obj.other = wh_inventory_history.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_inventory_history}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryHistory.func_delete_by_history_id(history_id)
          begin
            DAO_WHInventoryHistory[history_id: history_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_history_id(#{history_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryHistory.func_update(wh_inventory_history)
          begin
            exist_item=DAO_WHInventoryHistory[history_id: wh_inventory_history.history_id]
            new_item=exist_item.update(
                last_update_by: wh_inventory_history.last_update_by,
                comment: wh_inventory_history.comment,

                history_type: wh_inventory_history.history_type,
                count_diff: wh_inventory_history.count_diff,
                auxiliary_count_diff: wh_inventory_history.auxiliary_count_diff,
                unit_price_diff: wh_inventory_history.unit_price_diff,
                wh_inventory_batch_id: wh_inventory_history.wh_inventory_batch_id,
                other: wh_inventory_history.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_inventory_history.history_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryHistory.func_get_by_history_id(history_id)
          begin
            DAO_WHInventoryHistory[history_id: history_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_history_id(#{history_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventoryHistory.func_get_all_by_inventory_id(wh_inventory_id)
          begin
            DAO_WHInventoryHistory.dataset.where(wh_inventory_id:wh_inventory_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_inventory_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end