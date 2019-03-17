module YDAPI
  module BizService
    class Service_Auth < Sinatra::Base
      @@logger = BIZ_SERVICE_LOGGER
      @@config = CONF
      @@helper = YDAPI::Helpers::Helper
      @@user_model = YDAPI::BizModel::UsersModel

      @@model_user = YDAPI::BizModel::Model_User
      @@bcrypt_util = YDAPI::Helpers::BcryptUtil

      def add_login_history(user_name,request,result)
        begin
          Thread.new{
            begin
              ip=request.ip
              if ip and ip!='127.0.0.1'
                ip_location=@@helper.get_ip_location_info(ip)
                ip_location_info=''
                if ip_location
                  ip_location_info=ip_location.to_json
                end
                user_login_history=YDAPI::BizEntity::UserLoginHistory.new
                user_login_history.created_by=user_name
                user_login_history.last_update_by=user_name
                user_login_history.user_name=user_name
                user_login_history.rq_scheme=request.scheme
                user_login_history.rq_host=request.host
                user_login_history.rq_port=request.port
                user_login_history.rq_path=request.path
                user_login_history.rq_ip=ip
                user_login_history.rq_user_agent=request.user_agent
                user_login_history.ip_location_info=ip_location_info
                user_login_history.login_in_or_out='login'
                user_login_history.result=result
                if @@model_user.add_user_login_history(user_login_history)==nil
                  @@logger.error("add_login_history(#{user_name},*,*) fail")
                end
              end
            rescue Exception=>e
              @@logger.error("add_login_history(#{user_name},*,*) Exception:#{e}")
            end
          }
        rescue Exception=>e
          @@logger.error("add_login_history(#{user_name},*,*) Exception:#{e}")
        end
      end
      post '/login' do
        begin
          username = params[:username]
          password = params[:password]
          @@logger.info("POST /login username=#{username}")
          user_account = @@model_user.get_user_account_by_user_name(username)
          if user_account
            if @@bcrypt_util.check_password(password, user_account.password)
              @@logger.info("POST /login username=#{username} 200 OK.")
              add_login_history(username,request,200)
              content_type :json
              {
                  token: token(username, user_account.authorities),
                  authorityHash: @@helper.get_authority_hash(@@config['authority_hash_default'], user_account.authorities)
              }.to_json
            else
              @@logger.info("POST /login username=#{username} 401 Unauthorized.")
              add_login_history(username,request,401)
              halt 401
            end
          else
            add_login_history(username,request,404)
            @@logger.info("#{request.env["REQUEST_METHOD"]} #{request.fullpath} 404 Not Found.")
            halt 404
          end
        rescue Exception => e
          @@logger.error("POST /login 500 Internal Server Error. Exception:#{e}")
          halt 500
        end
      end

      def token(username, authority)
        JWT.encode(payload(username, authority), @@config['auth_jwt_secret'], 'HS256')
      end

      def payload(username, authority)
        {
            exp: Time.now.to_i + @@config["auth_token_expire"].to_i,
            iat: Time.now.to_i,
            iss: @@config['auth_jwt_issuer'],
            # scopes: @@helper.get_scopes_by_user_authority(authority),
            scopes: ['_hb_','users_get', 'users_update', 'users_add', 'users_delete'],
            user: {
                username: username,
                authority: authority
            }
        }
      end
    end
  end
end