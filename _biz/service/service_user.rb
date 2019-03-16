module YDAPI
  module BizService
    class Service_User < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@helper=YDAPI::Helpers::Helper
      @@model_user = YDAPI::BizModel::Model_User
      @@bcrypt_util = YDAPI::Helpers::BcryptUtil

      #===== /user_account/*
      get '/_hb_/' do
        process_request(request, '_hb_') do |req, username|
          begin
            p request.ip
            content_type :json
            {:ts=>Time.now.to_i}.to_json
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_account/*
      get '/user_account/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_account_by_user_name(params[:user_name])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item[:password] = "***"
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/full_info/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            user_account = @@model_user.get_user_account_by_user_name(params[:user_name])
            if user_account
              user_employee_info=@@model_user.get_user_employee_info_by_user_name(params[:user_name])
              user_department=@@model_user.get_user_department_by_department_id(user_employee_info[:department_id])
              user_private_info=@@model_user.get_user_private_info_by_user_name(params[:user_name])
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              user_account[:password] = "***"
              {
                  :user_account=>user_account.values,
                  :user_employee_info=>user_employee_info.values,
                  :user_department=>user_department.values,
                  :user_private_info=>user_private_info.values
              }.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/user_account/check_user_name/un/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_account_by_user_name(params[:user_name])
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
            if item
              content_type :json
              {:user_name=>params[:user_name],:is_available=>false}.to_json
            else
              {:user_name=>params[:user_name],:is_available=>true}.to_json
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_account' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["user_name"]}")
            user_account = meta_hash_to_user_account(body_hash)
            user_account.created_by = username
            user_account.last_update_by = username
            user_account.password = @@bcrypt_util.bcrypt_plain_password(user_account.password)
            if user_account
              new_user_account = @@model_user.add_user_account(user_account)
              if new_user_account
                status 201
                content_type :json
                new_user_account[:password] = "***"
                {user_account: new_user_account.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_account_employee_private_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            user_account_hash=body_hash["user_account"]
            user_employee_info_hash=body_hash["user_employee_info"]
            user_private_info_hash=body_hash["user_private_info"]

            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{user_account_hash["user_name"]}")
            user_account = meta_hash_to_user_account(user_account_hash)
            user_account.created_by = username
            user_account.last_update_by = username
            user_account.password = @@bcrypt_util.bcrypt_plain_password(user_account.password)
            if user_account
              new_user_account = @@model_user.add_user_account(user_account)
              if new_user_account
                user_employee_info = meta_hash_to_user_employee_info(user_employee_info_hash)
                user_employee_info.created_by = username
                user_employee_info.last_update_by = username
                new_user_employee_info=@@model_user.add_user_employee_info(user_employee_info)

                user_private_info = meta_hash_to_user_private_info(user_private_info_hash)
                user_private_info.created_by = username
                user_private_info.last_update_by = username
                new_user_private_info=@@model_user.add_user_private_info(user_private_info)

                status 201
                content_type :json
                new_user_account[:password] = "***"
                {
                    user_account: new_user_account.values,
                    user_employee_info:new_user_employee_info.values,
                    user_private_info:new_user_private_info.values
                }.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_account_employee_private_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            user_account_hash=body_hash["user_account"]
            user_employee_info_hash=body_hash["user_employee_info"]
            user_private_info_hash=body_hash["user_private_info"]

            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{user_account_hash["user_name"]}")
            user_account = meta_hash_to_user_account(user_account_hash)
            user_account.last_update_by = username
            user_account.password = @@bcrypt_util.bcrypt_plain_password(user_account.password)
            if user_account
              new_user_account = @@model_user.update_user_account(user_account)
              if new_user_account
                user_employee_info = meta_hash_to_user_employee_info(user_employee_info_hash)
                user_employee_info.last_update_by = username
                new_user_employee_info=@@model_user.update_user_employee_info(user_employee_info)

                user_private_info = meta_hash_to_user_private_info(user_private_info_hash)
                user_private_info.last_update_by = username
                new_user_private_info=@@model_user.update_user_private_info(user_private_info)

                status 201
                content_type :json
                new_user_account[:password] = "***"
                {
                    user_account: new_user_account.values,
                    user_employee_info:new_user_employee_info.values,
                    user_private_info:new_user_private_info.values
                }.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # admin only
      put '/user_account' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            user_account = meta_hash_to_user_account(body_hash)
            user_account.last_update_by = username
            user_account.password = @@bcrypt_util.bcrypt_plain_password(user_account.password)
            if user_account
              new_user_account = @@model_user.update_user_account(user_account)
              if new_user_account
                status 201
                new_user_account[:password] = "***"
                content_type :json
                {user_account: new_user_account.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get one user by username
      delete '/user_account/:user_name' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_account_by_user_name(params[:user_name])
            if item
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
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

      # user self change password
      put '/user_account/password' do
        process_request(request, 'users_update') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} user_name=#{body_hash['user_name']}")
            user_name = body_hash["user_name"]
            old_password = body_hash["old_password"]
            new_password = body_hash["new_password"]

            user_account = @@model_user.get_user_account_by_user_name(user_name)
            if user_account
              if @@bcrypt_util.check_password(old_password, user_account.password)
                new_user = @@model_user.update_user_account_password(user_name, @@bcrypt_util.bcrypt_plain_password(new_password))
                if new_user
                  status 201
                else
                  halt 409
                end
              else
                halt 400
              end
            else
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_authority/*
      get '/user_authority/:authority' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_authority_by_authority(params[:authority])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_authority' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_authority(body_hash)
            if item
              item.created_by = username
              item.last_update_by = username
              new_item = @@model_user.add_user_authority(item)
              if new_item
                status 201
                content_type :json
                {user_authority: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_authority' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_authority(body_hash)
            if item
              item.last_update_by = username
              new_item = @@model_user.update_user_authority(item)
              if new_item
                status 201
                content_type :json
                {user_authority: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/user_authority/:authority' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_authority_by_authority(params[:authority])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_department/*
      get '/user_department/:department_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_department_by_department_id(params[:department_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/user_department/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_user.get_all_user_departments
            if items
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              items.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_department' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_department(body_hash)
            if item
              item.created_by = username
              item.last_update_by = username
              new_item = @@model_user.add_user_department(item)
              if new_item
                status 201
                content_type :json
                {user_department: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_department' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_department(body_hash)
            if item
              item.last_update_by = username
              new_item = @@model_user.update_user_department(item)
              if new_item
                status 201
                content_type :json
                {user_department: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/user_department/:department_id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_department_by_department_id(params[:department_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_employee_info/*
      get '/user_employee_info/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_employee_info_by_user_name(params[:user_name])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_employee_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_employee_info(body_hash)
            if item
              item.created_by = username
              item.last_update_by = username
              new_item = @@model_user.add_user_employee_info(item)
              if new_item
                status 201
                content_type :json
                {user_employee_info: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_employee_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_employee_info(body_hash)
            if item
              item.last_update_by = username
              new_item = @@model_user.update_user_employee_info(item)
              if new_item
                status 201
                content_type :json
                {user_employee_info: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/user_employee_info/:user_name' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_employee_info_by_user_name(params[:user_name])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_private_info/*
      get '/user_private_info/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_private_info_by_user_name(params[:user_name])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_private_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_private_info(body_hash)
            if item
              item.created_by = username
              item.last_update_by = username
              new_item = @@model_user.add_user_private_info(item)
              if new_item
                status 201
                content_type :json
                {user_private_info: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_private_info' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_private_info(body_hash)
            if item
              item.last_update_by = username
              new_item = @@model_user.update_user_private_info(item)
              if new_item
                status 201
                content_type :json
                {user_private_info: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/user_private_info/:user_name' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_private_info_by_user_name(params[:user_name])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      #===== /user_application/*
      get '/user_application/:application_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_user.get_user_application_by_application_id(params[:application_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.values.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      post '/user_application' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_application(body_hash)
            if item
              item.created_by = username
              item.user_name = username
              item.application_id=@@helper.generate_application_id
              item.last_update_by = username
              item.approve_by=@@model_user.get_report_to_by_user_name(username)
              new_item = @@model_user.add_user_application(item)
              if new_item
                status 201
                content_type :json
                {user_application: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_application' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            item = meta_hash_to_user_application(body_hash)
            if item
              item.last_update_by = username
              new_item = @@model_user.update_user_application(item)
              if new_item
                status 201
                content_type :json
                {user_private_info: new_item.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      delete '/user_application/:application_id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_user.delete_user_application_by_application_id(params[:application_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/user_application/list/by_user_name/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_user.get_all_user_application_by_user_name(params[:user_name])
            if items
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              items.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/user_application/list/by_approve_by/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_user.get_all_user_application_by_approve_by(params[:user_name])
            if items
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              items.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # ====== list
      get '/list/by_department_id/:department_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_user.get_user_list_by_department_id(params[:department_id])
            if items
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              items.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/list/for_admin' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_user.get_user_list_for_admin
            if items
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              items.to_json
            else
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end
      #===== hash to obj functions

      def meta_hash_to_user_account(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserAccount.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.user_name = meta_hash["user_name"]
            dest_obj.password = meta_hash["password"]
            dest_obj.authorities = meta_hash["authorities"]
            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_user_authority(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserAuthority.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.authority = meta_hash["authority"]
            dest_obj.authority_cn = meta_hash["authority_cn"]
            dest_obj.scope = meta_hash["scope"]
            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_user_department(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserDepartment.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.department_id = meta_hash["department_id"]
            dest_obj.parent_department_id = meta_hash["parent_department_id"]
            dest_obj.department_name = meta_hash["department_name"]
            dest_obj.department_manager = meta_hash["department_manager"]
            dest_obj.department_employee_count = meta_hash["department_employee_count"]
            dest_obj.department_description = meta_hash["department_description"]
            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_user_employee_info(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserEmployeeInfo.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.department_id = meta_hash["department_id"]
            dest_obj.user_name = meta_hash["user_name"]
            dest_obj.employee_number = meta_hash["employee_number"]
            dest_obj.employee_type = meta_hash["employee_type"]
            dest_obj.title = meta_hash["title"]
            dest_obj.level = meta_hash["level"]
            dest_obj.report_to = meta_hash["report_to"]
            dest_obj.sub_tel_number = meta_hash["sub_tel_number"]
            dest_obj.cm_group_short_number = meta_hash["cm_group_short_number"]
            dest_obj.attendance_number = meta_hash["attendance_number"]
            dest_obj.entrance_card_number = meta_hash["entrance_card_number"]
            dest_obj.bank_card_number = meta_hash["bank_card_number"]
            dest_obj.bank_card_belong_to = meta_hash["bank_card_belong_to"]
            dest_obj.onboard_date = meta_hash["onboard_date"]
            dest_obj.resignation_date = meta_hash["resignation_date"]
            dest_obj.employee_status = meta_hash["employee_status"]
            dest_obj.annual_leave_left = meta_hash["annual_leave_left"]
            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_user_private_info(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserPrivateInfo.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.user_name = meta_hash["user_name"]
            dest_obj.full_name = meta_hash["full_name"]
            dest_obj.gender = meta_hash["gender"]
            dest_obj.age = meta_hash["age"]
            dest_obj.personal_id = meta_hash["personal_id"]
            dest_obj.phone_number = meta_hash["phone_number"]
            dest_obj.wechat = meta_hash["wechat"]
            dest_obj.qq = meta_hash["qq"]
            dest_obj.dingding = meta_hash["dingding"]
            dest_obj.email = meta_hash["email"]
            dest_obj.address = meta_hash["address"]
            dest_obj.hometown = meta_hash["hometown"]
            dest_obj.birthday = meta_hash["birthday"]
            dest_obj.graduated_school = meta_hash["graduated_school"]
            dest_obj.education = meta_hash["education"]
            dest_obj.discipline = meta_hash["discipline"]
            dest_obj.hobbies = meta_hash["hobbies"]
            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_user_application(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::UserApplication.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.application_id = meta_hash["application_id"]
            dest_obj.user_name = meta_hash["user_name"]
            dest_obj.type = meta_hash["type"]
            dest_obj.description = meta_hash["description"]
            dest_obj.approve_by = meta_hash["approve_by"]
            dest_obj.approve_status = meta_hash["approve_status"]
            dest_obj
          else
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