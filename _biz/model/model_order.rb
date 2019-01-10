module YDAPI
  module BizModel
    class Model_Order
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@_common_model_func = YDAPI::BizModel::CommonModelFunc

      # ====== order_contract
      @@order_contract = YDAPI::BizEntity::OrderContract
      @@dao_order_contract = YDAPI::BizModel::DBModel::DAO_OrderContract

      # order_contract
      def Model_Order.add_order_contract(order_contract)
        @@_common_model_func.common_add(
            @@order_contract,
            order_contract,
            @@dao_order_contract,
            @@logger,
            self,
            'add_order_contract'
        )
      end

      def Model_Order.delete_order_contract_by_contract_id(contract_id)
        @@logger.info("#{self}.delete_order_contract_by_contract_id(#{contract_id})")
        @@dao_order_contract.func_delete(contract_id)
      end

      def Model_Order.update_order_contract(order_contract)
        @@logger.info("#{self}.update_order_contract, contract_id=#{order_contract.contract_id}")
        @@dao_order_contract.func_update(order_contract)
      end

      def Model_Order.get_order_contract_by_contract_id(contract_id)
        @@logger.info("#{self}.get_order_contract_by_contract_id, contract_id=#{contract_id}")
        @@dao_order_contract.func_get_by_contract_id(contract_id)
      end

      def Model_Order.get_all_order_contract_by_a_customer_id(a_customer_id)
        @@logger.info("#{self}.get_all_order_contract_by_a_customer_id, a_customer_id=#{a_customer_id}")
        @@dao_order_contract.func_get_all_to_one_a_customer(a_customer_id)
      end

      # ====== order_contract_product_item_fengguan
      @@order_contract_product_item_fengguan = YDAPI::BizEntity::OrderContractProductItemFengguan
      @@dao_order_contract_product_item_fengguan = YDAPI::BizModel::DBModel::DAO_OrderContractProductItemFengguan

      # order_contract_product_item_fengguan
      def Model_Order.add_order_contract_product_item_fengguan(order_contract_product_item_fengguan)
        @@_common_model_func.common_add(
            @@order_contract_product_item_fengguan,
            order_contract_product_item_fengguan,
            @@dao_order_contract_product_item_fengguan,
            @@logger,
            self,
            'add_order_contract_product_item_fengguan'
        )
      end

      def Model_Order.delete_order_contract_product_item_fengguan_by_id(id)
        @@logger.info("#{self}.delete_order_contract_product_item_fengguan_by_id(#{id})")
        @@dao_order_contract_product_item_fengguan.func_delete(id)
      end

      def Model_Order.update_order_contract_product_item_fengguan(order_contract_product_item_fengguan)
        @@logger.info("#{self}.update_order_contract_product_item_fengguan, contract_id=#{order_contract_product_item_fengguan.contract_id}")
        @@dao_order_contract_product_item_fengguan.func_update(order_contract_product_item_fengguan)
      end

      def Model_Order.get_order_contract_product_item_fengguans_by_contract_id(contract_id)
        @@logger.info("#{self}.get_order_contract_product_item_fengguans_by_contract_id, contract_id=#{contract_id}")
        begin
          items=@@dao_order_contract_product_item_fengguan.func_get_all_to_one_contract(contract_id)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_order_contract_product_item_fengguans_by_contract_id, contract_id=#{contract_id} Exception:#{e}")
          nil
        end
      end

      def Model_Order.get_order_contract_product_item_fengguan_by_id(id)
        @@logger.info("#{self}.get_order_contract_product_item_fengguan_by_id, id=#{id}")
        @@dao_order_contract_product_item_fengguan.func_get_by_id(id)
      end

      # ====== payment_history
      @@payment_history = YDAPI::BizEntity::PaymentHistory
      @@dao_payment_history = YDAPI::BizModel::DBModel::DAO_PaymentHistory

      # payment_history
      def Model_Order.add_payment_history(payment_history)
        @@_common_model_func.common_add(
            @@payment_history,
            payment_history,
            @@dao_payment_history,
            @@logger,
            self,
            'add_payment_history'
        )
      end

      def Model_Order.delete_payment_history_by_id(id)
        @@logger.info("#{self}.delete_payment_history_by_id(#{id})")
        @@dao_payment_history.func_delete(id)
      end

      def Model_Order.delete_payment_history_by_payment_id(payment_id)
        @@logger.info("#{self}.delete_payment_history_by_payment_id(#{payment_id})")
        @@dao_payment_history.func_delete_by_payment_id(payment_id)
      end

      def Model_Order.update_payment_history(payment_history)
        @@logger.info("#{self}.update_payment_history, payment_id=#{payment_history.payment_id}")
        @@dao_payment_history.func_update(payment_history)
      end

      def Model_Order.get_payment_history_by_id(id)
        @@logger.info("#{self}.get_payment_history_id, id=#{id}")
        @@dao_payment_history.func_get_by_id(id)
      end

      def Model_Order.get_payment_history_payment_id(payment_id)
        @@logger.info("#{self}.get_payment_history_payment_id, payment_id=#{payment_id}")
        @@dao_payment_history.func_get_by_payment_id(payment_id)
      end

      def Model_Order.get_payment_histories_by_contract_id(contract_id)
        @@logger.info("#{self}.get_payment_histories_by_contract_id, contract_id=#{contract_id}")
        begin
          items=@@dao_payment_history.func_get_all_to_one_contract(contract_id)
          arr=[]
          if items
            items.each{|row|
              arr<<row.values
            }
            arr
          else
            nil
          end
        rescue Exception=>e
          @@logger.error("#{self}.get_payment_histories_by_contract_id, contract_id=#{contract_id} Exception:#{e}")
          nil
        end
      end
    end
  end
end