module YDAPI
  module BizModel
    class InventoriesModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@inventory = YDAPI::BizEntity::Inventory

      @@inventories = YDAPI::BizModel::DBModel::Inventories
      @@inventory_types= YDAPI::BizModel::DBModel::InventoryTypes

      def InventoriesModel.add_new_inventory(inventory)
        if inventory.is_a?(@@inventory)
          new_id = @@helper.new_step1_id(@@inventories.func_get_max_inventory_id)
          if new_id != nil
            inventory.inventory_id = new_id
            @@logger.info("#{self}.add_new_inventory, inventory=#{inventory}")
            @@inventories.func_add(inventory)
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
        @@inventories.func_delete(inventory_id)
      end

      def InventoriesModel.update_inventory(inventory)
        @@logger.info("#{self}.update_inventory, inventory=#{inventory}")
        @@inventories.func_update(inventory)
      end

      def InventoriesModel.get_inventories_by_user_name(user_name)
        @@logger.info("#{self}.get_inventories_by_user_name(#{user_name})")
        inventories = @@inventories.func_get_all_by_user_name(user_name)
        if inventories
          inventories_array = []
          inventories.each {|row|
            inventories_array << row.values
          }
          {:inventories => inventories_array}
        else
          nil
        end
      end

      def InventoriesModel.get_inventories_by_type_id(inventory_type_id)
        @@logger.info("#{self}.get_inventories_by_type_id(#{inventory_type_id})")
        inventories = @@inventories.func_get_all_by_type_id(inventory_type_id)
        if inventories
          inventories_array = []
          inventories.each {|row|
            inventories_array << row.values
          }
          {:inventories => inventories_array}
        else
          nil
        end
      end

      def InventoriesModel.get_inventory_by_inventory_id(inventory_id)
        @@logger.info("#{self}.get_inventory_by_inventory_id(#{inventory_id})")
        inventory = @@inventories.func_get(inventory_id)
        if inventory
          inventory.values
        else
          nil
        end
      end

      # --原料raw_material、半成品semifinished_product、成品product
      def InventoriesModel.get_inventories_by_type_parent(type_parent)
        @@logger.info("#{self}.get_inventories_by_type_parent(#{type_parent})")
        types=@@inventory_types.func_get_all_by_inventory_type_parent(type_parent)
        if types
        	type_id_arr=[]
        	types.each{|row|
        		type_id_arr<<row[:inventory_type_id]
        	}
        	inventories = @@inventories.func_get_all_by_type_id_arr(type_id_arr)
            if inventories
                inventories_array = []
                inventories.each {|row|
                    inventories_array << row.values
                }
                {:inventories => inventories_array}
            else
                nil
            end
        else
        	nil
        end
      end

      def InventoriesModel.get_inventory_types_by_type_parent(type_parent)
        @@logger.info("#{self}.get_inventory_types_by_type_parent(#{type_parent})")
        inventory_types = @@inventory_types.func_get_all_by_inventory_type_parent(type_parent)
        if inventory_types
          inventory_types_array = []
          inventory_types.each {|row|
            inventory_types_array << row.values
          }
          {:inventory_types => inventory_types_array}
        else
          nil
        end
      end
    end
  end
end