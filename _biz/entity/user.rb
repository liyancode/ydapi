module YDAPI
  module BizEntity
    class User
      attr_accessor :id
      attr_accessor :user_id
      attr_accessor :user_name
      attr_accessor :password
      attr_accessor :authority
      attr_accessor :type
      attr_accessor :status

      def to_s
        {
            :user_id=>@user_id,
            :user_name=>@user_name,
            :authority=>@authority,
            :type=>@type,
            :status=>@status
        }.to_s
      end
    end
  end
end