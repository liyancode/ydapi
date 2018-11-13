module YDAPI
  module BizModel
    module DBModel
      class InventoryTypes < Sequel::Model(:inventory_types)
        @@logger=BIZ_MODEL_LOGGER
        def InventoryTypes.func_add(inventory_type)
          begin
            InventoryTypes.create do |item|
              item.inventory_type_parent=inventory_type.inventory_type_parent
              item.inventory_type_id=inventory_type.inventory_type_id
              item.inventory_type_name=inventory_type.inventory_type_name
              item.description=inventory_type.description
              item.added_by_user_name=inventory_type.added_by_user_name
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{inventory_type}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_delete(inventory_type_id)
          begin
            InventoryTypes[inventory_type_id: inventory_type_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{inventory_type_id}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_update(inventory_type)
          begin
            exist_item=InventoryTypes[inventory_type_id: inventory_type.inventory_type_id]
            new_item=exist_item.update(
                inventory_type_parent:inventory_type.inventory_type_parent,
                inventory_type_name:inventory_type.inventory_type_name,
                description:inventory_type.description
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{inventory_type}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_get(inventory_type_id)
          begin
            InventoryTypes[inventory_type_id: inventory_type_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{inventory_type_id}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_get_by_id(id)
          begin
            InventoryTypes[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_get_all_by_inventory_type_parent(inventory_type_parent)
          begin
            InventoryTypes.dataset.where(inventory_type_parent:inventory_type_parent).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def InventoryTypes.func_get_max_inventory_type_id
          begin
            InventoryTypes.last.inventory_type_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_inventory_type_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end