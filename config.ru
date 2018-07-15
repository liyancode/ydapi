require File.expand_path '../main.rb', __FILE__

run Rack::URLMap.new({
                         '/auth' => YDAPI::BizService::PublicService,
                         '/api/users'=>YDAPI::BizService::UsersService,
                         '/api/customers'=>YDAPI::BizService::CustomersService,
                         '/api/products'=>YDAPI::BizService::ProductsService
                     })