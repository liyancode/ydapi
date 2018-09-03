require File.expand_path '../main.rb', __FILE__

run Rack::URLMap.new({
                         '/auth' => YDAPI::BizService::PublicService,
                         '/api/common'=>YDAPI::BizService::CommonService,
                         '/api/users'=>YDAPI::BizService::UsersService,
                         '/api/customers'=>YDAPI::BizService::CustomersService,
                         '/api/products'=>YDAPI::BizService::ProductsService,
                         '/api/orders'=>YDAPI::BizService::OrdersService
                     })