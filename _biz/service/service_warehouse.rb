module YDAPI
  module BizService
    class Service_Warehouse < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@helper = YDAPI::Helpers::Helper
      @@model_warehouse = YDAPI::BizModel::Model_Warehouse

      #===== /order_contract/*
      get '/wh_raw_material/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.get_wh_raw_material_by_id(params[:id])
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

      get '/wh_raw_material/list/by_wh_id/:wh_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_raw_material_by_wh_id(params[:wh_id])
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

      get '/wh_raw_material/list/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_materials
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

      post '/wh_raw_material' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_wh_raw_material(body_hash)
            obj.created_by = username
            obj.last_update_by = username
            obj.wh_id = @@helper.generate_wh_raw_material_wh_id(obj.name, obj.specification)
            obj.wh_id_sub = @@helper.generate_wh_raw_material_wh_sub_id(obj.wh_id, obj.unit_price)

            if obj
              if @@model_warehouse.is_wh_raw_materials_wh_id_sub_exist(obj.wh_id_sub)
                halt 409
              else
                new_obj = @@model_warehouse.add_wh_raw_material(obj)
                if new_obj
                  status 201
                  content_type :json
                  {wh_raw_material: new_obj.values}.to_json
                else
                  halt 409
                end
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

      put '/wh_raw_material' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_wh_raw_material(body_hash)
            obj.last_update_by = username

            exist_record=@@model_warehouse.get_wh_raw_material_by_wh_id_sub(obj.wh_id_sub)

            if obj&&exist_record
              new_obj = @@model_warehouse.update_wh_raw_material(obj)
              if new_obj
                update_count="count:#{exist_record[:count].to_f} to #{new_obj[:count].to_f}"
                wh_raw_material_history=YDAPI::BizEntity::WHRawMaterialHistory.new
                wh_raw_material_history.created_by = username
                wh_raw_material_history.last_update_by = username
                wh_raw_material_history.wh_id=obj.wh_id
                wh_raw_material_history.wh_id_sub=obj.wh_id_sub
                wh_raw_material_history.record_type="update"
                wh_raw_material_history.update_what=update_count
                if @@model_warehouse.add_wh_raw_material_history(wh_raw_material_history)
                  status 201
                  content_type :json
                  {wh_raw_material: new_obj.values}.to_json
                else
                  halt 409
                end
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

      def meta_hash_to_wh_raw_material(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::WHRawMaterial.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.wh_id = meta_hash["wh_id"]
            dest_obj.wh_id_sub = meta_hash["wh_id_sub"]
            dest_obj.wh_location = meta_hash["wh_location"]
            dest_obj.wh_inner_location = meta_hash["wh_inner_location"]
            dest_obj.principal = meta_hash["principal"]
            dest_obj.name = meta_hash["name"]
            dest_obj.specification = meta_hash["specification"]
            dest_obj.description = meta_hash["description"]
            dest_obj.count = meta_hash["count"]
            dest_obj.count_unit = meta_hash["count_unit"]
            dest_obj.unit_price = meta_hash["unit_price"]
            dest_obj.weight = meta_hash["weight"]
            dest_obj.weight_unit = meta_hash["weight_unit"]
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

      def meta_hash_to_wh_raw_material_history(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::WHRawMaterialHistory.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.wh_id = meta_hash["wh_id"]
            dest_obj.wh_id_sub = meta_hash["wh_id_sub"]
            dest_obj.record_type = meta_hash["record_type"]
            dest_obj.update_what = meta_hash["update_what"]
            dest_obj.order_contract_id = meta_hash["order_contract_id"]
            dest_obj.inbound_count = meta_hash["inbound_count"]
            dest_obj.inbound_weight = meta_hash["inbound_weight"]
            dest_obj.inbound_unit_price = meta_hash["inbound_unit_price"]
            dest_obj.inbound_total_price = meta_hash["inbound_total_price"]
            dest_obj.inbound_from = meta_hash["inbound_from"]
            dest_obj.inbound_principal = meta_hash["inbound_principal"]
            dest_obj.inbound_at = meta_hash["inbound_at"]
            dest_obj.outbound_count = meta_hash["outbound_count"]
            dest_obj.outbound_weight = meta_hash["outbound_weight"]
            dest_obj.outbound_unit_price = meta_hash["outbound_unit_price"]
            dest_obj.outbound_total_price = meta_hash["outbound_total_price"]
            dest_obj.outbound_to = meta_hash["outbound_to"]
            dest_obj.outbound_principal = meta_hash["outbound_principal"]
            dest_obj.outbound_at = meta_hash["outbound_at"]
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