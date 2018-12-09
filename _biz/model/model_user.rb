module YDAPI
  module BizModel
    class Model_User
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@_common_model_func = YDAPI::BizModel::CommonModelFunc

      # ====== user_account
      @@user_account = YDAPI::BizEntity::UserAccount
      @@dao_user_account = YDAPI::BizModel::DBModel::DAO_UserAccount

      def Model_User.add_user_account(user_account)
        @@_common_model_func.common_add(
            @@user_account,
            user_account,
            @@dao_user_account,
            @@logger,
            self,
            'add_user_account'
        )
      end

      def Model_User.delete_user_account_by_user_name(user_name)
        @@logger.info("#{self}.delete_user_account_by_user_name(#{user_name})")
        @@dao_user_account.func_delete(user_name)
      end

      def Model_User.update_user_account(user_account)
        @@logger.info("#{self}.update_user_account, user=#{user_account.user_name}")
        @@dao_user_account.func_update(user_account)
      end

      def Model_User.update_user_account_password(user_name,new_password)
        @@logger.info("#{self}.update_user_account_password, user=#{user_name}")
        @@dao_user_account.func_update_password(user_name,new_password)
      end

      def Model_User.get_user_account_by_user_name(user_name)
        @@logger.info("#{self}.get_user_account_by_user_name(#{user_name})")
        @@dao_user_account.func_get(user_name)
      end

      def Model_User.get_all_user_accounts
        @@logger.info("#{self}.get_all_user_accounts")
        @@dao_user_account.func_get_all
      end

      # ====== user_authority
      @@user_authority = YDAPI::BizEntity::UserAuthority
      @@dao_user_authority = YDAPI::BizModel::DBModel::DAO_UserAuthority

      def Model_User.add_user_authority(user_authority)
        @@_common_model_func.common_add(
            @@user_authority,
            user_authority,
            @@dao_user_authority,
            @@logger,
            self,
            'add_user_authority'
        )
      end

      def Model_User.delete_user_authority_by_authority(authority)
        @@logger.info("#{self}.delete_user_authority_by_authority(#{authority})")
        @@dao_user_authority.func_delete(authority)
      end

      def Model_User.update_user_authority(user_authority)
        @@logger.info("#{self}.update_user_authority, authority=#{user_authority.authority}")
        @@dao_user_authority.func_update(user_authority)
      end

      def Model_User.get_user_authority_by_authority(authority)
        @@logger.info("#{self}.get_user_authority_by_authority(#{authority})")
        @@dao_user_authority.func_get(authority)
      end

      def Model_User.get_all_user_authorities
        @@logger.info("#{self}.get_all_user_authorities")
        @@dao_user_authority.func_get_all
      end

      # ====== user_department
      @@user_department = YDAPI::BizEntity::UserDepartment
      @@dao_user_department = YDAPI::BizModel::DBModel::DAO_UserDepartment

      def Model_User.add_user_department(user_department)
        @@_common_model_func.common_add(
            @@user_department,
            user_department,
            @@dao_user_department,
            @@logger,
            self,
            'add_user_department'
        )
      end

      def Model_User.delete_user_department_by_department_id(department_id)
        @@logger.info("#{self}.delete_user_department_by_department_id(#{department_id})")
        @@dao_user_department.func_delete(department_id)
      end

      def Model_User.update_user_department(user_department)
        @@logger.info("#{self}.update_user_department, department_id=#{user_department.department_id}")
        @@dao_user_department.func_update(user_department)
      end

      def Model_User.get_user_department_by_department_id(department_id)
        @@logger.info("#{self}.get_user_department_by_department_id(#{department_id})")
        @@dao_user_department.func_get(department_id)
      end

      def Model_User.get_all_user_departments
        @@logger.info("#{self}.get_all_user_departments")
        @@dao_user_department.func_get_all
      end

      # ====== user_employee_info
      @@user_employee_info = YDAPI::BizEntity::UserEmployeeInfo
      @@dao_user_employee_info = YDAPI::BizModel::DBModel::DAO_UserEmployeeInfo

      def Model_User.add_user_employee_info(user_employee_info)
        @@_common_model_func.common_add(
            @@user_employee_info,
            user_employee_info,
            @@dao_user_employee_info,
            @@logger,
            self,
            'add_user_employee_info'
        )
      end

      def Model_User.delete_user_employee_info_by_user_name(user_name)
        @@logger.info("#{self}.delete_user_employee_info_by_user_name(#{user_name})")
        @@dao_user_employee_info.func_delete(user_name)
      end

      def Model_User.update_user_employee_info(user_employee_info)
        @@logger.info("#{self}.update_user_employee_info, user_name=#{user_employee_info.user_name}")
        @@dao_user_employee_info.func_update(user_employee_info)
      end

      def Model_User.get_user_employee_info_by_user_name(user_name)
        @@logger.info("#{self}.get_user_employee_info_by_user_name(#{user_name})")
        @@dao_user_employee_info.func_get(user_name)
      end

      def Model_User.get_all_user_employee_infos
        @@logger.info("#{self}.get_all_user_employee_infos")
        @@dao_user_employee_info.func_get_all
      end

      # ====== user_private_info
      @@user_private_info = YDAPI::BizEntity::UserPrivateInfo
      @@dao_user_private_info = YDAPI::BizModel::DBModel::DAO_UserPrivateInfo

      def Model_User.add_user_private_info(user_private_info)
        @@_common_model_func.common_add(
            @@user_private_info,
            user_private_info,
            @@dao_user_private_info,
            @@logger,
            self,
            'add_user_private_info'
        )
      end
    end
  end
end