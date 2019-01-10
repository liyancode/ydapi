module YDAPI
  module BizModel
    module DBModel
      class DAO_OrderContractProductItemFengguan < Sequel::Model(:order_contract_product_item_fengguan)
        @@logger = BIZ_MODEL_LOGGER

        def DAO_OrderContractProductItemFengguan.func_add(order_contract_product_item_fengguan)
          begin
            DAO_OrderContractProductItemFengguan.create do |c|
              c.created_by = order_contract_product_item_fengguan.created_by
              c.last_update_by = order_contract_product_item_fengguan.last_update_by
              c.comment = order_contract_product_item_fengguan.comment

              c.contract_id = order_contract_product_item_fengguan.contract_id
              c.product_id = order_contract_product_item_fengguan.product_id
              c.product_name = order_contract_product_item_fengguan.product_name
              c.item_id = order_contract_product_item_fengguan.item_id
              c.item_shape = order_contract_product_item_fengguan.item_shape
              c.measure_unit = order_contract_product_item_fengguan.measure_unit
              c.square_meter = order_contract_product_item_fengguan.square_meter
              c.unit_price_rmb = order_contract_product_item_fengguan.unit_price_rmb
              c.unit_price_usd = order_contract_product_item_fengguan.unit_price_usd
              c.item_count = order_contract_product_item_fengguan.item_count
              c.item_amount_price_rmb = order_contract_product_item_fengguan.item_amount_price_rmb
              c.item_amount_price_usd = order_contract_product_item_fengguan.item_amount_price_usd
              c.item_comment = order_contract_product_item_fengguan.item_comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{order_contract_product_item_fengguan}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContractProductItemFengguan.func_delete(id)
          begin
            DAO_OrderContractProductItemFengguan[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContractProductItemFengguan.func_update(order_contract_product_item_fengguan)
          begin
            exist_order_contract_product_item_fengguan = DAO_OrderContractProductItemFengguan[contract_id: order_contract_product_item_fengguan.contract_id]
            new_order_contract_product_item_fengguan = exist_order_contract_product_item_fengguan.update(
                last_update_by: order_contract_product_item_fengguan.last_update_by,
                comment: order_contract_product_item_fengguan.comment,

                contract_id: order_contract_product_item_fengguan.contract_id,
                product_id: order_contract_product_item_fengguan.product_id,
                product_name: order_contract_product_item_fengguan.product_name,
                item_id: order_contract_product_item_fengguan.item_id,
                item_shape: order_contract_product_item_fengguan.item_shape,
                measure_unit: order_contract_product_item_fengguan.measure_unit,
                square_meter: order_contract_product_item_fengguan.square_meter,
                unit_price_rmb: order_contract_product_item_fengguan.unit_price_rmb,
                unit_price_usd: order_contract_product_item_fengguan.unit_price_usd,
                item_count: order_contract_product_item_fengguan.item_count,
                item_amount_price_rmb: order_contract_product_item_fengguan.item_amount_price_rmb,

                item_amount_price_usd: order_contract_product_item_fengguan.item_amount_price_usd,
                item_comment: order_contract_product_item_fengguan.item_comment
            )
            if new_order_contract_product_item_fengguan
              new_order_contract_product_item_fengguan
            else
              exist_order_contract_product_item_fengguan
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{order_contract_product_item_fengguan.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContractProductItemFengguan.func_get_all_to_one_contract(contract_id)
          begin
            DAO_OrderContractProductItemFengguan.dataset.where(contract_id: contract_id).where(status: 1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_contract(#{contract_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_OrderContractProductItemFengguan.func_get_by_id(id)
          begin
            DAO_OrderContractProductItemFengguan[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

      end
    end
  end
end