module YDAPI
  module BizService
    class PublicService < Sinatra::Base
      @@logger = BIZ_SERVICE_LOGGER
      @@config = CONF
      @@helper = YDAPI::Helpers::Helper
      @@user_model = YDAPI::BizModel::UsersModel
      post '/login' do
        begin
          username = params[:username]
          password = params[:password]
          @@logger.info("#{self} POST /login username=#{username}")
          user = @@user_model.get_user_by_user_name(username)
          if user
            if user.password == password
              @@logger.info("#{self} POST /login username=#{username} 200 OK.")
              content_type :json
              {token: token(username, user.authority)}.to_json
            else
              @@logger.info("#{self} POST /login username=#{username} 401 Unauthorized.")
              halt 401
            end
          else
            @@logger.info("#{self} #{request.env["REQUEST_METHOD"]} #{request.fullpath} 404 Not Found.")
            halt 404
          end
        rescue Exception => e
          @@logger.error("#{self} POST /login 500 Internal Server Error. Exception:#{e}")
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
            scopes: @@helper.get_scopes_by_user_authority(authority),
            user: {
                username: username,
                authority: authority
            }
        }
      end
    end
  end
end