module YDAPI
  module BizModel
    module DBModel
      class DAO_WHOutRecord < Sequel::Model(:wh_out_record)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHOutRecord.func_add(wh_out_record)
          begin
            DAO_WHOutRecord.create do |obj|
              obj.created_by = wh_out_record.created_by
              obj.last_update_by = wh_out_record.last_update_by
              obj.comment = wh_out_record.comment

              obj.wh_out_record_id = wh_out_record.wh_out_record_id
              obj.wh_out_record_status = wh_out_record.wh_out_record_status
              obj.ship_to_name = wh_out_record.ship_to_name
              obj.ship_date = wh_out_record.ship_date
              obj.ship_to_address = wh_out_record.ship_to_address
              obj.ship_to_phone_number = wh_out_record.ship_to_phone_number
              obj.ship_to_user = wh_out_record.ship_to_user
              obj.order_id = wh_out_record.order_id
              obj.item_count = wh_out_record.item_count
              obj.item_total_price = wh_out_record.item_total_price
              obj.salesman = wh_out_record.salesman
              obj.delivery_by = wh_out_record.delivery_by
              obj.other = wh_out_record.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_out_record.wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_delete_by_wh_out_record_id(wh_out_record_id)
          begin
            DAO_WHOutRecord[wh_out_record_id: wh_out_record_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete_by_wh_out_record_id(#{wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_update(wh_out_record)
          begin
            exist_item=DAO_WHOutRecord[wh_out_record_id: wh_out_record.wh_out_record_id]
            new_item=exist_item.update(
                last_update_by: wh_out_record.last_update_by,
                comment: wh_out_record.comment,

                wh_out_record_status: wh_out_record.wh_out_record_status,
                ship_to_name: wh_out_record.ship_to_name,
                ship_date: wh_out_record.ship_date,
                ship_to_address: wh_out_record.ship_to_address,
                ship_to_phone_number: wh_out_record.ship_to_phone_number,
                ship_to_user: wh_out_record.ship_to_user,
                order_id: wh_out_record.order_id,
                item_count: wh_out_record.item_count,
                item_total_price: wh_out_record.item_total_price,
                salesman: wh_out_record.salesman,
                delivery_by: wh_out_record.delivery_by,
                other: wh_out_record.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_out_record.wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_update_status(wh_out_record_id,new_status)
          begin
            exist_item=DAO_WHOutRecord[wh_out_record_id: wh_out_record_id]
            new_item=exist_item.update(
                wh_out_record_status: new_status
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_status(#{wh_out_record_id},#{new_status}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_get_by_wh_out_record_id(wh_out_record_id)
          begin
            DAO_WHOutRecord[wh_out_record_id: wh_out_record_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_wh_out_record_id(#{wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_get_all
          begin
            DAO_WHOutRecord.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_get_all_by_created_by(created_by)
          begin
            DAO_WHOutRecord.dataset.where(status:1).where(created_by:created_by).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_created_by Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_get_all_by_salesman(salesman)
          begin
            DAO_WHOutRecord.dataset.where(status:1).where(salesman:salesman).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_salesman Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecord.func_get_max_wh_out_record_id
          begin
            DAO_WHOutRecord.last.wh_out_record_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_wh_out_record_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end