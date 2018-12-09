module YDAPI
  module BizModel
    module DBModel
      class DAO_UserAccount < Sequel::Model(:user_account)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserAccount.func_add(user_account)
          begin
            DAO_UserAccount.create do |obj|
              obj.created_by = user_account.created_by
              obj.last_update_by = user_account.last_update_by
              obj.comment = user_account.comment
              obj.user_name = user_account.user_name
              obj.password = user_account.password
              obj.authorities = user_account.authorities
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_account.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAccount.func_delete(user_name)
          begin
            DAO_UserAccount[user_name: user_name].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAccount.func_update(user_account)
          begin
            exist_item=DAO_UserAccount[user_name: user_account.user_name]
            new_item=exist_item.update(
                password: user_account.password,
                last_update_by: user_account.last_update_by,
                comment: user_account.comment,
                authorities: user_account.authorities
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_account.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAccount.func_update_password(user_name,new_password)
          begin
            exist_item=DAO_UserAccount[user_name: user_name]
            new_item=exist_item.update(
                password: new_password
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_password(#{user_name},***) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAccount.func_get(user_name)
          begin
            DAO_UserAccount[user_name: user_name]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAccount.func_get_all
          begin
            DAO_UserAccount.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end