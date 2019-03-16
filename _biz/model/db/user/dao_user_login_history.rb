module YDAPI
  module BizModel
    module DBModel
      class DAO_UserLoginHistory < Sequel::Model(:user_login_history)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserLoginHistory.func_add(user_login_history)
          begin
            DAO_UserLoginHistory.create do |obj|
              obj.created_by = user_login_history.created_by
              obj.last_update_by = user_login_history.last_update_by
              obj.comment = user_login_history.comment
              obj.user_name = user_login_history.user_name
              obj.rq_scheme = user_login_history.rq_scheme
              obj.rq_host = user_login_history.rq_host
              obj.rq_port = user_login_history.rq_port
              obj.rq_path = user_login_history.rq_path
              obj.rq_ip = user_login_history.rq_ip
              obj.rq_user_agent = user_login_history.rq_user_agent
              obj.ip_location_info = user_login_history.ip_location_info
              obj.login_in_or_out = user_login_history.login_in_or_out
              obj.result = user_login_history.result
              obj.other = user_login_history.other
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_login_history.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserLoginHistory.func_get_last_n_by_user_name(n,user_name)
          begin
            DAO_UserLoginHistory.dataset.where(user_name:user_name).last(n)
          rescue Exception => e
            @@logger.error("#{self}.func_get_last_n_by_user_name Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end