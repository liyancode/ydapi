module YDAPI
  module BizModel
    module DBModel
      class DAO_UserEmployeeInfo < Sequel::Model(:user_employee_info)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserEmployeeInfo.func_add(user_employee_info)
          begin
            DAO_UserEmployeeInfo.create do |obj|
              obj.created_by = user_employee_info.created_by
              obj.last_update_by = user_employee_info.last_update_by
              obj.comment = user_employee_info.comment
              obj.user_name = user_employee_info.user_name
              obj.title = user_employee_info.title
              obj.level = user_employee_info.level
              obj.department_id = user_employee_info.department_id
              obj.report_to = user_employee_info.report_to
              obj.onboard_date = user_employee_info.onboard_date
              obj.resignation_date = user_employee_info.resignation_date
              obj.employee_status = user_employee_info.employee_status
              obj.annual_leave_left = user_employee_info.annual_leave_left
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_employee_info.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserEmployeeInfo.func_delete(user_name)
          begin
            DAO_UserEmployeeInfo[user_name: user_name].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserEmployeeInfo.func_update(user_employee_info)
          begin
            exist_item=DAO_UserEmployeeInfo[user_name: user_employee_info.user_name]
            new_item=exist_item.update(
                last_update_by: user_employee_info.last_update_by,
                comment: user_employee_info.comment,
                title: user_employee_info.title,
                level: user_employee_info.level,
                department_id: user_employee_info.department_id,
                report_to: user_employee_info.report_to,
                onboard_date: user_employee_info.onboard_date,
                resignation_date: user_employee_info.resignation_date,
                employee_status: user_employee_info.employee_status,
                annual_leave_left: user_employee_info.annual_leave_left
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_employee_info.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserEmployeeInfo.func_get(user_name)
          begin
            DAO_UserEmployeeInfo[user_name: user_name]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserEmployeeInfo.func_get_all
          begin
            DAO_UserEmployeeInfo.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end