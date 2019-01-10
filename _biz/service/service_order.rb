module YDAPI
  module BizService
    class Service_Order < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@helper=YDAPI::Helpers::Helper
      @@model_order = YDAPI::BizModel::Model_Order

      #===== /order_contract/*
      get '/order_contract/:contract_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_order.get_order_contract_by_contract_id(params[:contract_id])
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

      post '/order_contract' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_order_contract(body_hash)
            obj.created_by = username
            obj.last_update_by = username
            obj.contract_id = @@helper.generate_contract_id

            if obj
              new_obj = @@model_order.add_order_contract(obj)
              if new_obj
                status 201
                content_type :json
                {order_contract: new_obj.values}.to_json
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

      put '/order_contract' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_order_contract(body_hash)
            obj.last_update_by = username

            if obj
              new_obj = @@model_order.update_order_contract(obj)
              if new_obj
                status 201
                content_type :json
                {order_contract: new_obj.values}.to_json
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
      delete '/order_contract/:contract_id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_order.delete_order_contract_by_contract_id(params[:contract_id])
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

      #===== /order_contract_product_item_fengguan/*
      get '/order_contract_product_item_fengguan/:contract_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_order.get_order_contract_product_item_fengguans_by_contract_id(params[:contract_id])
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

      post '/order_contract_product_item_fengguan' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_order_contract_product_item_fengguan(body_hash)
            obj.created_by = username
            obj.last_update_by = username

            if obj
              new_obj = @@model_order.add_order_contract_product_item_fengguan(obj)
              if new_obj
                status 201
                content_type :json
                {order_contract_product_item_fengguan: new_obj.values}.to_json
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

      put '/order_contract_product_item_fengguan' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_order_contract_product_item_fengguan(body_hash)
            obj.last_update_by = username

            if obj
              new_obj = @@model_order.update_order_contract_product_item_fengguan(obj)
              if new_obj
                status 201
                content_type :json
                {order_contract_product_item_fengguan: new_obj.values}.to_json
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

      delete '/order_contract_product_item_fengguan/:id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_order.delete_order_contract_product_item_fengguan_by_id(params[:id])
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

      #===== /payment_history/*
      get '/payment_history/:payment_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_order.get_payment_history_payment_id(params[:payment_id])
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

      get '/payment_history/list/by_contract_id/:contract_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_order.get_payment_histories_by_contract_id(params[:contract_id])
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

      post '/payment_history' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_payment_history(body_hash)
            obj.created_by = username
            obj.last_update_by = username

            if obj
              new_obj = @@model_order.add_payment_history(obj)
              if new_obj
                status 201
                content_type :json
                {payment_history: new_obj.values}.to_json
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

      put '/payment_history' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_payment_history(body_hash)
            obj.last_update_by = username

            if obj
              new_obj = @@model_order.update_payment_history(obj)
              if new_obj
                status 201
                content_type :json
                {payment_history: new_obj.values}.to_json
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

      delete '/payment_history/:payment_id' do
        process_request(request, 'users_delete') do |req, username|
          begin
            item = @@model_order.delete_payment_history_by_payment_id(params[:payment_id])
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

      # === json to obj
      def meta_hash_to_order_contract(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::OrderContract.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.contract_id = meta_hash["contract_id"]
            dest_obj.type = meta_hash["type"]

            dest_obj.a_customer_id = meta_hash["a_customer_id"]
            dest_obj.a_name = meta_hash["a_name"]
            dest_obj.a_address = meta_hash["a_address"]
            dest_obj.a_tax_qualification = meta_hash["a_tax_qualification"]
            dest_obj.a_tax_number = meta_hash["a_tax_number"]
            dest_obj.a_bankcard_number = meta_hash["a_bankcard_number"]
            dest_obj.a_bankcard_location = meta_hash["a_bankcard_location"]
            dest_obj.a_principal_name = meta_hash["a_principal_name"]
            dest_obj.a_principal_phone_number = meta_hash["a_principal_phone_number"]
            dest_obj.a_principal_email = meta_hash["a_principal_email"]
            dest_obj.a_principal_other_contact = meta_hash["a_principal_other_contact"]

            dest_obj.b_customer_id = meta_hash["b_customer_id"]
            dest_obj.b_name = meta_hash["b_name"]
            dest_obj.b_address = meta_hash["b_address"]
            dest_obj.b_tax_qualification = meta_hash["b_tax_qualification"]
            dest_obj.b_tax_number = meta_hash["b_tax_number"]
            dest_obj.b_bankcard_number = meta_hash["b_bankcard_number"]
            dest_obj.b_bankcard_location = meta_hash["b_bankcard_location"]
            dest_obj.b_principal_name = meta_hash["b_principal_name"]
            dest_obj.b_principal_phone_number = meta_hash["b_principal_phone_number"]
            dest_obj.b_principal_email = meta_hash["b_principal_email"]
            dest_obj.b_principal_other_contact = meta_hash["b_principal_other_contact"]

            dest_obj.sign_date = meta_hash["sign_date"]
            dest_obj.sign_location = meta_hash["sign_location"]
            dest_obj.start_date = meta_hash["start_date"]
            dest_obj.end_date = meta_hash["end_date"]
            dest_obj.payment_total = meta_hash["payment_total"]
            dest_obj.payment_currency = meta_hash["payment_currency"]
            dest_obj.payment_type = meta_hash["payment_type"]
            dest_obj.payment_paid = meta_hash["payment_paid"]
            dest_obj.contract_detail_product_items = meta_hash["contract_detail_product_items"]
            dest_obj.contract_detail_content = meta_hash["contract_detail_content"]
            dest_obj.contract_status = meta_hash["contract_status"]
            dest_obj.review_by = meta_hash["review_by"]
            dest_obj.review_status = meta_hash["review_status"]
            dest_obj.review_comment = meta_hash["review_comment"]

            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_order_contract_product_item_fengguan(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::OrderContractProductItemFengguan.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.contract_id = meta_hash["contract_id"]
            dest_obj.product_id = meta_hash["product_id"]
            dest_obj.product_name = meta_hash["product_name"]
            dest_obj.item_id = meta_hash["item_id"]
            dest_obj.item_shape = meta_hash["item_shape"]
            dest_obj.measure_unit = meta_hash["measure_unit"]
            dest_obj.square_meter = meta_hash["square_meter"]
            dest_obj.unit_price_rmb = meta_hash["unit_price_rmb"]
            dest_obj.unit_price_usd = meta_hash["unit_price_usd"]
            dest_obj.item_count = meta_hash["item_count"]
            dest_obj.item_amount_price_rmb = meta_hash["item_amount_price_rmb"]
            dest_obj.item_amount_price_usd = meta_hash["item_amount_price_usd"]
            dest_obj.item_comment = meta_hash["item_comment"]

            dest_obj
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_payment_history(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::OrderContractProductItemFengguan.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.payment_id = meta_hash["payment_id"]
            dest_obj.type = meta_hash["type"]
            dest_obj.type_comment = meta_hash["type_comment"]
            dest_obj.contract_id = meta_hash["contract_id"]
            dest_obj.other_ref_id = meta_hash["other_ref_id"]
            dest_obj.payment_method = meta_hash["payment_method"]
            dest_obj.payment_payer_id = meta_hash["payment_payer_id"]
            dest_obj.payment_beneficiary_id = meta_hash["payment_beneficiary_id"]
            dest_obj.payment_currency = meta_hash["payment_currency"]
            dest_obj.payment_value = meta_hash["payment_value"]
            dest_obj.payment_at = meta_hash["payment_at"]
            dest_obj.payment_message = meta_hash["payment_message"]
            dest_obj.payment_screenshot = meta_hash["payment_screenshot"]
            dest_obj.payment_review_by = meta_hash["payment_review_by"]
            dest_obj.payment_review_status = meta_hash["payment_review_status"]
            dest_obj.payment_operator = meta_hash["payment_operator"]
            dest_obj.payment_status = meta_hash["payment_status"]
            dest_obj.other = meta_hash["other"]

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