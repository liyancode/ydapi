module YDAPI
  module BizModel
    class InventoriesModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@inventory = YDAPI::BizEntity::Inventory

      @@inventorys = YDAPI::BizModel::DBModel::Inventories

      def InventoriesModel.add_new_inventory(inventory)
        if inventory.is_a?(@@inventory)
          new_id = @@helper.new_step1_id(@@inventorys.func_get_max_inventory_id)
          if new_id != nil
            inventory.inventory_id = new_id
            @@logger.info("#{self}.add_new_inventory, inventory=#{inventory}")
            @@inventorys.func_add(inventory)
          else
            @@logger.error("#{self}.add_new_inventory, get_max_inventory_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_inventory, inventory is not a #{@@inventory}")
          nil
        end
      end

      def InventoriesModel.delete_inventory_by_inventory_id(inventory_id)
        @@logger.info("#{self}.delete_inventory_by_inventory_id(#{inventory_id})")
        @@inventorys.func_delete(inventory_id)
      end

      def InventoriesModel.update_inventory(inventory)
        @@logger.info("#{self}.update_inventory, inventory=#{inventory}")
        @@inventorys.func_update(inventory)
      end

      def InventoriesModel.get_inventorys_by_user_name(user_name)
        @@logger.info("#{self}.get_inventorys_by_user_name(#{user_name})")
        inventorys = @@inventorys.func_get_all_by_user_name(user_name)
        if inventorys
          inventorys_array = []
          inventorys.each {|row|
            inventorys_array << row.values
          }
          {:inventorys => inventorys_array}
        else
          nil
        end
      end

      def InventoriesModel.get_inventory_by_inventory_id(inventory_id)
        @@logger.info("#{self}.get_inventory_by_inventory_id(#{inventory_id})")
        inventory = @@inventorys.func_get(inventory_id)
        if inventory
          inventory.values
        else
          nil
        end
      end
    end
  end
end