require 'json'
require 'jwt'
require 'sinatra/base'
require 'sequel'
require 'require_all'
require 'fileutils'

require './_conf/conf.rb'
require './_helpers/helper.rb'
require './_helpers/unify_logger.rb'
require './_helpers/request_processor.rb'
require './_helpers/jwt_auth.rb'

require_all './_biz/entity/'
require_all './_biz/model/db/'
require_all './_biz/model/'

require_all './_biz/service/'

# class Api < Sinatra::Base
#
#   use JwtAuth
#
#   def initialize
#     super
#
#     @accounts = {
#         tomdelonge: 10000,
#         markhoppus: 50000,
#         travisbarker: 1000000000,
#         admin:0
#     }
#   end
#
#   get '/money' do
#     process_request request, 'view_money' do |req, username|
#       content_type :json
#       { money: @accounts[username] }.to_json
#     end
#   end
#
#   post '/money' do
#     process_request request, 'add_money' do |req, username|
#       amount = req[:amount]
#       @accounts[username] += amount.to_i
#
#       content_type :json
#       { money: @accounts[username] }.to_json
#     end
#   end
#
#   delete '/money' do
#     process_request request, 'remove_money' do |req, username|
#       amount = request[:amount]
#
#       @accounts[username] -= amount.to_i
#       if @accounts[username] < 0
#         @accounts[username] = 0
#       end
#
#       content_type :json
#       { money: @accounts[username] }.to_json
#     end
#   end
#
#   # === api for orders
#   get '/orders' do
#     process_request request, 'view_all_orders' do |req, username|
#       content_type :json
#       [{
#            key: '1',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '2',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '李四',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '上产中'
#        }, {
#            key: '3',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '王五',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '4',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '赵钱',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '5',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '6',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '7',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '8',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '9',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '10',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }, {
#            key: '11',
#            orderID: 'T000008-1806160815',
#            orderType: '正式大单',
#            seller: '张三',
#            customer: '苏州一二三材料科技有限公司',
#            contractID: 'C000003-180616',
#            orderStartTime: '2018年06月16日',
#            orderStatus: '财务待审批'
#        }].to_json
#     end
#   end
#
#   def process_request req, scope
#     scopes, user = req.env.values_at :scopes, :user
#     username = user['username'].to_sym
#
#     if scopes.include?(scope) && @accounts.has_key?(username)
#       yield req, username
#     else
#       halt 403
#     end
#   end
# end