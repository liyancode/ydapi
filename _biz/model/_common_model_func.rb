module YDAPI
  module BizModel
    class CommonModelFunc
      def CommonModelFunc.common_add(obj_class, obj, dao_class, logger, log_bind_class, log_func_name)
        if obj.is_a?(obj_class)
          dao_class.func_add(obj)
        else
          logger.error("#{log_bind_class}.#{log_func_name}, param is not a #{obj_class}")
          nil
        end
      end
    end
  end
end