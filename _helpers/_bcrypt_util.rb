module YDAPI
  module Helpers
    class BcryptUtil
      def BcryptUtil.bcrypt_plain_password(plain_password)
        BCrypt::Password.create(plain_password)
      end

      def BcryptUtil.check_password(plain_password,bcrypt_password)
        BCrypt::Password.new(bcrypt_password)==plain_password
      end
    end
  end
end