module YDAPI
  module BizModel
    module DBModel
      class AskPrices < Sequel::Model(:ask_prices)
        @@logger=BIZ_MODEL_LOGGER
        def AskPrices.func_add(ask_price)
          begin
            AskPrices.create do |ap|
              ap.ask_price_id=ask_price.ask_price_id
              ap.added_by_user_name=ask_price.added_by_user_name
              ap.customer_id=ask_price.customer_id
              ap.product_ids=ask_price.product_ids
              ap.description=ask_price.description
              ap.approve_status=ask_price.approve_status
              ap.approve_by_user_name=ask_price.approve_by_user_name
              ap.comment=ask_price.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{ask_price}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_delete(ask_price_id)
          begin
            AskPrices[ask_price_id: ask_price_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{ask_price_id}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_update(ask_price)
          begin
            exist_ap=AskPrices[ask_price_id: ask_price.ask_price_id]
            new_ap=exist_ap.update(
                customer_id:ask_price.customer_id,
                product_ids:ask_price.product_ids,
                description:ask_price.description,
                approve_status:ask_price.approve_status,
                approve_by_user_name:ask_price.approve_by_user_name,
                comment:ask_price.comment
            )
            if new_ap
              new_ap
            else
              exist_ap
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{ask_price}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_update_approve_status(ask_price_id,new_status,by_user_name)
          begin
            exist_ap=AskPrices[ask_price_id: ask_price_id]
            new_ap=exist_ap.update(
                approve_status:new_status,
                approve_by_user_name:by_user_name
            )
            if new_ap
              new_ap
            else
              exist_ap
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_approve_status(#{ask_price_id},#{new_status},#{by_user_name}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_get(ask_price_id)
          begin
            AskPrices[ask_price_id: ask_price_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{ask_price_id}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_get_by_id(id)
          begin
            AskPrices[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_get_all_by_user_name(user_name)
          begin
            AskPrices.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(user_name) Exception:#{e}")
            nil
          end
        end

        def AskPrices.func_get_max_ask_price_id
          begin
            AskPrices.last.ask_price_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_ask_price_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end