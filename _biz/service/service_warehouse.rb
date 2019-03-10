module YDAPI
  module BizService
    class Service_Warehouse < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@helper = YDAPI::Helpers::Helper
      @@model_warehouse = YDAPI::BizModel::Model_Warehouse

      #===== /wh_raw_material/*
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

      get '/wh_raw_material/by_wh_id_sub/:wh_id_sub' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.get_wh_raw_material_by_wh_id_sub(params[:wh_id_sub])
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

      get '/wh_raw_material/list/by_wh_id_sub/:wh_id_sub' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_raw_material_by_wh_id_sub(params[:wh_id_sub])
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

            exist_record = @@model_warehouse.get_wh_raw_material_by_wh_id_sub(obj.wh_id_sub)

            if obj && exist_record
              new_obj = @@model_warehouse.update_wh_raw_material(obj)
              if new_obj
                update_count = "count:#{exist_record[:count].to_f} to #{new_obj[:count].to_f}"
                wh_raw_material_history = YDAPI::BizEntity::WHRawMaterialHistory.new
                wh_raw_material_history.created_by = username
                wh_raw_material_history.last_update_by = username
                wh_raw_material_history.wh_id = obj.wh_id
                wh_raw_material_history.wh_id_sub = obj.wh_id_sub
                wh_raw_material_history.record_type = "update"
                wh_raw_material_history.update_what = update_count
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

      #===== /wh_raw_material_history/*
      get '/wh_raw_material_history/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            # item = @@model_warehouse.get_wh_raw_material_history_by_id(params[:id])
            item = @@model_warehouse.select_wh_raw_material_history_by_id(params[:id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              item.to_json
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

      get '/wh_raw_material_history/list/by_wh_id/:wh_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_material_history_by_wh_id(params[:wh_id])
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

      get '/wh_raw_material_history/list/by_wh_id_sub/:wh_id_sub' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_material_history_by_wh_id_sub(params[:wh_id_sub])
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

      get '/wh_raw_material_history/list/by_wh_id_and_type/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_material_history_by_wh_id_type(params[:wh_id], params[:type])
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

      get '/wh_raw_material_history/list/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_material_history()
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

      get '/wh_raw_material_history/list/by_record_type/:record_type' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_raw_material_history_by_record_type(params[:record_type])
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

      post '/wh_raw_material_history' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_wh_raw_material_history(body_hash)
            obj.created_by = username
            obj.last_update_by = username

            if obj
              wh_raw_material = @@model_warehouse.get_wh_raw_material_by_wh_id_sub(obj.wh_id_sub)
              if wh_raw_material
                old_count = wh_raw_material[:count].to_f
                new_count = old_count
                if obj.record_type == "inbound"
                  new_count = old_count + obj.inbound_count.to_f
                elsif obj.record_type == "outbound"
                  new_count = old_count - obj.inbound_count.to_f
                end
                new_count = new_count < 0 ? 0 : new_count
                if @@model_warehouse.update_wh_raw_material_count(obj.wh_id_sub, new_count)
                  new_obj = @@model_warehouse.add_wh_raw_material_history(obj)
                  if new_obj
                    status 201
                    content_type :json
                    {wh_raw_material_history: new_obj.values}.to_json
                  else
                    halt 409
                  end
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

      put '/wh_raw_material_history' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["b_customer_id"]}")
            obj = meta_hash_to_wh_raw_material_history(body_hash)
            obj.last_update_by = username

            if obj
              wh_raw_material = @@model_warehouse.get_wh_raw_material_by_wh_id_sub(obj.wh_id_sub)
              if wh_raw_material
                old_count = wh_raw_material[:count].to_f
                new_count = old_count
                old_obj = @@model_warehouse.get_wh_raw_material_history_by_id(obj.id)
                if obj.record_type == old_obj.record_type
                  if obj.record_type == "inbound"
                    old_obj_count = old_obj.inbound_count.to_f
                    obj_count = obj.inbound_count.to_f
                    new_count = old_count + obj_count - old_obj_count
                  elsif obj.record_type == "outbound"
                    old_obj_count = old_obj.outbound_count.to_f
                    obj_count = obj.outbound_count.to_f
                    new_count = old_count - obj_count + old_obj_count
                  end
                  new_count = new_count < 0 ? 0 : new_count
                  if @@model_warehouse.update_wh_raw_material_count(obj.wh_id_sub, new_count)
                    new_obj = @@model_warehouse.update_wh_raw_material_history(obj)
                    if new_obj
                      status 201
                      content_type :json
                      {wh_raw_material_history: new_obj.values}.to_json
                    else
                      halt 409
                    end
                  else
                    halt 409
                  end
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

      #===== /wh_inventory/*
      get '/wh_inventory/:wh_inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.get_wh_inventory_by_inventory_id(params[:wh_inventory_id])
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

      get '/wh_inventory/list/by_wh_inventory_type/:wh_inventory_type' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventories_by_inventory_type(params[:wh_inventory_type])
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

      get '/wh_inventory/list/by_wh_inventory_type_ids/:wh_inventory_type' do
        process_request(request, 'users_get') do |req, username|
          begin
            id_arr=params[:ids].split(',')
            items = @@model_warehouse.get_all_wh_inventories_by_type_ids(params[:wh_inventory_type],id_arr)
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

      post '/wh_inventory' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["name"]}")
            obj = meta_hash_to_wh_inventory(body_hash)
            obj.created_by = username
            obj.last_update_by = username
            if obj.specification
              tmp_spec=obj.specification
            else
              tmp_spec=""
            end
            # obj.wh_inventory_id = @@helper.generate_wh_inventory_id(obj.wh_inventory_type, obj.name, tmp_spec)
            if obj.wh_inventory_id==""||obj.wh_inventory_id==" "
              halt 400
            else
              if obj
                new_obj = @@model_warehouse.add_wh_inventory(obj)
                if new_obj
                  hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                  hist_obj.created_by = username
                  hist_obj.last_update_by = username
                  hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                  hist_obj.wh_inventory_id = obj.wh_inventory_id
                  hist_obj.history_type = "add"
                  if @@model_warehouse.add_wh_inventory_history(hist_obj)
                    status 201
                    content_type :json
                    {wh_inventory: new_obj.values}.to_json
                  else
                    halt 409
                  end
                else
                  halt 409
                end
              else
                halt 400
              end
            end
          rescue Exception => e
            @@logger.error("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      put '/wh_inventory' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["name"]}")
            obj = meta_hash_to_wh_inventory(body_hash)
            obj.last_update_by = username
            old_obj = @@model_warehouse.get_wh_inventory_by_inventory_id(obj.wh_inventory_id)
            if obj && old_obj
              new_obj = @@model_warehouse.update_wh_inventory(obj)
              if new_obj
                hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                hist_obj.created_by = username
                hist_obj.last_update_by = username
                hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                hist_obj.wh_inventory_id = obj.wh_inventory_id
                hist_obj.history_type = "update"
                hist_obj.count_diff = new_obj[:count].to_f - old_obj[:count].to_f
                hist_obj.unit_price_diff = new_obj[:unit_price].to_f - old_obj[:unit_price].to_f

                if @@model_warehouse.add_wh_inventory_history(hist_obj)
                  status 201
                  content_type :json
                  {wh_inventory: new_obj.values}.to_json
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

      delete '/wh_inventory/:wh_inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.delete_wh_inventory_by_inventory_id(params[:wh_inventory_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              halt 201
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

      #===== /wh_inventory_batch/*
      get '/wh_inventory_batch/:wh_inventory_batch_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.get_wh_inventory_batch_by_inventory_batch_id(params[:wh_inventory_batch_id])
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

      get '/wh_inventory_batch/list/by_wh_inventory_type/:wh_inventory_type' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventory_batches_by_inventory_type(params[:wh_inventory_type])
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

      get '/wh_inventory_batch/list/by_wh_inventory_type_batch_type/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventory_batches_by_inventory_type_batch_type(params[:wh_inventory_type],params[:batch_type])
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

      get '/wh_inventory_batch/list/by_batch_type/:batch_type' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventory_batches_by_batch_type(params[:batch_type])
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

      get '/wh_inventory_batch/list/by_wh_inventory_id/:wh_inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventory_batches_by_inventory_id(params[:wh_inventory_id])
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

      get '/wh_inventory_batch/list/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_all_wh_inventory_batches
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

      post '/wh_inventory_batch' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath}")
            obj = meta_hash_to_wh_inventory_batch(body_hash)
            obj.created_by = username
            obj.last_update_by = username
            obj.wh_inventory_batch_id = @@helper.generate_wh_inventory_batch_id

            if obj
              wh_inventory = @@model_warehouse.get_wh_inventory_by_inventory_id(obj.wh_inventory_id)
              if wh_inventory
                plus_or_minus = 1
                if obj.batch_type == 'outbound'
                  plus_or_minus = -1
                end
                new_count = wh_inventory[:count].to_f + plus_or_minus * obj.count.to_f
                new_auxiliary_count = wh_inventory[:auxiliary_count].to_f + plus_or_minus * obj.auxiliary_count.to_f
                if @@model_warehouse.update_wh_inventory_count(obj.wh_inventory_id, new_count, new_auxiliary_count)
                  new_obj = @@model_warehouse.add_wh_inventory_batch(obj)
                  if new_obj
                    hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                    hist_obj.created_by = username
                    hist_obj.last_update_by = username
                    hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                    hist_obj.wh_inventory_id = obj.wh_inventory_id
                    hist_obj.history_type = obj.batch_type
                    hist_obj.count_diff = obj.count
                    hist_obj.unit_price_diff = obj.unit_price
                    hist_obj.wh_inventory_batch_id = obj.wh_inventory_batch_id

                    if @@model_warehouse.add_wh_inventory_history(hist_obj)
                      status 201
                      content_type :json
                      {wh_inventory_batch: new_obj.values}.to_json
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

      put '/wh_inventory_batch' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath}")
            obj = meta_hash_to_wh_inventory_batch(body_hash)
            obj.last_update_by = username

            if obj
              wh_inventory = @@model_warehouse.get_wh_inventory_by_inventory_id(obj.wh_inventory_id)
              if wh_inventory
                old_batch_obj=@@model_warehouse.get_wh_inventory_batch_by_inventory_batch_id(obj.wh_inventory_batch_id)
                if old_batch_obj
                  plus_or_minus = 1
                  if obj.batch_type == 'outbound'
                    plus_or_minus = -1
                  end
                  new_count = wh_inventory[:count].to_f + plus_or_minus * (obj.count.to_f-old_batch_obj.count.to_f)
                  new_auxiliary_count = wh_inventory[:auxiliary_count].to_f +
                      plus_or_minus * (obj.auxiliary_count.to_f-old_batch_obj.auxiliary_count.to_f)
                  if @@model_warehouse.update_wh_inventory_count(obj.wh_inventory_id, new_count, new_auxiliary_count)
                    new_obj = @@model_warehouse.add_wh_inventory_batch(obj)
                    if new_obj
                      hist_obj = YDAPI::BizEntity::WHInventoryHistory.new
                      hist_obj.created_by = username
                      hist_obj.last_update_by = username
                      hist_obj.history_id = @@helper.generate_wh_inventory_history_id
                      hist_obj.wh_inventory_id = obj.wh_inventory_id
                      hist_obj.history_type = obj.batch_type
                      hist_obj.count_diff = obj.count
                      hist_obj.unit_price_diff = obj.unit_price
                      hist_obj.wh_inventory_batch_id = obj.wh_inventory_batch_id

                      if @@model_warehouse.add_wh_inventory_history(hist_obj)
                        status 201
                        content_type :json
                        {wh_inventory_batch: new_obj.values}.to_json
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

      delete '/wh_inventory_batch/:wh_inventory_batch_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.delete_wh_inventory_batch_by_inventory_batch_id(params[:wh_inventory_batch_id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              halt 201
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

      # ====history
      get '/wh_inventory_his/:history_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@model_warehouse.get_wh_inventory_history_by_history_id(params[:history_id])
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
      get '/wh_inventory_history/list/by_wh_inventory_id/:wh_inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@model_warehouse.get_wh_inventory_histories_by_inventory_id(params[:wh_inventory_id])
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

      # ==== wh_out_record
      post '/wh_out_record' do
        process_request(request, 'users_get') do |req, username|
          begin
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath}")
            body_hash = JSON.parse(req.body.read)
            wh_out_record_id=@@helper.generate_wh_out_record_id(@@model_warehouse.get_max_wh_out_record_id)
            objs=meta_hash_to_wh_out_record_and_items_for_post(body_hash,username,wh_out_record_id)
            if objs
              wh_out_record=objs[:wh_out_record]
              wh_out_record.wh_out_record_id=wh_out_record_id
              wh_out_record.last_update_by=username
              items=objs[:items]
              if @@model_warehouse.add_wh_out_record(wh_out_record,items)
                status 201
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

      put '/wh_out_record' do
        process_request(request, 'users_get') do |req, username|
          begin
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath}")
            body_hash = JSON.parse(req.body.read)
            objs=meta_hash_to_wh_out_record_and_items_for_put(body_hash,username)
            if objs
              wh_out_record=objs[:wh_out_record]
              wh_out_record.last_update_by=username
              items=objs[:items]
              if @@model_warehouse.update_wh_out_record(wh_out_record,items)
                status 201
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

      put '/wh_out_record/update_status/:wh_out_record_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath}")

            wh_out_record_id=params[:wh_out_record_id]
            new_status=params[:new_status]
            if wh_out_record_id!=nil&&new_status!=nil
              if @@model_warehouse.update_wh_out_record_status(wh_out_record_id,new_status)
                status 201
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

      get '/wh_out_record/:wh_out_record_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            result = @@model_warehouse.get_wh_out_record_by_id(params[:wh_out_record_id])
            if result
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      get '/wh_out_record/list/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            result = @@model_warehouse.get_wh_out_records_all
            if result
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              result.to_json
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

      # ====
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

      def meta_hash_to_wh_inventory(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::WHInventory.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.wh_inventory_id = meta_hash["wh_inventory_id"]
            dest_obj.wh_inventory_type = meta_hash["wh_inventory_type"]
            dest_obj.wh_location = meta_hash["wh_location"]
            dest_obj.wh_inner_location = meta_hash["wh_inner_location"]
            dest_obj.principal = meta_hash["principal"]
            dest_obj.name = meta_hash["name"]
            dest_obj.specification = meta_hash["specification"]
            dest_obj.description = meta_hash["description"]
            dest_obj.count = meta_hash["count"]
            dest_obj.count_unit = meta_hash["count_unit"]
            dest_obj.unit_price = meta_hash["unit_price"]==""?0:meta_hash["unit_price"]
            dest_obj.auxiliary_count = meta_hash["auxiliary_count"]
            dest_obj.auxiliary_count_unit = meta_hash["auxiliary_count_unit"]
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

      def meta_hash_to_wh_inventory_batch(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::WHInventoryBatch.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.wh_inventory_batch_id = meta_hash["wh_inventory_batch_id"]
            dest_obj.wh_inventory_id = meta_hash["wh_inventory_id"]
            dest_obj.wh_inventory_type = meta_hash["wh_inventory_type"]
            dest_obj.wh_location = meta_hash["wh_location"]
            dest_obj.wh_inner_location = meta_hash["wh_inner_location"]
            dest_obj.production_order_id = meta_hash["production_order_id"]
            dest_obj.principal = meta_hash["principal"]
            dest_obj.batch_number = meta_hash["batch_number"]
            dest_obj.batch_at = meta_hash["batch_at"]
            dest_obj.batch_type = meta_hash["batch_type"]
            dest_obj.batch_from = meta_hash["batch_from"]
            dest_obj.batch_to = meta_hash["batch_to"]
            dest_obj.batch_status = meta_hash["batch_status"]
            dest_obj.count = meta_hash["count"]
            dest_obj.count_unit = meta_hash["count_unit"]
            dest_obj.unit_price = meta_hash["unit_price"]
            dest_obj.auxiliary_count = meta_hash["auxiliary_count"]
            dest_obj.auxiliary_count_unit = meta_hash["auxiliary_count_unit"]
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

      def meta_hash_to_wh_inventory_history(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj = YDAPI::BizEntity::WHInventoryHistory.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.history_id = meta_hash["history_id"]
            dest_obj.wh_inventory_id = meta_hash["wh_inventory_id"]
            dest_obj.history_type = meta_hash["history_type"]
            dest_obj.count_diff = meta_hash["count_diff"]
            dest_obj.unit_price_diff = meta_hash["unit_price_diff"]
            dest_obj.wh_inventory_batch_id = meta_hash["wh_inventory_batch_id"]
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

      def meta_hash_to_wh_out_record_and_items_for_post(meta_hash,by_username,wh_out_record_id)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            wh_out_record_hash=meta_hash["wh_out_record"]
            wh_out_record_obj=YDAPI::BizEntity::WHOutRecord.new
            #--- common property
            wh_out_record_obj.id = wh_out_record_hash["id"]
            wh_out_record_obj.created_by = by_username
            wh_out_record_obj.last_update_by = by_username
            wh_out_record_obj.status = wh_out_record_hash["status"]
            wh_out_record_obj.comment = wh_out_record_hash["comment"]
            #--- customized property
            wh_out_record_obj.wh_out_record_id = wh_out_record_hash["wh_out_record_id"]
            wh_out_record_obj.wh_out_record_status = wh_out_record_hash["wh_out_record_status"]
            wh_out_record_obj.ship_to_name = wh_out_record_hash["ship_to_name"]
            wh_out_record_obj.ship_date = wh_out_record_hash["ship_date"]
            wh_out_record_obj.ship_to_address = wh_out_record_hash["ship_to_address"]
            wh_out_record_obj.ship_to_phone_number = wh_out_record_hash["ship_to_phone_number"]
            wh_out_record_obj.ship_to_user = wh_out_record_hash["ship_to_user"]
            wh_out_record_obj.order_id = wh_out_record_hash["order_id"]
            wh_out_record_obj.item_count = wh_out_record_hash["item_count"]
            wh_out_record_obj.item_total_price = wh_out_record_hash["item_total_price"]
            wh_out_record_obj.salesman = wh_out_record_hash["salesman"]
            wh_out_record_obj.delivery_by = wh_out_record_hash["delivery_by"]
            wh_out_record_obj.other = wh_out_record_hash["other"]

            items_arr=[]
            hash_items=meta_hash["items"]
            hash_items.each{|item|
              wh_out_record_item_obj=YDAPI::BizEntity::WHOutRecordItem.new
              #--- common property
              wh_out_record_item_obj.id = item["id"]
              wh_out_record_item_obj.created_by = by_username
              wh_out_record_item_obj.last_update_by = by_username
              wh_out_record_item_obj.status = item["status"]
              wh_out_record_item_obj.comment = item["comment"]
              #--- customized property
              wh_out_record_item_obj.wh_out_record_id = wh_out_record_id
              wh_out_record_item_obj.wh_inventory_id = item["wh_inventory_id"]
              wh_out_record_item_obj.name = item["name"]
              wh_out_record_item_obj.specific = item["specific"]
              wh_out_record_item_obj.packing_count = item["packing_count"]
              wh_out_record_item_obj.packing_count_unit = item["packing_count_unit"]
              wh_out_record_item_obj.auxiliary_count = item["auxiliary_count"]
              wh_out_record_item_obj.auxiliary_count_unit = item["auxiliary_count_unit"]
              wh_out_record_item_obj.unit_price = item["unit_price"]
              wh_out_record_item_obj.total_price = item["total_price"]
              wh_out_record_item_obj.other = item["other"]
              items_arr<<wh_out_record_item_obj
            }
            {:wh_out_record=>wh_out_record_obj,:items=>items_arr}
          else
            nil
          end
        rescue Exception => e
          p e
          nil
        end
      end

      def meta_hash_to_wh_out_record_and_items_for_put(meta_hash,by_username)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            wh_out_record_hash=meta_hash["wh_out_record"]
            wh_out_record_obj=YDAPI::BizEntity::WHOutRecord.new
            #--- common property
            wh_out_record_obj.id = wh_out_record_hash["id"]
            wh_out_record_obj.created_by = wh_out_record_hash["created_by"]
            wh_out_record_obj.last_update_by = by_username
            wh_out_record_obj.status = wh_out_record_hash["status"]
            wh_out_record_obj.comment = wh_out_record_hash["comment"]
            #--- customized property
            wh_out_record_obj.wh_out_record_id = wh_out_record_hash["wh_out_record_id"]
            wh_out_record_obj.wh_out_record_status = wh_out_record_hash["wh_out_record_status"]
            wh_out_record_obj.ship_to_name = wh_out_record_hash["ship_to_name"]
            wh_out_record_obj.ship_date = wh_out_record_hash["ship_date"]
            wh_out_record_obj.ship_to_address = wh_out_record_hash["ship_to_address"]
            wh_out_record_obj.ship_to_phone_number = wh_out_record_hash["ship_to_phone_number"]
            wh_out_record_obj.ship_to_user = wh_out_record_hash["ship_to_user"]
            wh_out_record_obj.order_id = wh_out_record_hash["order_id"]
            wh_out_record_obj.item_count = wh_out_record_hash["item_count"]
            wh_out_record_obj.item_total_price = wh_out_record_hash["item_total_price"]
            wh_out_record_obj.salesman = wh_out_record_hash["salesman"]
            wh_out_record_obj.delivery_by = wh_out_record_hash["delivery_by"]
            wh_out_record_obj.other = wh_out_record_hash["other"]

            items_arr=[]
            hash_items=meta_hash["items"]
            hash_items.each{|item|
              wh_out_record_item_obj=YDAPI::BizEntity::WHOutRecordItem.new
              #--- common property
              wh_out_record_item_obj.id = item["id"]
              wh_out_record_item_obj.created_by = item["created_by"]
              wh_out_record_item_obj.last_update_by = by_username
              wh_out_record_item_obj.status = item["status"]
              wh_out_record_item_obj.comment = item["comment"]
              #--- customized property
              wh_out_record_item_obj.wh_out_record_id = item["wh_out_record_id"]
              wh_out_record_item_obj.wh_inventory_id = item["wh_inventory_id"]
              wh_out_record_item_obj.name = item["name"]
              wh_out_record_item_obj.specific = item["specific"]
              wh_out_record_item_obj.packing_count = item["packing_count"]
              wh_out_record_item_obj.packing_count_unit = item["packing_count_unit"]
              wh_out_record_item_obj.auxiliary_count = item["auxiliary_count"]
              wh_out_record_item_obj.auxiliary_count_unit = item["auxiliary_count_unit"]
              wh_out_record_item_obj.unit_price = item["unit_price"]
              wh_out_record_item_obj.total_price = item["total_price"]
              wh_out_record_item_obj.other = item["other"]
              items_arr<<wh_out_record_item_obj
            }
            {:wh_out_record=>wh_out_record_obj,:items=>items_arr}
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