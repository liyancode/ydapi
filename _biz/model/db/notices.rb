module YDAPI
  module BizModel
    module DBModel
      class Notices < Sequel::Model(:notices)
        @@logger=BIZ_MODEL_LOGGER
        def Notices.func_add(notice)
          begin
            Notices.create do |ap|
              ap.notice_id=notice.notice_id
              ap.notice_title=notice.notice_title
              ap.notice_content=notice.notice_content
              ap.notice_type=notice.notice_type
              ap.notice_importance=notice.notice_importance
              ap.been_read_count=notice.been_read_count
              ap.added_by_user_name=notice.added_by_user_name
            end
          rescue Exception => e
            @@logger.error("#{self}.func_add(#{notice}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_delete(notice_id)
          begin
            Notices[notice_id: notice_id].update(status: 0)
            true
          rescue Exception => e
            @@logger.error("#{self}.func_delete(#{notice_id}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_update(notice)
          begin
            exist_ap=Notices[notice_id: notice.notice_id]
            new_ap=exist_ap.update(
                notice_title:notice.notice_title,
                notice_content:notice.notice_content,
                notice_type:notice.notice_type,
                notice_importance:notice.notice_importance,
                been_read_count:notice.been_read_count
            )
            if new_ap
              new_ap
            else
              exist_ap
            end
          rescue Exception => e
            @@logger.error("#{self}.func_update(#{notice}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_get(notice_id)
          begin
            Notices[notice_id: notice_id]
          rescue Exception => e
            @@logger.error("#{self}.func_get(#{notice_id}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_get_by_id(id)
          begin
            Notices[id: id]
          rescue Exception => e
            @@logger.error("#{self}.func_get_by_id(#{id}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_get_all_by_user_name(user_name)
          begin
            Notices.dataset.where(added_by_user_name:user_name).where(status:1).all
          rescue Exception => e
            @@logger.error("#{self}.func_get_all_by_user_name(#{user_name}) Exception:#{e}")
            nil
          end
        end

        def Notices.func_get_max_notice_id
          begin
            Notices.last.notice_id
          rescue Exception => e
            @@logger.error("#{self}.func_get_max_notice_id Exception:#{e}")
            nil
          end
        end
      end
    end
  end
end