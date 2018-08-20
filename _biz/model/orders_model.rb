module YDAPI
  module BizModel
    class OrdersModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@ask_price=YDAPI::BizEntity::AskPrice
      @@ask_prices=YDAPI::BizModel::DBModel::AskPrices

      @@contract=YDAPI::BizEntity::Contract
      @@contracts=YDAPI::BizModel::DBModel::Contracts

      @@order=YDAPI::BizEntity::Order
      @@orders=YDAPI::BizModel::DBModel::Orders

      # ---- ask_prices ----↓
      def OrdersModel.add_new_ask_price(ask_price)
        if ask_price.is_a?(@@ask_price)
          new_id = @@helper.new_step1_id(@@ask_prices.func_get_max_ask_price_id)
          if new_id != nil
            ask_price.ask_price_id = new_id
            @@logger.info("#{self}.add_new_ask_price, ask_price=#{ask_price}")
            @@ask_prices.func_add(ask_price)
          else
            @@logger.error("#{self}.add_new_ask_price, new_product_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_ask_price, ask_price is not a #{@@ask_price}")
          nil
        end
      end

      def OrdersModel.delete_ask_price_by_ask_price_id(ask_price_id)
        @@logger.info("#{self}.delete_ask_price_by_ask_price_id(#{ask_price_id})")
        @@ask_prices.func_delete(ask_price_id)
      end

      def OrdersModel.update_ask_price(ask_price)
        @@logger.info("#{self}.update_ask_price, ask_price=#{ask_price}")
        @@ask_prices.func_update(ask_price)
      end

      def OrdersModel.get_ask_price_by_ask_price_id(ask_price_id)
        @@logger.info("#{self}.get_ask_price_by_ask_price_id(#{ask_price_id})")
        @@ask_prices.func_get(ask_price_id)
      end

      def OrdersModel.get_ask_prices_by_user_name(user_name)
        @@logger.info("#{self}.get_ask_prices_by_user_name(#{user_name})")
        ask_prices = @@ask_prices.func_get_all_by_user_name(user_name)
        if ask_prices
          ask_prices_array = []
          ask_prices.each{|row|
            ask_prices_array<<row.values
          }
          {:ask_prices => ask_prices_array}
        else
          nil
        end
      end

      # ---- contracts ----↓
      def OrdersModel.add_new_contract(contract)
        if contract.is_a?(@@contract)
          new_id = @@helper.new_step1_id(@@contracts.func_get_max_contract_id)
          if new_id != nil
            contract.contract_id = new_id
            @@logger.info("#{self}.add_new_contract, contract=#{contract}")
            @@contracts.func_add(contract)
          else
            @@logger.error("#{self}.add_new_contract, new_product_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_contract, contract is not a #{@@contract}")
          nil
        end
      end

      def OrdersModel.delete_contract_by_contract_id(contract_id)
        @@logger.info("#{self}.delete_contract_by_contract_id(#{contract_id})")
        @@contracts.func_delete(contract_id)
      end

      def OrdersModel.update_contract(contract)
        @@logger.info("#{self}.update_contract, contract=#{contract}")
        @@contracts.func_update(contract)
      end

      def OrdersModel.get_contract_by_contract_id(contract_id)
        @@logger.info("#{self}.get_contract_by_contract_id(#{contract_id})")
        @@contracts.func_get(contract_id)
      end

      def OrdersModel.get_contracts_by_user_name(user_name)
        @@logger.info("#{self}.get_contracts_by_user_name(#{user_name})")
        contracts = @@contracts.func_get_all_by_user_name(user_name)
        if contracts
          contracts_array = []
          contracts.each{|row|
            contracts_array<<row.values
          }
          {:contracts => contracts_array}
        else
          nil
        end
      end

      def OrdersModel.get_contracts_by_sign_user_name(sign_by_user_name)
        @@logger.info("#{self}.get_contracts_by_sign_user_name(#{sign_by_user_name})")
        contracts = @@contracts.func_get_all_by_sign_user(sign_by_user_name)
        if contracts
          contracts_array = []
          contracts.each{|row|
            contracts_array<<row.values
          }
          {:contracts => contracts_array}
        else
          nil
        end
      end

      # ---- orders ----↓
      def OrdersModel.add_new_order(order)
        if order.is_a?(@@order)
          new_id = @@helper.new_step1_id(@@orders.func_get_max_order_id)
          if new_id != nil
            order.order_id = new_id
            @@logger.info("#{self}.add_new_order, order=#{order}")
            @@orders.func_add(order)
          else
            @@logger.error("#{self}.add_new_order, order_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_order, order is not a #{@@order}")
          nil
        end
      end

      def OrdersModel.delete_order_by_order_id(order_id)
        @@logger.info("#{self}.delete_order_by_order_id(#{order_id})")
        @@orders.func_delete(order_id)
      end

      def OrdersModel.update_order(order)
        @@logger.info("#{self}.update_order, order=#{order}")
        @@orders.func_update(order)
      end

      def OrdersModel.get_order_by_order_id(order_id)
        @@logger.info("#{self}.get_order_by_order_id(#{order_id})")
        @@orders.func_get(order_id)
      end

      def OrdersModel.get_orders_by_user_name(user_name)
        @@logger.info("#{self}.get_orders_by_user_name(#{user_name})")
        orders = @@orders.func_get_all_by_user_name(user_name)
        if orders
          orders_array = []
          customer_id_arr=[]
          orders.each{|row|
            if !customer_id_arr.include?(row[:customer_id])
              customer_id_arr<<row[:customer_id]
            end
            orders_array<<row.values
          }
          {:orders => orders_array,:customer_id_arr=>customer_id_arr}
        else
          nil
        end
      end

      def OrdersModel.get_orders_by_sign_user_name(sign_by_user_name)
        @@logger.info("#{self}.get_orders_by_sign_user_name(#{sign_by_user_name})")
        orders = @@orders.func_get_all_by_sign_user(sign_by_user_name)
        if orders
          orders_array = []
          customer_id_arr=[]
          orders.each{|row|
            if !customer_id_arr.include?(row[:customer_id])
              customer_id_arr<<row[:customer_id]
            end
            orders_array<<row.values
          }
          {:orders => orders_array,:customer_id_arr=>customer_id_arr}
        else
          nil
        end
      end
    end
  end
end