module YDAPI
  module BizService
    class InventoriesService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@inventories_model = YDAPI::BizModel::InventoriesModel

# {
#     "updated_by_user_name": "admin",
#     "inventory_unit": "ç±³",
#     "added_by_user_name": "admin",
#     "inventory_id": "177001",
#     "inventory_count": 10,
#     "last_update_at": "2018-11-12 22:01:04 +0800",
#     "inventory_type_id": "rm_001",
#     "description": null,
#     "created_at": "2018-11-12 22:01:04 +0800",
#     "id": 1,
#     "inventory_name": "å\u008E\u009Fæ\u0096\u0099æ\u009D¡ç\u009B®001",
#     "status": 1
# }
      post '/inventory' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            inventory = inventory_hash_to_inventory(body_hash)
            inventory.added_by_user_name = username
            inventory.updated_by_user_name = username
            if inventory
              new_inventory = @@inventories_model.add_new_inventory(inventory)
              if new_inventory
                status 201
                content_type :json
                {inventory: new_inventory.values}.to_json
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

      delete '/inventory/:inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
          	@@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} user=#{username}")
            inventory=@@inventories_model.delete_inventory_by_inventory_id(params[:inventory_id])
            if inventory
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

      put '/inventory' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            inventory = inventory_hash_to_inventory(body_hash)
            inventory.added_by_user_name = username
            inventory.updated_by_user_name = username
            if inventory
              new_inventory = @@inventories_model.update_inventory(inventory)
              if new_inventory
                status 201
                content_type :json
                {inventory: new_inventory.values}.to_json
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

      get '/inventory/:inventory_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            inventory=@@inventories_model.get_inventory_by_inventory_id(params[:inventory_id])
            if inventory
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              inventory.to_json
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

      get '/' do
        process_request(request, 'users_get') do |req, username|
          begin
            inventories=@@inventories_model.get_inventories_by_user_name('admin')
            if inventories
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              inventories.to_json
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

      get '/inventory_type_id/:inventory_type_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            inventories=@@inventories_model.get_inventories_by_type_id(params[:inventory_type_id])
            if inventories
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              inventories.to_json
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

      get '/type_parent/:type_parent' do
        process_request(request, 'users_get') do |req, username|
          begin
            inventories=@@inventories_model.get_inventories_by_type_parent(params[:type_parent])
            if inventories
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              inventories.to_json
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

      # all sub types of a type_parent --原料raw_material、半成品semifinished_product、成品product
      get '/inventory_types/type_parent/:type_parent' do
        process_request(request, 'users_get') do |req, username|
          begin
            inventory_types=@@inventories_model.get_inventory_types_by_type_parent(params[:type_parent])
            if inventory_types
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              inventory_types.to_json
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

      post '/inventory/upload_img/:inventory_id'do
        
        process_request(request, 'users_get') do |req, username|
          begin
            to_dest_folder="#{CONF['img_dir_inventory_detail']}/inventories_img/#{params[:inventory_id]}"
            tempfile = params['file'][:tempfile]
            filename = params['file'][:filename]
            type=filename.split('.')[-1]

            unless File.directory?(to_dest_folder)
              FileUtils.mkdir_p(to_dest_folder)
            end

            File.open("#{to_dest_folder}/#{params[:inventory_id]}.#{type}", 'wb') do |f|
              f.write(tempfile.read)
            end
            status 201
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end 
        end
      end

# {
#     "updated_by_user_name": "admin",
#     "inventory_unit": "ç±³",
#     "added_by_user_name": "admin",
#     "inventory_id": "177001",
#     "inventory_count": 10,
#     "last_update_at": "2018-11-12 22:01:04 +0800",
#     "inventory_type_id": "rm_001",
#     "description": null,
#     "created_at": "2018-11-12 22:01:04 +0800",
#     "id": 1,
#     "inventory_name": "å\u008E\u009Fæ\u0096\u0099æ\u009D¡ç\u009B®001",
#     "status": 1
# }
      def inventory_hash_to_inventory(inventory_hash)
        begin
          if inventory_hash && inventory_hash.class == Hash && inventory_hash.keys.size > 0
            inventory = YDAPI::BizEntity::Inventory.new
            inventory.id = inventory_hash["id"]
            inventory.inventory_id = inventory_hash["inventory_id"]
            inventory.added_by_user_name = inventory_hash["added_by_user_name"]
            inventory.inventory_type_id = inventory_hash["inventory_type_id"]
            inventory.inventory_name = inventory_hash["inventory_name"]
            inventory.inventory_count = inventory_hash["inventory_count"]
            inventory.inventory_unit = inventory_hash["inventory_unit"]
            inventory.description = inventory_hash["description"]
            inventory.updated_by_user_name = inventory_hash["updated_by_user_name"]
            inventory.status = inventory_hash["status"]
            inventory
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