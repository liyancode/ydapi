# load conf file
require 'yaml'
require 'logger'

CONF = YAML.load_file(File.dirname(__FILE__) + '/conf.yml')

SYSTEM_LOGGER = Logger.new(CONF["log_system"], 10, 10240000) # keep 10 old history each 10M size
SYSTEM_LOGGER.level = Logger::DEBUG

BIZ_MODEL_LOGGER = Logger.new(CONF["log_biz_model"], 10, 10240000)
BIZ_MODEL_LOGGER.level = Logger::INFO

BIZ_SERVICE_LOGGER = Logger.new(CONF["log_biz_service"], 10, 10240000)
BIZ_SERVICE_LOGGER.level = Logger::INFO

BIZ_SERVICE_W_LOGGER = Logger.new(CONF["log_biz_service_w"], 10, 10240000)
BIZ_SERVICE_W_LOGGER.level = Logger::INFO

# init DB
SYSTEM_LOGGER.info('system: connect db start...')
DB = Sequel.connect(CONF["db_connect_url"], user: CONF["db_username"], password: CONF["db_password"])
SYSTEM_LOGGER.info("system: connect db=>#{CONF["db_connect_url"]} success.")