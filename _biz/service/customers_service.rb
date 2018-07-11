module YDAPI
  module BizService
    class CustomersService < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@customers_model = YDAPI::BizModel::CustomersModel

      # add one customer
      # body
      # {
      #             "id": 1,
      #             "customer_id": "201",
      #             "added_by_user_name": "testname104",
      #             "company_name": "测试公司名称001",
      #             "company_location": "china",
      #             "company_tax_number": null,
      #             "company_legal_person": null,
      #             "company_main_business": null,
      #             "company_tel_number": null,
      #             "company_email": null,
      #             "company_description": null,
      #             "comment": null,
      #             "status": 1
      #         }
      post '/customer' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            customer=customer_hash_to_customer(body_hash)
            customer.added_by_user_name=username
            if customer
              new_customer=@@customers_model.add_new_customer(customer)
              if new_customer
                status 201
                content_type :json
                {customer:new_customer.values}.to_json
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

      # delete by customer_id
      delete '/customer/:customer_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            customer=@@customers_model.delete_customer_by_customer_id(params[:customer_id])
            if customer
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

      # update one customer
      # {
      #             "id": 1,
      #             "customer_id": "201",
      #             "added_by_user_name": "testname104",
      #             "company_name": "测试公司名称001",
      #             "company_location": "china",
      #             "company_tax_number": null,
      #             "company_legal_person": null,
      #             "company_main_business": null,
      #             "company_tel_number": null,
      #             "company_email": null,
      #             "company_description": null,
      #             "comment": null,
      #             "status": 1
      #         }
      put '/customer' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            customer=customer_hash_to_customer(body_hash)
            customer.added_by_user_name=username
            if customer
              new_customer=@@customers_model.update_customer(customer)
              if new_customer
                status 201
                content_type :json
                {customer:new_customer.values}.to_json
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

      # get one customer and its all contacts
      get '/customer/:customer_id' do
        process_request(request, 'users_get') do |req, username|
          begin
            p params[:customer_id]
            @@customers_model
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get all customers added by the user_name
      get '/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            # here use the authed username not the path param
            customers = @@customers_model.get_customers_by_user_name(username)
            if customers
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              sleep(1)
              content_type :json
              customers.to_json
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

      # add one customer_contact
      post '/customer_contact' do
        process_request(request, 'users_get') do |req, username|
          begin
            p req.body
            'ok'
            content_type :json
            {money: @accounts[username]}.to_json
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # delete one customer_contact by id
      delete '/customer_contact/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            p req.body
            'ok'
            content_type :json
            {money: @accounts[username]}.to_json
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # update one customer_contact
      put '/customer_contact' do
        process_request(request, 'users_get') do |req, username|
          begin
            p req.body
            'ok'
            content_type :json
            {money: @accounts[username]}.to_json
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # get one customer_contact by id
      get '/customer_contact/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            p req.body
            'ok'
            content_type :json
            {money: @accounts[username]}.to_json
          rescue Exception => e
            @@logger.error("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 500 Internal Server Error, token user=#{username}, Exception:#{e}")
            halt 500
          end
        end
      end

      # {
      #             "id": 1,
      #             "customer_id": "201",
      #             "added_by_user_name": "testname104",
      #             "company_name": "测试公司名称001",
      #             "company_location": "china",
      #             "company_tax_number": null,
      #             "company_legal_person": null,
      #             "company_main_business": null,
      #             "company_tel_number": null,
      #             "company_email": null,
      #             "company_description": null,
      #             "comment": null,
      #             "status": 1
      #         }
      def customer_hash_to_customer(customer_hash)
        begin
          if customer_hash && customer_hash.class == Hash && customer_hash.keys.size > 0
            customer=YDAPI::BizEntity::Customer.new
            customer.id=customer_hash["id"]
            customer.customer_id=customer_hash["customer_id"]
            customer.added_by_user_name=customer_hash["added_by_user_name"]
            customer.company_name=customer_hash["company_name"]
            customer.company_location=customer_hash["company_location"]
            customer.company_tax_number=customer_hash["company_tax_number"]
            customer.company_legal_person=customer_hash["company_legal_person"]
            customer.company_main_business=customer_hash["company_main_business"]
            customer.company_tel_number=customer_hash["company_tel_number"]
            customer.company_email=customer_hash["company_email"]
            customer.company_description=customer_hash["company_description"]
            customer.comment=customer_hash["comment"]
            customer.status=customer_hash["status"]
            customer
          else
            nil
          end
        rescue Exception => e
          nil
        end
      end

      def customer_contact_hash_to_customer_contact(customer_contact_hash)
        begin
          if customer_contact_hash && customer_contact_hash.class == Hash && customer_contact_hash.keys.size > 0
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