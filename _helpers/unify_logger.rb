module YDAPI
  module Helpers
    class UnifyLogger
      def initialize(logger)
        @logger=logger
      end

      def http_status_msg(status_code)
        if status_code==200
          "200 OK"
        elsif status_code==201
          "201 Created"
        elsif status_code==400
          "400 Bad Request"
        elsif status_code==401
          "401 Unauthorized"
        elsif status_code==403
          "403 Forbidden"
        elsif status_code==404
          "404 Not Found"
        elsif status_code==409
          "409 Conflict"
        elsif status_code==500
          "500 Internal Server Error"
        end
      end
      def _service_log(level,log_id,class_name,request,username,status_code,exception=nil)
        begin
          if level=='info'
            @logger.info("[#{log_id}] #{class_name} #{request.env["REQUEST_METHOD"]} #{request.fullpath} username=#{username} #{http_status_msg(status_code)}.")
          elsif level=='error'
            @logger.error("[#{log_id}] #{class_name} #{request.env["REQUEST_METHOD"]} #{request.fullpath} username=#{username} #{http_status_msg(status_code)}. Exception:#{exception}")
          else
          #   nothing
          end
        rescue Exception=>e

        end
      end
    end
  end
end