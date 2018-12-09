module YDAPI
  module BizEntity
    class UserDepartment
      attr_accessor :id
      attr_accessor :created_by
      attr_accessor :last_update_by
      attr_accessor :status
      attr_accessor :comment
      attr_accessor :department_id
      attr_accessor :parent_department_id
      attr_accessor :department_name
      attr_accessor :department_manager
      attr_accessor :department_employee_count
      attr_accessor :department_description
    end
  end
end