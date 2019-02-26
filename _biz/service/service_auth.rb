module YDAPI
  module BizService
    class Service_Auth < Sinatra::Base
      @@logger = BIZ_SERVICE_LOGGER
      @@config = CONF
      @@helper = YDAPI::Helpers::Helper
      @@user_model = YDAPI::BizModel::UsersModel

      @@model_user = YDAPI::BizModel::Model_User
      @@bcrypt_util = YDAPI::Helpers::BcryptUtil

      post '/login' do
        begin
          username = params[:username]
          password = params[:password]
          @@logger.info("POST /login username=#{username}")
          user_account = @@model_user.get_user_account_by_user_name(username)
          if user_account
            if @@bcrypt_util.check_password(password, user_account.password)
              @@logger.info("POST /login username=#{username} 200 OK.")
              content_type :json
              {
                  token: token(username, user_account.authorities),
                  authorityHash: @@helper.get_authority_hash(@@config['authority_hash_default'], user_account.authorities)
              }.to_json
            else
              @@logger.info("POST /login username=#{username} 401 Unauthorized.")
              halt 401
            end
          else
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