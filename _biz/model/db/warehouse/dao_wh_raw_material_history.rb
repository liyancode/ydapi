module YDAPI
  module BizModel
    module DBModel
      class DAO_WHRawMaterialHistory < Sequel::Model(:wh_raw_material_history)
        @@logger = BIZ_MODEL_LOGGER

        def DAO_WHRawMaterialHistory.func_add(wh_raw_material_history)
          begin
            DAO_WHRawMaterialHistory.create do |obj|
              obj.created_by = wh_raw_material_history.created_by
              obj.last_update_by = wh_raw_material_history.last_update_by
              obj.comment = wh_raw_material_history.comment

              obj.wh_id = wh_raw_material_history.wh_id
              obj.wh_id_sub = wh_raw_material_history.wh_id_sub
              obj.record_type = wh_raw_material_history.record_type
              obj.update_what = wh_raw_material_history.update_what
              obj.order_contract_id = wh_raw_material_history.order_contract_id
              obj.inbound_count = (wh_raw_material_history.inbound_count == nil) ? 0 : wh_raw_material_history.inbound_count
              obj.inbound_weight = (wh_raw_material_history.inbound_weight == nil) ? 0 : wh_raw_material_history.inbound_weight
              obj.inbound_unit_price = (wh_raw_material_history.inbound_unit_price == nil) ? 0 : wh_raw_material_history.inbound_unit_price
              obj.inbound_total_price = (wh_raw_material_history.inbound_total_price == nil) ? 0 : wh_raw_material_history.inbound_total_price
              obj.inbound_from = wh_raw_material_history.inbound_from
              obj.inbound_principal = wh_raw_material_history.inbound_principal
              obj.inbound_at = (wh_raw_material_history.inbound_at == nil) ? Time.now : wh_raw_material_history.inbound_at
              obj.outbound_count = (wh_raw_material_history.outbound_count == nil) ? 0 : wh_raw_material_history.outbound_count
              obj.outbound_weight = (wh_raw_material_history.outbound_weight == nil) ? 0 : wh_raw_material_history.outbound_weight
              obj.outbound_unit_price = (wh_raw_material_history.outbound_unit_price == nil) ? 0 : wh_raw_material_history.outbound_unit_price
              obj.outbound_total_price = (wh_raw_material_history.outbound_total_price == nil) ? 0 : wh_raw_material_history.outbound_total_price
              obj.outbound_to = wh_raw_material_history.outbound_to
              obj.outbound_principal = wh_raw_material_history.outbound_principal
              obj.outbound_at = (wh_raw_material_history.outbound_at == nil) ? Time.now : wh_raw_material_history.outbound_at
              obj.other = wh_raw_material_history.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{wh_raw_material_history.wh_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_delete(id)
          begin
            DAO_WHRawMaterialHistory[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_update(wh_raw_material_history)
          begin
            exist_item = DAO_WHRawMaterialHistory[id: wh_raw_material_history.id]
            new_item = exist_item.update(
                last_update_by: wh_raw_material_history.last_update_by,
                comment: wh_raw_material_history.comment,
                wh_id: wh_raw_material_history.wh_id,
                wh_id_sub: wh_raw_material_history.wh_id_sub,
                record_type: wh_raw_material_history.record_type,
                update_what: wh_raw_material_history.update_what,
                order_contract_id: wh_raw_material_history.order_contract_id,
                inbound_count: wh_raw_material_history.inbound_count,
                inbound_weight: wh_raw_material_history.inbound_weight,
                inbound_unit_price: wh_raw_material_history.inbound_unit_price,
                inbound_total_price: wh_raw_material_history.inbound_total_price,
                inbound_from: wh_raw_material_history.inbound_from,
                inbound_principal: wh_raw_material_history.inbound_principal,
                inbound_at: wh_raw_material_history.inbound_at,
                outbound_count: wh_raw_material_history.outbound_count,
                outbound_weight: wh_raw_material_history.outbound_weight,
                outbound_unit_price: wh_raw_material_history.outbound_unit_price,
                outbound_total_price: wh_raw_material_history.outbound_total_price,
                outbound_to: wh_raw_material_history.outbound_to,
                outbound_principal: wh_raw_material_history.outbound_principal,
                outbound_at: wh_raw_material_history.outbound_at,
                other: wh_raw_material_history.other
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{wh_raw_material_history.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get(id)
          begin
            DAO_WHRawMaterialHistory[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get_all_by_wh_id(wh_id)
          begin
            DAO_WHRawMaterialHistory.dataset.where(wh_id: wh_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_one_rm(#{wh_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get_all_by_wh_id_sub(wh_id_sub)
          begin
            DAO_WHRawMaterialHistory.dataset.where(wh_id_sub: wh_id_sub).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_wh_id_sub(#{wh_id_sub}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get_all_by_wh_id_and_type(wh_id, type)
          begin
            DAO_WHRawMaterialHistory.dataset.where(wh_id: wh_id).where(record_type: type).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_one_rm(#{wh_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get_all_by_record_type(record_type)
          begin
            DAO_WHRawMaterialHistory.dataset.where(record_type: record_type).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_record_type(#{record_type}) Exception:#{e}")
            nil
          end
        end

        def DAO_WHRawMaterialHistory.func_get_all
          begin
            DAO_WHRawMaterialHistory.dataset.where(status: 1).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end