module YDAPI
  module BizService
    class FinService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@fin_approvals_model = YDAPI::BizModel::FinApprovalsModel
      @@orders_model=YDAPI::BizModel::OrdersModel

# {
#     "ref_id": "470002",
#     "updated_by_user_name": "admin",
#     "approval_result": "pass",
#     "added_by_user_name": "admin",
#     "fin_approval_id": "1230001",
#     "last_update_at": "2018-11-24 10:26:59 +0800",
#     "created_at": "2018-11-24 10:26:59 +0800",
#     "comment": "yes",
#     "id": 1,
#     "type": "ask_price",
#     "status": 1
# }
      post '/fin_approval' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            fin_approval = fin_approval_hash_to_fin_approval(body_hash)
            fin_approval.added_by_user_name = username
            fin_approval.updated_by_user_name = username
            if fin_approval
              new_fin_approval = @@fin_approvals_model.add_new_fin_approval(fin_approval)
              if new_fin_approval
                status 201
                content_type :json
                {fin_approval: new_fin_approval.values}.to_json
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

      delete '/fin_approval/:fin_approval_id' do
        process_request(request, 'users_get') do |req, username|
          begin
          	@@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} user=#{username}")
            fin_approval=@@fin_approvals_model.delete_fin_approval_by_fin_approval_id(params[:fin_approval_id])
            if fin_approval
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

      put '/fin_approval' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            fin_approval = fin_approval_hash_to_fin_approval(body_hash)
            fin_approval.updated_by_user_name = username
            if fin_approval
              new_fin_approval = @@fin_approvals_model.update_fin_approval(fin_approval)
              if new_fin_approval
                begin
                  if new_fin_approval.type=='ask_price'
                    @@orders_model.update_ask_price_approve_status(new_fin_approval.ref_id,new_fin_approval.approval_result,username)
                  end
                rescue Exception=>e
                  p e
                end
                status 201
                content_type :json
                {fin_approval: new_fin_approval.values}.to_json
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

      get '/fin_approval/:fin_approval_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            fin_approval=@@fin_approvals_model.get_fin_approval_by_fin_approval_id(params[:fin_approval_id])
            if fin_approval
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              fin_approval.to_json
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

      get '/fin_approvals/type/:type' do
        process_request(request, 'users_get') do |req, username|
          begin
            fin_approvals=@@fin_approvals_model.get_fin_approvals_by_type(params[:type])
            if fin_approvals
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              fin_approvals.to_json
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

      get '/fin_approvals/type/:type/result/:result' do
        process_request(request, 'users_get') do |req, username|
          begin
            fin_approvals=@@fin_approvals_model.get_fin_approvals_by_type_and_result(params[:type],params[:result])
            if fin_approvals
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              fin_approvals.to_json
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

# {
#     "ref_id": "470002",
#     "updated_by_user_name": "admin",
#     "approval_result": "pass",
#     "added_by_user_name": "admin",
#     "fin_approval_id": "1230001",
#     "last_update_at": "2018-11-24 10:26:59 +0800",
#     "created_at": "2018-11-24 10:26:59 +0800",
#     "comment": "yes",
#     "id": 1,
#     "type": "ask_price",
#     "status": 1
# }
      def fin_approval_hash_to_fin_approval(fin_approval_hash)
        begin
          if fin_approval_hash && fin_approval_hash.class == Hash && fin_approval_hash.keys.size > 0
            fin_approval = YDAPI::BizEntity::FinApproval.new
            fin_approval.id = fin_approval_hash["id"]
            fin_approval.fin_approval_id = fin_approval_hash["fin_approval_id"]
            fin_approval.ref_id = fin_approval_hash["ref_id"]
            fin_approval.type = fin_approval_hash["type"]
            fin_approval.approval_result = fin_approval_hash["approval_result"]
            fin_approval.added_by_user_name = fin_approval_hash["added_by_user_name"]
            fin_approval.updated_by_user_name = fin_approval_hash["updated_by_user_name"]
            fin_approval.comment = fin_approval_hash["comment"]
            fin_approval.status = fin_approval_hash["status"]
            fin_approval
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