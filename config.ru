require File.expand_path '../main.rb', __FILE__

run Rack::URLMap.new({
                         # '/auth' => YDAPI::BizService::PublicService,
                         '/api/common'=>YDAPI::BizService::CommonService,
                         '/api/users'=>YDAPI::BizService::UsersService,
                         # '/api/customers'=>YDAPI::BizService::CustomersService,
                         '/api/products'=>YDAPI::BizService::ProductsService,
                         '/api/orders'=>YDAPI::BizService::OrdersService,
                         '/api/notices'=>YDAPI::BizService::NoticesService,
                         '/api/inventories'=>YDAPI::BizService::InventoriesService,
                         '/api/fin'=>YDAPI::BizService::FinService,
                         '/api/service/auth'=>YDAPI::BizService::Service_Auth,
                         '/api/service/user'=>YDAPI::BizService::Service_User,
                         '/api/service/customer'=>YDAPI::BizService::Service_Customer,
                         '/api/service/order'=>YDAPI::BizService::Service_Order,
                         '/api/service/warehouse'=>YDAPI::BizService::Service_Warehouse
                     })