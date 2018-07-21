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
              # new_customer=@@customers_model.add_new_customer(customer)
              # if new_customer
              #   contact=customer_contact_hash_to_customer_contact(body_hash["contact"])
              #   if contact
              #     contact.customer_id=new_customer.customer_id
              #     contact.added_by_user_name=username
              #     new_contact=@@customers_model.add_new_customer_contact(contact)
              #     if new_contact
              #       status 201
              #       content_type :json
              #       {customer:new_customer.values,contact:new_contact.values}.to_json
              #     else
              #       halt 409
              #     end
              #   else
              #     halt 400
              #   end
              # else
              #   halt 409
              # end
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