module YDAPI
  module BizModel
    module DBModel
      class Users < Sequel::Model(:users)
        @@logger=BIZ_MODEL_LOGGER
        def Users.func_add(user)
          begin
            Users.create do |u|
              u.user_id = user.user_id
              u.user_name = user.user_name
              u.password = user.password
              u.authority = user.authority
              u.type = user.type
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(user) Exception:#{e}")
            nil
          end
        end

        def Users.func_delete(user_id)
          begin
            Users[user_id: user_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(user_id) Exception:#{e}")
            nil
          end
        end

        def Users.func_update(user)
          begin
            exist_user=Users[user_id: user.user_id]
            new_user=exist_user.update(
                password: user.password,
                authority: user.authority,
                type: user.type
            )
            if new_user
              new_user
            else
              exist_user
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(user) Exception:#{e}")
            nil
          end
        end

        def Users.func_update_password(user_name,new_password)
          begin
            exist_user=Users[user_name: user_name]
            new_user=exist_user.update(
                password: new_password
            )
            if new_user
              new_user
            else
              exist_user
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update_password(#{user_id},***) Exception:#{e}")
            nil
          end
        end

        def Users.func_get(user_name)
          begin
            Users[user_name: user_name]
          rescue Exception => e
            @@logger.error("#{self}.func_get(user_name) Exception:#{e}")
            nil
          end
        end

        def Users.func_get_all
          begin
            Users.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end

        def Users.func_get_max_user_id
          begin
            Users.last.user_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_user_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end