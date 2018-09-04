module YDAPI
  module BizModel
    module DBModel
      class Orders < Sequel::Model(:orders)
        @@logger=BIZ_MODEL_LOGGER
        def Orders.func_add(order)
          begin
            Orders.create do |c|
              c.order_id=order.order_id
              c.added_by_user_name=order.added_by_user_name
              c.contract_id=order.contract_id
              c.sign_by_user_name=order.sign_by_user_name
              c.customer_id=order.customer_id
              c.order_type=order.order_type
              c.start_date=order.start_date
              c.end_date=order.end_date
              c.total_value=order.total_value
              c.total_value_currency=order.total_value_currency
              c.pay_type=order.pay_type
              c.paid_value=order.paid_value
              c.paid_value_currency=order.paid_value_currency
              c.order_status=order.order_status
              c.order_status_update_by=order.order_status_update_by
              c.description=order.description
              c.comment=order.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{order}) Exception:#{e}")
            nil
          end
        end

        def Orders.func_delete(order_id)
          begin
            Orders[order_id: order_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{order_id}) Exception:#{e}")
            nil
          end
        end

        def Orders.func_update(order)
          begin
            exist_c=Orders[order_id: order.order_id]
            new_c=exist_c.update(
                contract_id:order.contract_id,
                sign_by_user_name:order.sign_by_user_name,
                customer_id:order.customer_id,
                order_type:order.order_type,
                start_date:order.start_date,
                end_date:order.end_date,
                total_value:order.total_value,
                total_value_currency:order.total_value_currency,
                pay_type:order.pay_type,
                paid_value:order.paid_value,
                paid_value_currency:order.paid_value_currency,
                order_status:order.order_status,
                order_status_update_by:order.order_status_update_by,
                is_finished:order.is_finished,
                description:order.description,
                comment:order.comment
            )
            if new_c
              new_c
            else
              exist_c
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{order}) Exception:#{e}")
            nil
          end
        end

        def Orders.func_get(order_id)
          begin
            Orders[order_id: order_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{order_id}) Exception:#{e}")
            nil
          end
        end

        def Orders.func_get_all_by_user_name(user_name)
          begin
            Orders.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(user_name) Exception:#{e}")
            nil
          end
        end

        def Orders.func_get_all_by_sign_user(sign_by_user_name)
          begin
            Orders.dataset.where(sign_by_user_name:sign_by_user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(user_name) Exception:#{e}")
            nil
          end
        end

        def Orders.func_get_max_order_id
          begin
            Orders.last.order_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_order_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end