module YDAPI
  module BizModel
    module DBModel
      class UsersEmployeeInfo < Sequel::Model(:users_employee_info)
        @@logger=BIZ_MODEL_LOGGER
        def UsersEmployeeInfo.func_add(user_employee_info)
          begin
            UsersEmployeeInfo.create do |u|
              u.user_id = user_employee_info.user_id
              u.full_name = user_employee_info.full_name
              u.gender = user_employee_info.gender
              u.birthday = user_employee_info.birthday
              u.marital_status = user_employee_info.marital_status
              u.department_id = user_employee_info.department_id
              u.title = user_employee_info.title
              u.office = user_employee_info.office
              u.onboard_at = user_employee_info.onboard_at
              u.position_status = user_employee_info.position_status
              u.email = user_employee_info.email
              u.phone_number = user_employee_info.phone_number
              u.address = user_employee_info.address
              u.hometown = user_employee_info.hometown
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(user_employee_info) Exception:#{e}")
            nil
          end
        end

        def UsersEmployeeInfo.func_delete(user_id)
          begin
            UsersEmployeeInfo[user_id: user_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{user_id}) Exception:#{e}")
            nil
          end
        end

        def UsersEmployeeInfo.func_update(user_employee_info)
          begin
            exist_user_employee_info=UsersEmployeeInfo[user_id: user_employee_info.user_id]
            new_user_employee_info=exist_user_employee_info.update(
                full_name: user_employee_info.full_name,
                gender: user_employee_info.gender,
                birthday: user_employee_info.birthday,
                marital_status: user_employee_info.marital_status,
                department_id: user_employee_info.department_id,
                title: user_employee_info.title,
                office: user_employee_info.office,
                onboard_at: user_employee_info.onboard_at,
                position_status: user_employee_info.position_status,
                email: user_employee_info.email,
                phone_number: user_employee_info.phone_number,
                address: user_employee_info.address,
                hometown: user_employee_info.hometown
            )
            if new_user_employee_info
              new_user_employee_info
            else
              exist_user_employee_info
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(user_employee_info) Exception:#{e}")
            nil
          end
        end

        def UsersEmployeeInfo.func_get(user_id)
          begin
            UsersEmployeeInfo[user_id: user_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{user_id}) Exception:#{e}")
            nil
          end
        end

        def UsersEmployeeInfo.func_get_all
          begin
            UsersEmployeeInfo.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end