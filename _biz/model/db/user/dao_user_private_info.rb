module YDAPI
  module BizModel
    module DBModel
      class DAO_UserPrivateInfo < Sequel::Model(:user_private_info)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserPrivateInfo.func_add(user_private_info)
          begin
            DAO_UserPrivateInfo.create do |obj|
              obj.created_by = user_private_info.created_by
              obj.last_update_by = user_private_info.last_update_by
              obj.comment = user_private_info.comment
              obj.user_name = user_private_info.user_name
              obj.full_name = user_private_info.full_name
              obj.gender = user_private_info.gender
              obj.age = user_private_info.age
              obj.personal_id = user_private_info.personal_id
              obj.phone_number = user_private_info.phone_number
              obj.wechat = user_private_info.wechat
              obj.qq = user_private_info.qq
              obj.dingding = user_private_info.dingding
              obj.email = user_private_info.email
              obj.address = user_private_info.address
              obj.hometown = user_private_info.hometown
              obj.birthday = user_private_info.birthday
              obj.graduated_school = user_private_info.graduated_school
              obj.education = user_private_info.education
              obj.discipline = user_private_info.discipline
              obj.hobbies = user_private_info.hobbies
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_private_info.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserPrivateInfo.func_delete(user_name)
          begin
            DAO_UserPrivateInfo[user_name: user_name].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserPrivateInfo.func_update(user_private_info)
          begin
            exist_item=DAO_UserPrivateInfo[user_name: user_private_info.user_name]
            new_item=exist_item.update(
                last_update_by: user_private_info.last_update_by,
                comment: user_private_info.comment,
                full_name: user_private_info.full_name,
                gender: user_private_info.gender,
                age: user_private_info.age,
                personal_id: user_private_info.personal_id,
                phone_number: user_private_info.phone_number,
                wechat: user_private_info.wechat,
                qq: user_private_info.qq,
                dingding: user_private_info.dingding,
                email: user_private_info.email,
                address: user_private_info.address,
                hometown: user_private_info.hometown,
                birthday: user_private_info.birthday,
                graduated_school: user_private_info.graduated_school,
                education: user_private_info.education,
                discipline: user_private_info.discipline,
                hobbies: user_private_info.hobbies
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_private_info.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserPrivateInfo.func_get(user_name)
          begin
            DAO_UserPrivateInfo[user_name: user_name]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserPrivateInfo.func_get_all
          begin
            DAO_UserPrivateInfo.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end