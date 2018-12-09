module YDAPI
  module BizModel
    module DBModel
      class DAO_UserDepartment < Sequel::Model(:user_department)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserDepartment.func_add(user_department)
          begin
            DAO_UserDepartment.create do |obj|
              obj.created_by = user_department.created_by
              obj.last_update_by = user_department.last_update_by
              obj.comment = user_department.comment
              obj.department_id = user_department.department_id
              obj.parent_department_id = user_department.parent_department_id
              obj.department_name = user_department.department_name
              obj.department_manager = user_department.department_manager
              obj.department_employee_count = user_department.department_employee_count
              obj.department_description = user_department.department_description
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_department.department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserDepartment.func_delete(department_id)
          begin
            DAO_UserDepartment[department_id: department_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserDepartment.func_update(user_department)
          begin
            exist_item=DAO_UserDepartment[department_id: user_department.department_id]
            new_item=exist_item.update(
                last_update_by: user_department.last_update_by,
                comment: user_department.comment,
                parent_department_id: user_department.parent_department_id,
                department_name: user_department.department_name,
                department_manager: user_department.department_manager,
                department_employee_count: user_department.department_employee_count,
                department_description: user_department.department_description
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_department.department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserDepartment.func_get(department_id)
          begin
            DAO_UserDepartment[department_id: department_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserDepartment.func_get_all
          begin
            DAO_UserDepartment.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end