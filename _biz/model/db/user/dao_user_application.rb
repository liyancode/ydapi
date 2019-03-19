module YDAPI
  module BizModel
    module DBModel
      class DAO_UserApplication < Sequel::Model(:user_application)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserApplication.func_add(user_application)
          begin
            DAO_UserApplication.create do |obj|
              obj.created_by = user_application.created_by
              obj.last_update_by = user_application.last_update_by
              obj.comment = user_application.comment
              obj.application_id = user_application.application_id
              obj.user_name = user_application.user_name
              obj.type = user_application.type
              obj.description = user_application.description
              obj.approve_by = user_application.approve_by
              obj.approve_status = user_application.approve_status
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_application.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_delete(application_id)
          begin
            DAO_UserApplication[application_id: application_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{application_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_update(user_application)
          begin
            exist_item=DAO_UserApplication[application_id: user_application.application_id]
            new_item=exist_item.update(
                last_update_by: user_application.last_update_by,
                comment: user_application.comment,
                type: user_application.type,
                description: user_application.description,
                approve_by: user_application.approve_by,
                approve_status: user_application.approve_status
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_application.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_get(application_id)
          begin
            DAO_UserApplication[application_id: application_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{application_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_get_all_by_user_name(user_name)
          begin
            DAO_UserApplication.dataset.where(user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_get_all_by_user_name_and_type(user_name,type)
          begin
            DAO_UserApplication.dataset.where(user_name:user_name).where(type:type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name_and_type(#{user_name},#{type}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserApplication.func_get_all_by_approve_by(approve_by)
          begin
            DAO_UserApplication.dataset.where(approve_by:approve_by).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_approve_by(#{approve_by}) Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end