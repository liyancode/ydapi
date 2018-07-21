module YDAPI
  module BizModel
    class OrdersModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@ask_price=YDAPI::BizEntity::AskPrice
      @@ask_prices=YDAPI::BizModel::DBModel::AskPrices

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
    end
  end
end