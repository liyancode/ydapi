module YDAPI
  module BizEntity
    class UserAccount
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment
      attr_accessor :user_name
      attr_accessor :password
      attr_accessor :authorities
    end
  end
end