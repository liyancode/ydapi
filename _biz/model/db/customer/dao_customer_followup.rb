module YDAPI
  module BizModel
    module DBModel
      class DAO_CustomersFollowup < Sequel::Model(:customer_followup)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_CustomersFollowup.func_add(customer_followup)
          begin
            DAO_CustomersFollowup.create do |c|
              c.created_by = customer_followup.created_by
              c.last_update_by = customer_followup.last_update_by
              c.comment = customer_followup.comment
              c.customer_id=customer_followup.customer_id
              c.user_name=customer_followup.user_name
              c.followup_description=customer_followup.followup_description
              c.followup_status=customer_followup.followup_status
              c.followup_method=customer_followup.followup_method
              c.followup_method_my_id=customer_followup.followup_method_my_id
              c.followup_method_customer_id=customer_followup.followup_method_customer_id
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{customer_followup}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_delete(id)
          begin
            DAO_CustomersFollowup[id: id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{id}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_update(customer_followup)
          begin
            exist_customer_followup=DAO_CustomersFollowup[id: customer_followup.id]
            new_customer_followup=exist_customer_followup.update(
                last_update_by: customer_followup.last_update_by,
                comment: customer_followup.comment,
                customer_id:customer_followup.customer_id,
                user_name:customer_followup.user_name,
                followup_description:customer_followup.followup_description,
                followup_status:customer_followup.followup_status,
                followup_method:customer_followup.followup_method,
                followup_method_my_id:customer_followup.followup_method_my_id,
                followup_method_customer_id:customer_followup.followup_method_customer_id
            )
            if new_customer_followup
              new_customer_followup
            else
              exist_customer_followup
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{customer_followup.id}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_get_all_to_one_customer(customer_id)
          begin
            DAO_CustomersFollowup.dataset.where(customer_id:customer_id).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_to_one_customer(#{customer_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_get_all_by_customer_id_array(customer_id_array)
          begin
            DAO_CustomersFollowup.dataset.where([[:customer_id,customer_id_array]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_customer_id_array(#{customer_id_array}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_get_all_by_user_name(user_name)
          begin
            DAO_CustomersFollowup.dataset.where(user_name:user_name).where(status:1).order(:last_update_at).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_get_all_by_cid_uname(customer_id,user_name)
          begin
            DAO_CustomersFollowup.dataset.where(customer_id:customer_id).where(user_name:user_name).where(status:1).order(:last_update_at).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_cid_uname(#{customer_id},#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_CustomersFollowup.func_get_by_id(id)
          begin
            DAO_CustomersFollowup[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end