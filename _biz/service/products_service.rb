module YDAPI
  module BizService
    class ProductsService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@products_model = YDAPI::BizModel::ProductsModel

      # {
      #     "id": 2,
      #     "product_id": "20002",
      #     "added_by_user_name": "testname05",
      #     "name": "暖通T型(YD-T-S1)",
      #     "product_type_id": "7002",
      #     "measurement_unit": "米",
      #     "specification": "YD-T-S1",
      #     "raw_material_ids": "3,4",
      #     "features": null,
      #     "use_for": "用于普通舒适空调的送风",
      #     "description": null,
      #     "comment": null,
      #     "created_at": "2018-07-15 17:38:27 +0800",
      #     "last_update_at": "2018-07-15 17:38:27 +0800",
      #     "status": 1
      # }
      post '/product' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            product = product_hash_to_product(body_hash)
            product.added_by_user_name = username
            if product
              new_product = @@products_model.add_new_product(product)
              if new_product
                status 201
                content_type :json
                {product: new_product.values}.to_json
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

      delete '/product/:product_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            product=@@products_model.delete_product_by_product_id(params[:product_id])
            if product
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

      put '/product' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            product = product_hash_to_product(body_hash)
            product.added_by_user_name = username
            if product
              new_product = @@products_model.update_product(product)
              if new_product
                status 201
                content_type :json
                {product: new_product.values}.to_json
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

      get '/product/:product_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            product=@@products_model.get_product_by_product_id(params[:product_id])
            if product
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              product.to_json
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

      get '/:product_type_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            products=@@products_model.get_products_by_product_type_id(params[:product_type_id])
            if products
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              products.to_json
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
            products=@@products_model.get_all_products
            if products
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              products.to_json
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

      get '/product_types/' do
        process_request(request, 'users_get') do |req, username|
          begin
            product_types=@@products_model.get_all_product_types
            if product_types
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              product_types.to_json
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

      # ======
      # test upload file
      post '/product/upload_img/:product_id'do
        to_dest_folder="#{CONFIG['img_dir_product_detail']}/#{params[:product_id]}"
        tempfile = params['file'][:tempfile]
        filename = params['file'][:filename]

        begin
          type=filename.split('.')[-1]

          unless File.directory?(to_dest_folder)
            FileUtils.mkdir_p(to_dest_folder)
          end
          
          File.open("#{to_dest_folder}/#{params[:product_id]}.#{type}", 'wb') do |f|
            f.write(tempfile.read)
          end
          status 201
        rescue Exception => e
          @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
          halt 500
        end 
        
      end

      # {
      #     "id": 2,
      #     "product_id": "20002",
      #     "added_by_user_name": "testname05",
      #     "name": "暖通T型(YD-T-S1)",
      #     "product_type_id": "7002",
      #     "measurement_unit": "米",
      #     "specification": "YD-T-S1",
      #     "raw_material_ids": "3,4",
      #     "features": null,
      #     "use_for": "用于普通舒适空调的送风",
      #     "description": null,
      #     "comment": null,
      #     "created_at": "2018-07-15 17:38:27 +0800",
      #     "last_update_at": "2018-07-15 17:38:27 +0800",
      #     "status": 1
      # }
      def product_hash_to_product(product_hash)
        begin
          if product_hash && product_hash.class == Hash && product_hash.keys.size > 0
            product = YDAPI::BizEntity::Product.new
            product.id = product_hash["id"]
            product.product_id = product_hash["product_id"]
            product.added_by_user_name = product_hash["added_by_user_name"]
            product.name = product_hash["name"]
            product.product_type_id = product_hash["product_type_id"]
            product.measurement_unit = product_hash["measurement_unit"]
            product.specification = product_hash["specification"]
            product.raw_material_ids = product_hash["raw_material_ids"]
            product.features = product_hash["features"]
            product.use_for = product_hash["use_for"]
            product.description = product_hash["description"]
            product.comment = product_hash["comment"]
            product.status = product_hash["status"]
            product
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