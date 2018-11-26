module YDAPI
  module BizService
    class CommonService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER
      @@helper = YDAPI::Helpers::Helper
      @@user_model = YDAPI::BizModel::UsersModel
      @@customers_model = YDAPI::BizModel::CustomersModel
      @@fin_approvals_model = YDAPI::BizModel::FinApprovalsModel

      # user_names: name1,name2,name3
      get '/users/:user_names' do
        process_request(request, 'users_get') do |req, username|
          begin
            user_names_arr=params[:user_names].split(',')
            if user_names_arr.size>0
              result=@@user_model.get_all_users_by_user_names_arr(user_names_arr)
              if result
                content_type :json
                result.to_json
              else
                halt 404
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

      get '/users/contract_sign_users/' do
        process_request(request, 'users_get') do |req, username|
          begin
            users=@@user_model.get_all_users
            if users
              result=[]
              users.each{|u|
                result<<{
                  :user_id=>u[:user][:user_id],
                  :user_name=>u[:user][:user_name],
                  :full_name=>u[:employee_info][:full_name],
                  :department_id=>u[:employee_info][:department_id],
                  :title=>u[:employee_info][:title]
                }
              }
              content_type :json
              result.to_json
            else
              halt 404
            end
          rescue Exception=>e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # user_names: name1,name2,name3
      get '/customers/:customer_ids' do
        process_request(request, 'users_get') do |req, username|
          begin
            customer_ids_arr=params[:customer_ids].split(',')
            if customer_ids_arr.size>0
              result=@@customers_model.get_customers_by_id_arr(customer_ids_arr)
              if result
                content_type :json
                result.to_json
              else
                halt 404
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

      # 
      get '/fin_approvals/count/:result' do
        process_request(request, 'users_get') do |req, username|
          begin
            fin_approvals=@@fin_approvals_model.get_fin_approvals_by_result(params[:result])
            if fin_approvals
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              # fin_approvals.to_json
              {:count=>fin_approvals[:fin_approvals].size}.to_json
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