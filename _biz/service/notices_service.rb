module YDAPI
  module BizService
    class NoticesService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@notices_model = YDAPI::BizModel::NoticesModel

#       {
#     "id": 1,
#     "notice_id": "9990001",
#     "notice_title": "test notice",
#     "notice_content": "10.29 outing",
#     "notice_type": "global",
#     "notice_importance": 0,
#     "been_read_count": 1,
#     "added_by_user_name": "admin",
#     "created_at": "2018-10-16 17:48:02 +0800",
#     "last_update_at": "2018-10-16 17:48:02 +0800",
#     "status": 1
#     }
      post '/notice' do
        process_request(request, 'users_get') do |req, username|
          begin
            p body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            p notice = notice_hash_to_notice(body_hash)
            notice.added_by_user_name = username
            if notice
              new_notice = @@notices_model.add_new_notice(notice)
              if new_notice
                status 201
                content_type :json
                {notice: new_notice.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/notice/:notice_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            notice=@@notices_model.delete_notice_by_notice_id(params[:notice_id])
            if notice
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 200
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/notice' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            notice = notice_hash_to_notice(body_hash)
            notice.added_by_user_name = username
            if notice
              new_notice = @@notices_model.update_notice(notice)
              if new_notice
                status 201
                content_type :json
                {notice: new_notice.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/notice/:notice_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            notice=@@notices_model.get_notice_by_notice_id(params[:notice_id])
            if notice
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              notice.to_json
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get '/:notice_type_id' do
      #   process_request(request, 'users_get') do |req, username|
      #     begin
      #       notices=@@notices_model.get_notices_by_notice_type_id(params[:notice_type_id])
      #       if notices
      #         @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
      #         content_type :json
      #         notices.to_json
      #       else
      #         @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
      #         halt 404
      #       end
      #     rescue Exception => e
      #       @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
      #       halt 500
      #     end
      #   end
      # end

      get '/' do
        process_request(request, 'users_get') do |req, username|
          begin
            notices=@@notices_model.get_notices_by_user_name('admin')
            if notices
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              notices.to_json
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/notice_types/' do
        process_request(request, 'users_get') do |req, username|
          begin
            notice_types=@@notices_model.get_all_notice_types
            if notice_types
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              notice_types.to_json
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # ======
      # test upload file
      post '/notice/upload_img/:notice_id'do
        
        process_request(request, 'users_get') do |req, username|
          begin
            to_dest_folder="#{CONF['img_dir_notice_detail']}/notices_img/#{params[:notice_id]}"
            tempfile = params['file'][:tempfile]
            filename = params['file'][:filename]
            type=filename.split('.')[-1]

            unless File.directory?(to_dest_folder)
              FileUtils.mkdir_p(to_dest_folder)
            end

            File.open("#{to_dest_folder}/#{params[:notice_id]}.#{type}", 'wb') do |f|
              f.write(tempfile.read)
            end
            status 201
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end 
        end
      end

      #       {
#     "id": 1,
#     "notice_id": "9990001",
#     "notice_title": "test notice",
#     "notice_content": "10.29 outing",
#     "notice_type": "global",
#     "notice_importance": 0,
#     "been_read_count": 1,
#     "added_by_user_name": "admin",
#     "created_at": "2018-10-16 17:48:02 +0800",
#     "last_update_at": "2018-10-16 17:48:02 +0800",
#     "status": 1
#     }
      def notice_hash_to_notice(notice_hash)
        begin
          if notice_hash && notice_hash.class == Hash && notice_hash.keys.size > 0
            notice = YDAPI::BizEntity::Notice.new
            notice.id = notice_hash["id"]
            notice.notice_id = notice_hash["notice_id"]
            notice.added_by_user_name = notice_hash["added_by_user_name"]
            notice.notice_title = notice_hash["notice_title"]
            notice.notice_content = notice_hash["notice_content"]
            notice.notice_type = notice_hash["notice_type"]
            notice.notice_importance = notice_hash["notice_importance"]
            notice.been_read_count = notice_hash["been_read_count"]
            notice.status = notice_hash["status"]
            notice
          else
            p 'fdsafas'
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      # =============================
      def process_request(req, scope)
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