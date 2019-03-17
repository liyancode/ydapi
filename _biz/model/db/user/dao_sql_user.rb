module YDAPI
  module BizModel
    module DBModel
      class DAO_SQL_User
        @@logger=BIZ_MODEL_LOGGER
        def DAO_SQL_User.select_user_list_by_department_id(department_id)
          begin
            result=[]
            DB.fetch(
                "select upi.full_name,uei.id as employee_id,uei.user_name,uei.title,uei.level,uei.report_to,uei.employee_status,uei.annual_leave_left
               from user_private_info as upi,user_employee_info as uei
               where uei.department_id = '#{department_id}' and upi.user_name=uei.user_name").each{|row|
              result<<row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.select_user_list_by_department_id(#{department_id}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_User.get_report_to_by_username(username)
          begin
            report_to='_not_know'
            DB.fetch(
                "select usi.report_to,ud.department_manager
                 from user_employee_info as usi,user_department as ud
                 where usi.user_name='#{username}' and usi.department_id=ud.department_id").each{|row|
              if row[:report_to]!=''
                report_to=row[:report_to]
              elsif row[:department_manager]!=''
                report_to=row[:department_manager]
              end
            }
            report_to
          rescue Exception => e
            @@logger.error("#{self}.get_report_to_by_username(#{username}) Exception:#{e}")
            nil
          end
        end

        def DAO_SQL_User.get_user_list_for_admin
          begin
            result=[]
            DB.fetch(
                "select uei.id,uei.employee_number,uei.user_name,uei.title,uei.onboard_date,uei.employee_status,upi.full_name,upi.gender,ud.department_name
                 from user_employee_info as uei,user_private_info as upi,user_department as ud
                 where uei.status=1 and uei.user_name=upi.user_name and uei.department_id=ud.department_id").each{|row|
              result<<row
            }
            result
          rescue Exception => e
            @@logger.error("#{self}.get_user_list_for_admin Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end