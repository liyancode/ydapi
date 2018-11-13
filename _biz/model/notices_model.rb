module YDAPI
  module BizModel
    class NoticesModel
      @@logger = BIZ_MODEL_LOGGER
      @@helper = YDAPI::Helpers::Helper

      @@notice = YDAPI::BizEntity::Notice

      @@notices = YDAPI::BizModel::DBModel::Notices

      def NoticesModel.add_new_notice(notice)
        if notice.is_a?(@@notice)
          new_id = @@helper.new_step1_id(@@notices.func_get_max_notice_id)
          if new_id != nil
            notice.notice_id = new_id
            @@logger.info("#{self}.add_new_notice, notice=#{notice}")
            @@notices.func_add(notice)
          else
            @@logger.error("#{self}.add_new_notice, get_max_notice_id error")
            nil
          end
        else
          @@logger.error("#{self}.add_new_notice, notice is not a #{@@notice}")
          nil
        end
      end

      def NoticesModel.delete_notice_by_notice_id(notice_id)
        @@logger.info("#{self}.delete_notice_by_notice_id(#{notice_id})")
        @@notices.func_delete(notice_id)
      end

      def NoticesModel.update_notice(notice)
        @@logger.info("#{self}.update_notice, notice=#{notice}")
        @@notices.func_update(notice)
      end

      def NoticesModel.get_notices_by_user_name(user_name)
        @@logger.info("#{self}.get_notices_by_user_name(#{user_name})")
        notices = @@notices.func_get_all_by_user_name(user_name)
        if notices
          notices_array = []
          notices.each {|row|
            notices_array << row.values
          }
          {:notices => notices_array}
        else
          nil
        end
      end

      def NoticesModel.get_notice_by_notice_id(notice_id)
        @@logger.info("#{self}.get_notice_by_notice_id(#{notice_id})")
        notice = @@notices.func_get(notice_id)
        if notice
          notice.values
        else
          nil
        end
      end
    end
  end
end