module YDAPI
  module BizModel
    class FinApprovalsModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@fin_approval = YDAPI::BizEntity::FinApproval

      @@fin_approvals = YDAPI::BizModel::DBModel::FinApprovals

      def FinApprovalsModel.add_new_fin_approval(fin_approval)
        if fin_approval.is_a?(@@fin_approval)
          new_id = @@helper.new_step1_id(@@fin_approvals.func_get_max_fin_approval_id)
          if new_id != nil
            fin_approval.fin_approval_id = new_id
            @@logger.info("#{self}.add_new_fin_approval, fin_approval=#{fin_approval}")
            @@fin_approvals.func_add(fin_approval)
          else
            @@logger.error("#{self}.add_new_fin_approval, get_max_fin_approval_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_fin_approval, fin_approval is not a #{@@fin_approval}")
          nil
        end
      end

      def FinApprovalsModel.delete_fin_approval_by_fin_approval_id(fin_approval_id)
        @@logger.info("#{self}.delete_fin_approval_by_fin_approval_id(#{fin_approval_id})")
        @@fin_approvals.func_delete(fin_approval_id)
      end

      def FinApprovalsModel.update_fin_approval(fin_approval)
        @@logger.info("#{self}.update_fin_approval, fin_approval=#{fin_approval}")
        @@fin_approvals.func_update(fin_approval)
      end

      def FinApprovalsModel.get_fin_approvals_by_user_name(user_name)
        @@logger.info("#{self}.get_fin_approvals_by_user_name(#{user_name})")
        fin_approvals = @@fin_approvals.func_get_all_by_user_name(user_name)
        if fin_approvals
          fin_approvals_array = []
          fin_approvals.each {|row|
            fin_approvals_array << row.values
          }
          {:fin_approvals => fin_approvals_array}
        else
          nil
        end
      end

      def FinApprovalsModel.get_fin_approvals_by_type(type)
        @@logger.info("#{self}.get_fin_approvals_by_type(#{type})")
        fin_approvals = @@fin_approvals.func_get_all_by_type(type)
        if fin_approvals
          fin_approvals_array = []
          fin_approvals.each {|row|
            fin_approvals_array << row.values
          }
          {:fin_approvals => fin_approvals_array}
        else
          nil
        end
      end

      def FinApprovalsModel.get_fin_approvals_by_type_and_result(type,result)
        @@logger.info("#{self}.get_fin_approvals_by_type_and_result(#{type},#{result})")
        fin_approvals = @@fin_approvals.func_get_all_by_type_and_approval_result(type,result)
        if fin_approvals
          fin_approvals_array = []
          fin_approvals.each {|row|
            fin_approvals_array << row.values
          }
          {:fin_approvals => fin_approvals_array}
        else
          nil
        end
      end

      def FinApprovalsModel.get_fin_approvals_by_result(result)
        @@logger.info("#{self}.get_fin_approvals_by_result(#{result})")
        fin_approvals = @@fin_approvals.func_get_all_by_approval_result(result)
        if fin_approvals
          fin_approvals_array = []
          fin_approvals.each {|row|
            fin_approvals_array << row.values
          }
          {:fin_approvals => fin_approvals_array}
        else
          nil
        end
      end

      def FinApprovalsModel.get_fin_approval_by_fin_approval_id(fin_approval_id)
        @@logger.info("#{self}.get_fin_approval_by_fin_approval_id(#{fin_approval_id})")
        fin_approval = @@fin_approvals.func_get(fin_approval_id)
        if fin_approval
          fin_approval.values
        else
          nil
        end
      end
    end
  end
end