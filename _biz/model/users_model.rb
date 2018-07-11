module YDAPI
  module BizModel
    class UsersModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@user = YDAPI::BizEntity::User
      @@user_employee_info = YDAPI::BizEntity::UserEmployeeInfo

      @@users = YDAPI::BizModel::DBModel::Users
      @@users_employee_info = YDAPI::BizModel::DBModel::UsersEmployeeInfo

      def UsersModel.add_new_user(user)
        if user.is_a?(@@user)
          new_id = @@helper.new_user_id(@@users.func_get_max_user_id)
          if new_id != nil
            user.user_id = new_id
            @@logger.info("#{self}.add_new_user, user=#{user.to_s}")
            @@users.func_add(user)
          else
            @@logger.error("#{self}.add_new_user, get_max_user_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_user, user is not a #{@@user}")
          nil
        end
      end

      def UsersModel.add_new_user_employee_info(user_employee_info)
        if user_employee_info.is_a?(@@user_employee_info)
          @@logger.info("#{self}.add_new_user_employee_info, user_employee_info=#{user_employee_info}")
          @@users_employee_info.func_add(user_employee_info)
        else
          @@logger.error("#{self}.add_new_user_employee_info, user_employee_info is not a #{@@user_employee_info}")
          nil
        end
      end

      def UsersModel.delete_user_by_user_id(user_id)
        @@logger.info("#{self}.delete_by_user_id(#{user_id})")
        @@users.func_delete(user_id)
      end

      def UsersModel.delete_user_employee_info_by_user_id(user_id)
        @@logger.info("#{self}.delete_user_employee_info_by_user_id(#{user_id})")
        @@users_employee_info.func_delete(user_id)
      end

      def UsersModel.update_user(user)
        @@logger.info("#{self}.update_user, user=#{user.to_s}")
        @@users.func_update(user)
      end

      def UsersModel.update_user_employee_info(user_employee_info)
        @@logger.info("#{self}.update_user_employee_info, user_employee_info=#{user_employee_info}")
        @@users_employee_info.func_update(user_employee_info)
      end

      def UsersModel.get_user_by_user_name(user_name)
        @@logger.info("#{self}.get_user_by_user_name(#{user_name})")
        @@users.func_get(user_name)
      end

      def UsersModel.get_user_and_employee_info_by_user_name(user_name)
        @@logger.info("#{self}.get_user_and_employee_info_by_user_name(#{user_name})")
        user = @@users.func_get(user_name)
        if user
          user_employee_info = @@users_employee_info.func_get(user.user_id)
          employee_info = {}
          if user_employee_info
            employee_info = user_employee_info.values
          end
          {:user => user.values, :employee_info => employee_info}
        else
          nil
        end
      end
    end
  end
end