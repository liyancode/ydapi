module YDAPI
  module BizModel
    module DBModel
      class FinApprovals < Sequel::Model(:fin_approvals)
        @@logger=BIZ_MODEL_LOGGER
        def FinApprovals.func_add(fin_approval)
          begin
            FinApprovals.create do |item|
              item.fin_approval_id=fin_approval.fin_approval_id
              item.ref_id=fin_approval.ref_id
              item.type=fin_approval.type
              item.approval_result=fin_approval.approval_result
              item.added_by_user_name=fin_approval.added_by_user_name
              item.updated_by_user_name=fin_approval.updated_by_user_name
              item.comment=fin_approval.comment
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{fin_approval}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_delete(fin_approval_id)
          begin
            FinApprovals[fin_approval_id: fin_approval_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{fin_approval_id}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_update(fin_approval)
          begin
            exist_item=FinApprovals[fin_approval_id: fin_approval.fin_approval_id]
            new_item=exist_item.update(
                ref_id:fin_approval.ref_id,
                type:fin_approval.type,
                approval_result:fin_approval.approval_result,
                comment:fin_approval.comment,
                added_by_user_name:fin_approval.added_by_user_name,
                updated_by_user_name:fin_approval.updated_by_user_name
            )
            if new_item
              new_item
            else
              exist_item
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{fin_approval}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get(fin_approval_id)
          begin
            FinApprovals[fin_approval_id: fin_approval_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{fin_approval_id}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_by_id(id)
          begin
            FinApprovals[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_all_by_user_name(user_name)
          begin
            FinApprovals.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_all_by_type(type)
          begin
            FinApprovals.dataset.where(type:type).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_type_id(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_all_by_type_and_approval_result(type,approval_result)
          begin
            FinApprovals.dataset.where(type:type).where(approval_result:approval_result).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_type_id(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_all_by_ref_id_arr(ref_id_arr)
          begin
            FinApprovals.dataset.where([[:ref_id,ref_id_arr]]).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_type_id_arr(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def FinApprovals.func_get_max_fin_approval_id
          begin
            FinApprovals.last.fin_approval_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_fin_approval_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end