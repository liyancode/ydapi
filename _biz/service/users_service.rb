module YDAPI
  module BizService
    class UsersService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER
      @@helper = YDAPI::Helpers::Helper
      @@user_model = YDAPI::BizModel::UsersModel
      get '/sample' do
        process_request(request, 'users_get') do |req, username|
          begin
            p req.body
            'ok'
            content_type :json
            { money: @accounts[username] }.to_json
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # Post/Put /user body
      # {
      #     "user": {
      #         "id": 5,
      #         "user_id": "103",
      #         "user_name": "testname103",
      #         "password": "***",
      #         "authority": 1,
      #         "type": "super",
      #         "status": 1
      #     }
      # }
      post '/user' do
        process_request(request, 'users_add') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            user=user_hash_to_user(body_hash["user"])
            user_employee_info=employeeinfo_hash_to_employee_info(body_hash["user_employee_info"])
            if user
              new_user=@@user_model.add_new_user(user)
              if new_user
                new_user.password='***'
                if user_employee_info
                  user_employee_info.user_id=new_user.user_id
                  new_user_employee_info=@@user_model.add_new_user_employee_info(user_employee_info)
                  if new_user_employee_info
                    status 201
                    content_type :json
                    {user:new_user.values,user_employee_info:new_user_employee_info.values}.to_json
                  else
                    halt 409
                  end
                else
                  halt 409
                end
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user' do
        process_request(request, 'users_update') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            user=user_hash_to_user(body_hash["user"])
            user_employee_info=employeeinfo_hash_to_employee_info(body_hash["user_employee_info"])
            if user
              if user.password=='***'
                user.password=@@user_model.get_user_by_user_name(user.user_name)[:password]
              end
              new_user=@@user_model.update_user(user)
              if new_user
                new_user.password='***'
                if user_employee_info
                  new_user_employee_info=@@user_model.update_user_employee_info(user_employee_info)
                  if new_user_employee_info
                    status 201
                    content_type :json
                    {user:new_user.values,employee_info:new_user_employee_info.values}.to_json
                  else
                    halt 409
                  end
                else
                  halt 400
                end
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/password' do
        process_request(request, 'users_update') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} user_name=#{body_hash['user_name']}")
            user_name=body_hash["user_name"]
            old_password=body_hash["old_password"]
            new_password=body_hash["new_password"]

            user=@@user_model.get_user_by_user_name(user_name)
            if user
              if user[:password]==old_password
                new_user=@@user_model.update_user_password(user_name,new_password)
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
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end



      # Post add user_employee_info
      # {
      #     "employee_info": {
      #         "id": 3,
      #         "user_id": "103",
      #         "full_name": "内马尔",
      #         "gender": 1,
      #         "birthday": "1992-02-05",
      #         "marital_status": null,
      #         "department_id": "d02",
      #         "title": "a3",
      #         "office": "suzhou",
      #         "onboard_at": "2018-06-20",
      #         "position_status": "normal",
      #         "email": "neimaer@yaodichina.cn",
      #         "phone_number": "15700009999",
      #         "address": null,
      #         "hometown": "巴西",
      #         "status": 1
      #     }
      # }
      post '/user_employee_info' do
        process_request(request, 'users_add') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            user_employee_info=employeeinfo_hash_to_employee_info(body_hash["employee_info"])
            if user_employee_info
              new_user_employee_info=@@user_model.add_new_user_employee_info(user_employee_info)
              if new_user_employee_info
                status 201
                content_type :json
                { employee_info:new_user_employee_info.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/user_employee_info' do
        process_request(request, 'users_update') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            user_employee_info=employeeinfo_hash_to_employee_info(body_hash["employee_info"])
            if user_employee_info
              new_user_employee_info=@@user_model.update_user_employee_info(user_employee_info)
              if new_user_employee_info
                content_type :json
                { employee_info:new_user_employee_info.values}.to_json
              else
                halt 409
              end
            else
              halt 400
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get one user by username
      get '/:username' do
        process_request(request, 'users_get') do |req, username|
          begin
            user = @@user_model.get_user_and_employee_info_by_user_name(params[:username])
            if user
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              user[:user][:password]='***'
              content_type :json
              user.to_json
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      get '/all_users/' do
        process_request(request, 'users_get') do |req, username|
          begin
            users = @@user_model.get_all_users
            if users
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              users.to_json
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get one user by username
      delete '/:user_id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            user = @@user_model.delete_user_by_user_id(params[:user_id])
            if user
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 404
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end
      # user_hash:
      # {
      #       "id": 5,
      #       "user_id": "103",
      #       "user_name": "testname103",
      #       "password": "***",
      #       "authority": 1,
      #       "type": "super",
      #       "status": 1
      #}
      def user_hash_to_user(user_hash)
        begin
          if user_hash&&user_hash.class==Hash&&user_hash.keys.size>0
            user=YDAPI::BizEntity::User.new
            user.id=user_hash["id"]
            user.user_id=user_hash["user_id"]
            user.user_name=user_hash["user_name"]
            user.password=user_hash["password"]
            user.authority=user_hash["authority"]
            user.type=user_hash["type"]
            user.status=user_hash["status"]
            user
          else
            nil
          end
        rescue Exception=>e
          nil
        end
      end

      #{
      #         "id": 3,
      #         "user_id": "103",
      #         "full_name": "内马尔",
      #         "gender": 1,
      #         "birthday": "1992-02-05",
      #         "marital_status": null,
      #         "department_id": "d02",
      #         "title": "a3",
      #         "office": "suzhou",
      #         "onboard_at": "2018-06-20",
      #         "position_status": "normal",
      #         "email": "neimaer@yaodichina.cn",
      #         "phone_number": "15700009999",
      #         "address": null,
      #         "hometown": "巴西",
      #         "status": 1
      #     }
      def employeeinfo_hash_to_employee_info(employeeinfo_hash)
        begin
          if employeeinfo_hash&&employeeinfo_hash.class==Hash&&employeeinfo_hash.keys.size>0
            user_employee_info=YDAPI::BizEntity::UserEmployeeInfo.new
            user_employee_info.id=employeeinfo_hash["id"]
            user_employee_info.user_id=employeeinfo_hash["user_id"]
            user_employee_info.full_name=employeeinfo_hash["full_name"]
            user_employee_info.gender=employeeinfo_hash["gender"]
            user_employee_info.birthday=employeeinfo_hash["birthday"]
            user_employee_info.marital_status=employeeinfo_hash["marital_status"]
            user_employee_info.department_id=employeeinfo_hash["department_id"]
            user_employee_info.title=employeeinfo_hash["title"]
            user_employee_info.office=employeeinfo_hash["office"]
            user_employee_info.onboard_at=employeeinfo_hash["onboard_at"]
            user_employee_info.position_status=employeeinfo_hash["position_status"]
            user_employee_info.email=employeeinfo_hash["email"]
            user_employee_info.phone_number=employeeinfo_hash["phone_number"]
            user_employee_info.address=employeeinfo_hash["address"]
            user_employee_info.hometown=employeeinfo_hash["hometown"]
            user_employee_info.status=employeeinfo_hash["status"]
            user_employee_info
          else
            nil
          end
        rescue Exception=>e
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
            p 'scopes.include==true'
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