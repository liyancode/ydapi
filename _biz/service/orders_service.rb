module YDAPI
  module BizService
    class OrdersService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@orders_model=YDAPI::BizModel::OrdersModel

      # {
      #     "id": 1,
      #     "ask_price_id": "470001",
      #     "added_by_user_name": "testname105",
      #     "customer_id": "214",
      #     "product_ids": "20001,20002,20003",
      #     "description": "20001定价100，20003定价120",
      #     "approve_status": "waiting",
      #     "approve_by_user_name": null,
      #     "comment": null,
      #     "created_at": "2018-07-21 19:50:56 +0800",
      #     "last_update_at": "2018-07-21 19:50:56 +0800",
      #     "status": 1
      # }
      post '/ask_prices/ask_price' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            ask_price=ask_price_hash_to_ask_price(body_hash)
            ask_price.added_by_user_name=username
            if ask_price
              new_ask_price = @@orders_model.add_new_ask_price(ask_price)
              if new_ask_price
                status 201
                content_type :json
                {ask_price: new_ask_price.values}.to_json
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

      delete '/ask_prices/ask_price/:ask_price_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            ask_price=@@orders_model.delete_ask_price_by_ask_price_id(params[:ask_price_id])
            if ask_price
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

      put '/ask_prices/ask_price' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            ask_price = ask_price_hash_to_ask_price(body_hash)
            ask_price.added_by_user_name = username
            if ask_price
              new_ask_price = @@orders_model.update_ask_price(ask_price)
              if new_ask_price
                status 201
                content_type :json
                {ask_price: new_ask_price.values}.to_json
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

      get '/ask_prices/ask_price/:ask_price_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_ask_price_by_ask_price_id(params[:ask_price_id])
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              {:ask_price=>result.values}.to_json
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

      get '/ask_prices/by_user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_ask_prices_by_user_name(username)
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      # ---- contract
      # {
      #             "id": 1,
      #             "contract_id": "880001",
      #             "added_by_user_name": "testname105",
      #             "sign_by_user_name": "testname105",
      #             "customer_id": "215",
      #             "sign_at": "2018-07-01",
      #             "start_date": "2018-07-10",
      #             "end_date": "2019-05-01",
      #             "total_value": "1500000",
      #             "description": "这是一个测试合同",
      #             "contract_status": 1,
      #             "comment": "测试",
      #             "created_at": "2018-07-23 22:54:33 +0800",
      #             "last_update_at": "2018-07-23 22:54:33 +0800",
      #             "status": 1
      #         }
      post '/contracts/contract' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            contract=contract_hash_to_contract(body_hash)
            contract.added_by_user_name=username
            if contract
              new_contract = @@orders_model.add_new_contract(contract)
              if new_contract
                status 201
                content_type :json
                {contract: new_contract.values}.to_json
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

      delete '/contracts/contract/:contract_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            contract=@@orders_model.delete_contract_by_contract_id(params[:contract_id])
            if contract
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

      put '/contracts/contract' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            contract = contract_hash_to_contract(body_hash)
            contract.added_by_user_name = username
            if contract
              new_contract = @@orders_model.update_contract(contract)
              if new_contract
                status 201
                content_type :json
                {contract: new_contract.values}.to_json
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

      get '/contracts/contract/:contract_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_contract_by_contract_id(params[:contract_id])
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              {:contract=>result.values}.to_json
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

      get '/contracts/by_user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_contracts_by_user_name(username)
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      get '/contracts/by_sign_user/:sign_user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_contracts_by_sign_user_name(params[:sign_user_name])
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      # ---- orders ----
      # {
      #             "id": 1,
      #             "order_id": "660001",
      #             "added_by_user_name": "testname105",
      #             "contract_id": "880001",
      #             "sign_by_user_name": "testname105",
      #             "customer_id": "215",
      #             "start_date": "2018-08-01",
      #             "end_date": "2019-09-01",
      #             "total_value": "1890000",
      #             "pay_type": "fenqi",
      #             "paid_value": "500000",
      #             "order_status": "start",
      #             "order_status_update_by": "admin",
      #             "is_finished": 0,
      #             "description": "测试订单",
      #             "comment": null,
      #             "created_at": "2018-07-24 21:50:36 +0800",
      #             "last_update_at": "2018-07-24 21:50:36 +0800",
      #             "status": 1
      #         }
      post '/order' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            order=order_hash_to_order(body_hash)
            order.added_by_user_name=username
            order.order_status_update_by=username
            if order
              new_order = @@orders_model.add_new_order(order)
              if new_order
                status 201
                content_type :json
                {order: new_order.values}.to_json
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

      delete '/order/:order_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            order=@@orders_model.delete_order_by_order_id(params[:order_id])
            if order
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

      put '/order' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            order = order_hash_to_order(body_hash)
            order.order_status_update_by = username
            if order
              new_order = @@orders_model.update_order(order)
              if new_order
                status 201
                content_type :json
                {order: new_order.values}.to_json
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

      get '/order/:order_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_order_by_order_id(params[:order_id])
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              {:order=>result.values}.to_json
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

      get '/by_user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_orders_by_user_name(username)
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      get '/by_sign_user/:sign_user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            result=@@orders_model.get_orders_by_sign_user_name(params[:sign_user_name])
            if result
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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
      #     "id": 1,
      #     "ask_price_id": "470001",
      #     "added_by_user_name": "testname105",
      #     "customer_id": "214",
      #     "product_ids": "20001,20002,20003",
      #     "description": "20001定价100，20003定价120",
      #     "approve_status": "waiting",
      #     "approve_by_user_name": null,
      #     "comment": null,
      #     "created_at": "2018-07-21 19:50:56 +0800",
      #     "last_update_at": "2018-07-21 19:50:56 +0800",
      #     "status": 1
      # }
      def ask_price_hash_to_ask_price(ask_price_hash)
        begin
          if ask_price_hash && ask_price_hash.class == Hash && ask_price_hash.keys.size > 0
            ask_price=YDAPI::BizEntity::AskPrice.new
            ask_price.id=ask_price_hash["id"]
            ask_price.ask_price_id=ask_price_hash["ask_price_id"]
            ask_price.added_by_user_name=ask_price_hash["added_by_user_name"]
            ask_price.customer_id=ask_price_hash["customer_id"]
            ask_price.product_ids=ask_price_hash["product_ids"]
            ask_price.description=ask_price_hash["description"]
            ask_price.approve_status=ask_price_hash["approve_status"]
            ask_price.approve_by_user_name=ask_price_hash["approve_by_user_name"]
            ask_price.comment=ask_price_hash["comment"]
            ask_price.status=ask_price_hash["status"]
            ask_price
          else
            nil
          end
        rescue Exception => e
          nil
        end
      end

      def contract_hash_to_contract(contract_hash)
        begin
          if contract_hash && contract_hash.class == Hash && contract_hash.keys.size > 0
            contract=YDAPI::BizEntity::Contract.new
            contract.id=contract_hash["id"]
            contract.contract_id=contract_hash["contract_id"]
            contract.added_by_user_name=contract_hash["added_by_user_name"]
            contract.sign_by_user_name=contract_hash["sign_by_user_name"]
            contract.customer_id=contract_hash["customer_id"]
            contract.sign_at=contract_hash["sign_at"]
            contract.start_date=contract_hash["start_date"]
            contract.end_date=contract_hash["end_date"]
            contract.total_value=contract_hash["total_value"]
            contract.description=contract_hash["description"]
            contract.contract_status=contract_hash["contract_status"]
            contract.comment=contract_hash["comment"]
            contract.status=contract_hash["status"]
            contract
          else
            nil
          end
        rescue Exception => e
          nil
        end
      end

      def order_hash_to_order(order_hash)
        begin
          if order_hash && order_hash.class == Hash && order_hash.keys.size > 0
            order=YDAPI::BizEntity::Order.new
            order.id=order_hash["id"]
            order.order_id=order_hash["order_id"]
            order.added_by_user_name=order_hash["added_by_user_name"]
            order.contract_id=order_hash["contract_id"]
            order.sign_by_user_name=order_hash["sign_by_user_name"]
            order.customer_id=order_hash["customer_id"]
            order.start_date=order_hash["start_date"]
            order.end_date=order_hash["end_date"]
            order.total_value=order_hash["total_value"]
            order.pay_type=order_hash["pay_type"]
            order.paid_value=order_hash["paid_value"]
            order.order_status=order_hash["order_status"]
            order.order_status_update_by=order_hash["order_status_update_by"]
            order.description=order_hash["description"]
            order.is_finished=order_hash["is_finished"]
            order.comment=order_hash["comment"]
            order.status=order_hash["status"]
            order
          else
            nil
          end
        rescue Exception => e
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