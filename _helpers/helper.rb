module YDAPI
  module Helpers
    class Helper
      @@logger = SYSTEM_LOGGER
      @@config = CONF

      def Helper.new_user_id(base_user_id)
        begin
          @@logger.info("#{self}.new_user_id(#{base_user_id})")
          if base_user_id.to_i > 0
            return "#{base_user_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_user_id(#{base_user_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.new_customer_id(base_customer_id)
        begin
          @@logger.info("#{self}.new_customer_id(#{base_customer_id})")
          if base_customer_id.to_i > 0
            return "#{base_customer_id.to_i + 1}"
          end
          nil
        rescue Exception => e
          @@logger.error("#{self}.new_customer_id(#{base_customer_id}) Exception:#{e}")
          nil
        end
      end

      def Helper.get_scopes_by_user_authority(authority)
        begin
          if authority > 0
            scopes = @@config["authority_scope_#{authority}"]
          else
            nil
          end
        rescue Exception => e
          @@logger.error("#{self}.get_scopes_by_user_authority(#{authority}) Exception:#{e}")
          nil
        end
      end

      def Helper.process_request(req, scope)
        begin
          scopes, user = req.env.values_at :scopes, :user
          username = user['username']

          if scopes.include?(scope)
            yield req, username
          else
            @@logger.info("#{self}.process_request #{req.env["REQUEST_METHOD"]} #{req.fullpath} username=#{username} 403 Forbidden.")
            halt 403
          end
        rescue Exception => e
          @@logger.error("#{self}.process_request #{req.env["REQUEST_METHOD"]} #{req.fullpath} username=#{username} 500 Internal Server Error. Exception:#{e}")
          halt 500
        end
      end
    end
  end
end