module YDAPI
  module BizModel
    module DBModel
      class Inventories < Sequel::Model(:inventories)
        @@logger=BIZ_MODEL_LOGGER
        def Inventories.func_add(inventory)
          begin
            Inventories.create do |item|
              item.inventory_id=inventory.inventory_id
              item.inventory_type_id=inventory.inventory_type_id
              item.inventory_name=inventory.inventory_name
              item.inventory_count=inventory.inventory_count
              item.inventory_unit=inventory.inventory_unit
              item.description=inventory.description
              item.added_by_user_name=inventory.added_by_user_name
              item.updated_by_user_name=inventory.updated_by_user_name
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{inventory}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_delete(inventory_id)
          begin
            Inventories[inventory_id: inventory_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{inventory_id}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_update(inventory)
          begin
            exist_item=Inventories[inventory_id: inventory.inventory_id]
            new_item=exist_item.update(
                inventory_type_id:inventory.inventory_type_id,
                inventory_name:inventory.inventory_name,
                inventory_count:inventory.inventory_count,
                inventory_unit:inventory.inventory_unit,
                description:inventory.description,
                updated_by_user_name:inventory.updated_by_user_name
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{inventory}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get(inventory_id)
          begin
            Inventories[inventory_id: inventory_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{inventory_id}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get_by_id(id)
          begin
            Inventories[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get_all_by_user_name(user_name)
          begin
            Inventories.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get_all_by_type_id(inventory_type_id)
          begin
            Inventories.dataset.where(inventory_type_id:inventory_type_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_type_id(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get_all_by_type_id_arr(inventory_type_id_arr)
          begin
            Inventories.dataset.where([[:inventory_type_id,inventory_type_id_arr]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_type_id_arr(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def Inventories.func_get_max_inventory_id
          begin
            Inventories.last.inventory_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_inventory_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end