module YDAPI
  module BizModel
    module DBModel
      class DAO_WHOutRecordHistory < Sequel::Model(:wh_out_record_history)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_WHOutRecordHistory.func_add(wh_out_record_history)
          begin
            DAO_WHOutRecordHistory.create do |obj|
              obj.created_by = wh_out_record_history.created_by
              obj.last_update_by = wh_out_record_history.last_update_by
              obj.comment = wh_out_record_history.comment

              obj.history_type = wh_out_record_history.history_type
              obj.wh_out_record_id = wh_out_record_history.wh_out_record_id
              obj.wh_out_record_status = wh_out_record_history.wh_out_record_status
              obj.ship_to_name = wh_out_record_history.ship_to_name
              obj.ship_date = wh_out_record_history.ship_date
              obj.ship_to_address = wh_out_record_history.ship_to_address
              obj.ship_to_phone_number = wh_out_record_history.ship_to_phone_number
              obj.ship_to_user = wh_out_record_history.ship_to_user
              obj.order_id = wh_out_record_history.order_id
              obj.item_count = wh_out_record_history.item_count
              obj.item_total_price = wh_out_record_history.item_total_price
              obj.salesman = wh_out_record_history.salesman
              obj.delivery_by = wh_out_record_history.delivery_by
              obj.other = wh_out_record_history.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_out_record_history.wh_out_record_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordHistory.func_get_all_by_wh_out_record_id(wh_out_record_id)
          begin
            DAO_WHOutRecordHistory.dataset.where(wh_out_record_id:wh_out_record_id).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_wh_out_record_id Exception:#{e}")
            nil
          end
        end

        def DAO_WHOutRecordHistory.func_get_all_by_wh_out_record_id_created_by(wh_out_record_id,created_by)
          begin
            DAO_WHOutRecordHistory.dataset.where(wh_out_record_id:wh_out_record_id).where(created_by:created_by).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_wh_out_record_id_created_by Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end