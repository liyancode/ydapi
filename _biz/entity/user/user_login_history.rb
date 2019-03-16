module YDAPI
  module BizEntity
    class UserLoginHistory
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment
      attr_accessor :user_name
      attr_accessor :rq_scheme
      attr_accessor :rq_host
      attr_accessor :rq_port
      attr_accessor :rq_path
      attr_accessor :rq_ip
      attr_accessor :rq_user_agent
      attr_accessor :ip_location_info
      attr_accessor :login_in_or_out
      attr_accessor :result
      attr_accessor :other
    end
  end
end