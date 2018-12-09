module YDAPI
  module BizModel
    module DBModel
      class DAO_UserAuthority < Sequel::Model(:user_authority)
        @@logger=BIZ_MODEL_LOGGER
        def DAO_UserAuthority.func_add(user_authority)
          begin
            DAO_UserAuthority.create do |obj|
              obj.created_by = user_authority.created_by
              obj.last_update_by = user_authority.last_update_by
              obj.comment = user_authority.comment
              obj.authority = user_authority.authority
              obj.authority_cn = user_authority.authority_cn
              obj.scope = user_authority.scope
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{user_authority.user_name}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAuthority.func_delete(authority)
          begin
            DAO_UserAuthority[authority: authority].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{authority}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAuthority.func_update(user_authority)
          begin
            exist_item=DAO_UserAuthority[authority: user_authority.authority]
            new_item=exist_item.update(
                last_update_by: user_authority.last_update_by,
                comment: user_authority.comment,
                authority_cn: user_authority.authority_cn,
                scope: user_authority.scope
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{user_authority.authority}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAuthority.func_get(authority)
          begin
            DAO_UserAuthority[authority: authority]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{authority}) Exception:#{e}")
            nil
          end
        end

        def DAO_UserAuthority.func_get_all
          begin
            DAO_UserAuthority.dataset.where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end