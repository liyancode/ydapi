module YDAPI
  module BizModel
    module DBModel
      class DAO_WHInventory < Sequel::Model(:wh_inventory)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHInventory.func_add(wh_inventory)
          begin
            DAO_WHInventory.create do |obj|
              obj.created_by = wh_inventory.created_by
              obj.last_update_by = wh_inventory.last_update_by
              obj.comment = wh_inventory.comment

              obj.wh_inventory_id = wh_inventory.wh_inventory_id
              obj.wh_inventory_type = wh_inventory.wh_inventory_type
              obj.wh_location = wh_inventory.wh_location
              obj.wh_inner_location = wh_inventory.wh_inner_location
              obj.principal = wh_inventory.principal
              obj.name = wh_inventory.name
              obj.specification = wh_inventory.specification
              obj.description = wh_inventory.description
              obj.count = wh_inventory.count
              obj.count_unit = wh_inventory.count_unit
              obj.unit_price = wh_inventory.unit_price
              obj.auxiliary_count = wh_inventory.auxiliary_count
              obj.auxiliary_count_unit = wh_inventory.auxiliary_count_unit
              obj.other = wh_inventory.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_inventory.wh_inventory_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_delete_by_wh_inventory_id(wh_inventory_id)
          begin
            DAO_WHInventory[wh_inventory_id: wh_inventory_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_wh_inventory_id(#{wh_inventory_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_update(wh_inventory)
          begin
            exist_item=DAO_WHInventory[wh_inventory_id: wh_inventory.wh_inventory_id]
            new_item=exist_item.update(
                last_update_by: wh_inventory.last_update_by,
                comment: wh_inventory.comment,

                wh_location: wh_inventory.wh_location,
                wh_inner_location: wh_inventory.wh_inner_location,
                principal: wh_inventory.principal,
                name: wh_inventory.name,
                specification: wh_inventory.specification,
                description: wh_inventory.description,
                count: wh_inventory.count,
                count_unit: wh_inventory.count_unit,
                unit_price: wh_inventory.unit_price,
                auxiliary_count: wh_inventory.auxiliary_count,
                auxiliary_count_unit: wh_inventory.auxiliary_count_unit,
                other: wh_inventory.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_inventory.wh_inventory_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_update_count(wh_inventory_id,new_count,new_auxiliary_count)
          begin
            exist_item=DAO_WHInventory[wh_inventory_id: wh_inventory_id]
            new_item=exist_item.update(
                count: new_count,
                auxiliary_count:new_auxiliary_count
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_count(#{wh_inventory_id},#{new_count}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_update_count_in_or_out(wh_inventory_id,count_diff,auxiliary_count_diff,in_or_out)
          begin
            exist_item=DAO_WHInventory[wh_inventory_id: wh_inventory_id]
            new_count=exist_item[:count]
            new_auxiliary_count=exist_item[:auxiliary_count]
            if in_or_out=='in'
              new_count+=count_diff
              new_auxiliary_count+=auxiliary_count_diff
            elsif in_or_out=='out'
              new_count-=count_diff
              new_auxiliary_count-=auxiliary_count_diff
            end
            new_item=exist_item.update(
                count: new_count,
                auxiliary_count:new_auxiliary_count
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_count(#{wh_inventory_id},#{new_count}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_get_by_wh_inventory_id(wh_inventory_id)
          begin
            DAO_WHInventory[wh_inventory_id: wh_inventory_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_wh_inventory_id(#{wh_inventory_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_get_all
          begin
            DAO_WHInventory.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end

        def DAO_WHInventory.func_get_all_by_inventory_type(wh_inventory_type)
          begin
            DAO_WHInventory.dataset.where(wh_inventory_type:wh_inventory_type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_inventory_type Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end