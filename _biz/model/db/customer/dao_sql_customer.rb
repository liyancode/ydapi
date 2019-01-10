module YDAPI
  module BizModel
    module DBModel
      class DAO_SQL_Customer
        @@logger = BIZ_MODEL_LOGGER

        def DAO_SQL_Customer.select_customers_by_user_name(user_name)
          begin
            result = []
            DB.fetch(
                "select cst.*,cfp.last_update_at as followup_last_update_at,cfp.followup_status
                 from customers as cst,
                      (select tbb.*
                       from customer_followup as tbb,
                            (select customer_id,user_name,max(last_update_at) as lup
                             from customer_followup
                             where status=1 and user_name='#{user_name}'
                             group by customer_id,user_name) as tba
                       where tbb.customer_id=tba.customer_id and tbb.user_name=tba.user_name and tbb.last_update_at=tba.lup) as cfp
                 where cst.added_by_user_name='#{user_name}'
                       and cst.customer_id=cfp.customer_id
                       and cst.added_by_user_name=cfp.last_update_by
                       and cst.status=1").each {|row|
              result << row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_customers_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_Customer.get_last_followup_status_by_cid_uname(customer_id,user_name)
          begin
            followup_status=nil
            DB.fetch(
                "select followup_status
                 from customer_followup
                 where customer_id='#{customer_id}' and user_name='#{user_name}'
                       and status=1 order by last_update_at desc limit 1").each {|row|
              followup_status << row[:followup_status]
            }
            followup_status
          rescue Exception => e
            @@logger.error("#{self}.get_last_followup_status_by_cid_uname(#{customer_id},#{user_name}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end