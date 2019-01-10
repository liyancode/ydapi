module YDAPI
  module BizService
    class Service_Customer < Sinatra::Base
      use YDAPI::Helpers::JwtAuth
      @@logger = BIZ_SERVICE_LOGGER

      @@unify_logger=YDAPI::Helpers::UnifyLogger.new(BIZ_SERVICE_LOGGER)

      @@customers_model = YDAPI::BizModel::Model_Customer



      # add one customer
      # body{"customer":
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
      #         },
      # "contact":{
      # }
      #
      # }
      post '/customer' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            customer=customer_hash_to_customer(body_hash["customer"])
            customer.added_by_user_name=username
            if customer
              new_customer=@@customers_model.add_new_customer(customer)
              if new_customer
                # add customer_followup
                customer_followup=YDAPI::BizEntity::CustomerFollowup.new
                #--- common property
                customer_followup.created_by =username
                customer_followup.last_update_by = username
                #--- customized property
                customer_followup.customer_id = new_customer[:customer_id]
                customer_followup.user_name = username
                customer_followup.followup_description = "创建客户记录"
                customer_followup.followup_status = "potential"
                customer_followup.followup_method = "other"
                customer_followup.followup_method_my_id = username
                customer_followup.followup_method_customer_id = new_customer[:customer_id]
                if @@customers_model.add_new_customer_followup(customer_followup)
                  contact=customer_contact_hash_to_customer_contact(body_hash["contact"])
                  if contact
                    contact.customer_id=new_customer.customer_id
                    contact.added_by_user_name=username
                    new_contact=@@customers_model.add_new_customer_contact(contact)
                    if new_contact
                      status 201
                      content_type :json
                      {customer:new_customer.values,contact:new_contact.values}.to_json
                    else
                      halt 409
                    end
                  else
                    halt 400
                  end
                else
                  halt 400
                end
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
                # add customer_followup
                customer_followup=YDAPI::BizEntity::CustomerFollowup.new
                #--- common property
                customer_followup.created_by =username
                customer_followup.last_update_by = username
                #--- customized property
                customer_followup.customer_id = new_customer[:customer_id]
                customer_followup.user_name = username
                customer_followup.followup_description = "更新客户信息"
                customer_followup.followup_status = @@customers_model.get_last_followup_status_by_cid_uname(new_customer[:customer_id],username)
                customer_followup.followup_method = "other"
                customer_followup.followup_method_my_id = username
                customer_followup.followup_method_customer_id = new_customer[:customer_id]
                if @@customers_model.add_new_customer_followup(customer_followup)
                  status 201
                  content_type :json
                  {customer:new_customer.values}.to_json
                else
                  halt 400
                end
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
            @@unify_logger._service_log('info','logid_01',self,req,username,200)
            customer_and_contacts=@@customers_model.get_customer_and_contacts_by_customer_id(params[:customer_id])
            if customer_and_contacts
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              content_type :json
              customer_and_contacts.to_json
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

      # get all customers added by the user_name
      get '/:user_name' do
        process_request(request, 'users_get') do |req, username|
          begin
            # here use the authed username not the path param
            customers = @@customers_model.get_customers_by_user_name(username)
            if customers
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              # sleep(1)
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

      # get all customers(admin)
      get '/all/' do
        process_request(request, 'users_get') do |req, username|
          begin
            # here use the authed username not the path param
            customers = @@customers_model.get_all_customers(username)
            if customers
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              # sleep(1)
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
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            customer_contact=customer_contact_hash_to_customer_contact(body_hash)
            customer_contact.added_by_user_name=username
            if customer_contact
              new_customer_contact=@@customers_model.add_new_customer_contact(customer_contact)
              if new_customer_contact
                # add customer_followup
                customer_followup=YDAPI::BizEntity::CustomerFollowup.new
                #--- common property
                customer_followup.created_by =username
                customer_followup.last_update_by = username
                #--- customized property
                customer_followup.customer_id = new_customer_contact[:customer_id]
                customer_followup.user_name = username
                customer_followup.followup_description = "添加联系人信息:"+new_customer_contact[:fullname]
                customer_followup.followup_status = @@customers_model.get_last_followup_status_by_cid_uname(new_customer_contact[:customer_id],username)
                customer_followup.followup_method = "other"
                customer_followup.followup_method_my_id = username
                customer_followup.followup_method_customer_id = new_customer_contact[:customer_id]
                if @@customers_model.add_new_customer_followup(customer_followup)
                  status 201
                  content_type :json
                  {customer_contact:new_customer_contact.values}.to_json
                else
                  halt 400
                end
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

      # delete one customer_contact by id
      delete '/customer_contact/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            customer_contact=@@customers_model.get_customer_contact_id(params[:id])
            if @@customers_model.delete_customer_contact_by_id(params[:id])
              # add customer_followup
              customer_followup=YDAPI::BizEntity::CustomerFollowup.new
              #--- common property
              customer_followup.created_by =username
              customer_followup.last_update_by = username
              #--- customized property
              customer_followup.customer_id = customer_contact[:customer_id]
              customer_followup.user_name = username
              customer_followup.followup_description = "删除联系人:"+customer_contact[:fullname]
              customer_followup.followup_status = @@customers_model.get_last_followup_status_by_cid_uname(customer_contact[:customer_id],username)
              customer_followup.followup_method = "other"
              customer_followup.followup_method_my_id = username
              customer_followup.followup_method_customer_id = customer_contact[:customer_id]
              if @@customers_model.add_new_customer_followup(customer_followup)
                @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
                status 200
              else
                halt 400
              end
            else
              @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} 404 Not Found. token user=#{username}")
              halt 400
            end
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
            body_hash=JSON.parse(req.body.read)
            @@logger.info("#{self} #{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash}")
            customer_contact=customer_contact_hash_to_customer_contact(body_hash)
            if customer_contact
              new_customer_contact=@@customers_model.update_customer_contact(customer_contact)
              if new_customer_contact
                # add customer_followup
                customer_followup=YDAPI::BizEntity::CustomerFollowup.new
                #--- common property
                customer_followup.created_by =username
                customer_followup.last_update_by = username
                #--- customized property
                customer_followup.customer_id = new_customer_contact[:customer_id]
                customer_followup.user_name = username
                customer_followup.followup_description = "更新联系人信息:"+new_customer_contact[:fullname]
                customer_followup.followup_status = @@customers_model.get_last_followup_status_by_cid_uname(new_customer_contact[:customer_id],username)
                customer_followup.followup_method = "other"
                customer_followup.followup_method_my_id = username
                customer_followup.followup_method_customer_id = new_customer_contact[:customer_id]
                if @@customers_model.add_new_customer_followup(customer_followup)
                  status 201
                  content_type :json
                  {customer_contact:new_customer_contact.values}.to_json
                else
                  halt 400
                end
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

      # customer followup
      # {
      #     "followup_status": "potential",
      #     "followup_method_my_id": "ad@yd.com",
      #     "user_name": "admin",
      #     "followup_method": "email",
      #     "created_at": "2018-12-30 13:47:43 +0800",
      #     "followup_description": "å®¢æ\u0088·æ\u009A\u0082æ\u0097¶æ²¡æ\u009C\u0089è®¢å\u008D\u0095æ\u0084\u008Få\u0090\u0091ï¼\u008Cä½\u0086æ\u0098¯æ½\u009Cå\u009C¨å®¢æ\u0088·",
      #     "created_by": "admin",
      #     "last_update_by": "admin",
      #     "last_update_at": "2018-12-30 13:47:43 +0800",
      #     "comment": null,
      #     "id": 1,
      #     "customer_id": "218",
      #     "followup_method_customer_id": "xm@test.com",
      #     "status": 1
      # }
      get '/customer_followup/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@customers_model.get_customer_followup_by_id(params[:id])
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

      get '/customer_followup/list/by_cid_uname/' do
        process_request(request, 'users_get') do |req, username|
          begin
            items = @@customers_model.get_customer_followups_by_customer_id_user_name(params[:customer_id],params[:user_name])
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

      post '/customer_followup' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["user_name"]}")
            customer_followup = customer_followup_hash_to_customer_followup(body_hash)
            if customer_followup
              customer_followup.created_by = username
              customer_followup.user_name = username
              customer_followup.last_update_by = username
              new_customer_followup = @@customers_model.add_new_customer_followup(customer_followup)
              if new_customer_followup
                status 201
                content_type :json
                {customer_followup: new_customer_followup.values}.to_json
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

      put '/customer_followup' do
        process_request(request, 'users_get') do |req, username|
          begin
            body_hash = JSON.parse(req.body.read)
            @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} body=#{body_hash["user_name"]}")
            customer_followup = customer_followup_hash_to_customer_followup(body_hash)
            if customer_followup
              customer_followup.last_update_by = username
              new_customer_followup = @@customers_model.update_customer_followup(customer_followup)
              if new_customer_followup
                status 201
                content_type :json
                {customer_followup: new_customer_followup.values}.to_json
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

      delete '/customer_followup/:id' do
        process_request(request, 'users_get') do |req, username|
          begin
            item = @@customers_model.delete_customer_followup_by_id(params[:id])
            if item
              @@logger.info("#{req.env["REQUEST_METHOD"]} #{req.fullpath} 200 OK. token user=#{username}")
              status 201
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

      # {
      #     "id": 3,
      #     "customer_id": "203",
      #     "added_by_user_name": "tu02",
      #     "fullname": "tufn02",
      #     "gender": 1,
      #     "title": null,
      #     "email": null,
      #     "phone_number": null,
      #     "other_contact_info": null,
      #     "comment": null,
      #     "created_at": "2018-07-08 22:53:53 +0800",
      #     "last_update_at": "2018-07-08 22:53:53 +0800",
      #     "status": 1
      # },
      def customer_contact_hash_to_customer_contact(customer_contact_hash)
        begin
          if customer_contact_hash && customer_contact_hash.class == Hash && customer_contact_hash.keys.size > 0
            customer_contact=YDAPI::BizEntity::CustomerContact.new
            customer_contact.id=customer_contact_hash["id"]
            customer_contact.customer_id=customer_contact_hash["customer_id"]
            customer_contact.added_by_user_name=customer_contact_hash["added_by_user_name"]
            customer_contact.fullname=customer_contact_hash["fullname"]
            customer_contact.gender=customer_contact_hash["gender"]
            customer_contact.title=customer_contact_hash["title"]
            customer_contact.email=customer_contact_hash["email"]
            customer_contact.phone_number=customer_contact_hash["phone_number"]
            customer_contact.other_contact_info=customer_contact_hash["other_contact_info"]
            customer_contact.comment=customer_contact_hash["comment"]
            customer_contact.status=customer_contact_hash["status"]
            customer_contact
          else
            nil
          end
        rescue Exception => e
          nil
        end
      end

      def customer_followup_hash_to_customer_followup(meta_hash)
        begin
          if meta_hash && meta_hash.class == Hash && meta_hash.keys.size > 0
            dest_obj=YDAPI::BizEntity::CustomerFollowup.new
            #--- common property
            dest_obj.id = meta_hash["id"]
            dest_obj.created_by = meta_hash["created_by"]
            dest_obj.last_update_by = meta_hash["last_update_by"]
            dest_obj.status = meta_hash["status"]
            dest_obj.comment = meta_hash["comment"]
            #--- customized property
            dest_obj.customer_id = meta_hash["customer_id"]
            dest_obj.user_name = meta_hash["user_name"]
            dest_obj.followup_description = meta_hash["followup_description"]
            dest_obj.followup_status = meta_hash["followup_status"]
            dest_obj.followup_method = meta_hash["followup_method"]
            dest_obj.followup_method_my_id = meta_hash["followup_method_my_id"]
            dest_obj.followup_method_customer_id = meta_hash["followup_method_customer_id"]
            dest_obj
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