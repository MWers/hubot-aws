moment = require 'moment'
util   = require 'util'
tsv    = require 'tsv'

getArgParams = (arg) ->
  ins_id_capture = /--instance_id=(.*?)( |$)/.exec(arg)
  ins_id = if ins_id_capture then ins_id_capture[1] else ''

  # filter by instance name
  ins_filter_capture = /--instance_filter=(.*?)( |$)/.exec(arg)
  ins_filter = if ins_filter_capture then ins_filter_capture[1] else ''

  return {
    ins_id: ins_id,
    ins_filter: ins_filter
  }

module.exports = (robot) ->
  robot.respond /test ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    ins_id  = arg_params.ins_id
    ins_filter = arg_params.ins_filter

    msg_txt = "Testing message formatting..."
    msg_txt += "```preformatted text```"
    msg.send msg_txt

  robot.respond /test longmsg(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    ins_id  = arg_params.ins_id
    ins_filter = arg_params.ins_filter

    msg_txt = "```name    ip    type    id    time\n
SnapLogic POC    10.128.131.231    m4.large    i-03e59a46    a month ago\n
Wowza-Staging    10.128.131.200    c4.2xlarge    i-c36fa654    a month ago
[NoName]    10.128.130.14    t2.micro    i-c6471a73    2 months ago
[NoName]    10.128.131.252    m4.xlarge    i-a9409b3e    5 days ago
[NoName]    10.128.130.97    t2.large    i-3e69998a    6 days ago
[NoName]    10.128.130.136    t2.large    i-576696e3    6 days ago
[NoName]    172.31.14.149    t2.medium    i-28cae79d    2 months ago
auth-service-staging    10.128.131.130    t2.small    i-e2f2b3a7    a month ago
auth-service-staging    10.128.130.79    t2.small    i-fd03e649    a month ago
bw-subs-svc-fe-staging    10.128.130.183    t2.small    i-5123dce5    6 hours ago
bw-subs-svc-fe-staging    10.128.131.19    t2.small    i-a15015e4    a month ago
bw-web-staging    10.128.131.105    t2.small    i-54edac11    a month ago
bw-web-staging    10.128.130.131    t2.small    i-ccc23578    10 days ago
cameras-service-staging    10.128.130.38    t2.small    i-51c521e5    a month ago
cameras-service-staging    10.128.131.81    t2.small    i-c63ce351    10 days ago
dev-airflow-webserver-1    10.128.130.76    t2.medium    i-b48fa401    2 months ago
dev-airflow-worker-1    10.128.131.84    t2.medium    i-983b7cdd    a month ago
dev-julian-test    10.128.131.92    t2.micro    i-a6946e31    4 months ago
dev-nfs-primary-1    10.128.130.200    m4.large    i-0f8c9eba    10 days ago
dev-science-dev-1    10.128.130.51    m4.large    i-1c8c8ea9    a month ago
dev-science-tools-test-2    10.128.131.18    t2.micro    i-9271a805    7 days ago
entitle-service-staging    10.128.131.63    t2.small    i-867ab711    4 months ago
entitle-service-staging    10.128.130.67    t2.small    i-9337c827    8 hours ago
forecast-api-dev    10.128.130.90    t2.medium    i-78ab9fcd    2 months ago
ft-subs-svc-fe-staging    10.128.131.178    t2.small    i-509f4bc7    22 days ago
ft-subs-svc-fe-staging    10.128.130.214    t2.small    i-3ad6348e    22 days ago
geotarg-service-staging    10.128.130.9    t2.small    i-f2cea347    4 months ago
geotarg-service-staging    10.128.131.44    t2.small    i-667bb6f1    4 months ago
nat-common-us-west-1b    10.128.128.206    t2.medium    i-efd8cf5d    8 months ago
nat-common-us-west-1c    10.128.129.37    t2.medium    i-793bf4ba    8 months ago
oauth2-server-staging    10.128.131.142    t2.micro    i-4afb21dd    4 days ago
passwor-service-staging    10.128.130.116    t2.small    i-1fc3aeaa    4 months ago
passwor-service-staging    10.128.131.162    t2.small    i-9f67aa08    4 months ago
redir-service-staging    10.128.130.110    t2.micro    i-2ae0de9f    2 months ago
science-dev-airflow-spark-redis-INT    10.128.131.164    r3.xlarge    i-50967cc7    5 months ago
science-dev-data-processing-2    10.128.131.40    t2.medium    i-0d9b12ce    6 months ago
science-dev-workflow-scripts-INT    10.128.131.181    t2.medium    i-bb736d2f    19 days ago
science-network-test    10.128.131.93    t2.micro    i-3e67bbfd    7 months ago
science-reviewcam    10.128.131.5    t2.micro    i-066a1343    a month ago
science-setdetect-test    10.128.131.197    t2.micro    i-59127e1c    2 months ago
science-toolbox-ami-test    10.128.130.175    t2.micro    i-9da82528    5 months ago
sing-common-us-west-1b    10.128.128.49    t2.small    i-d9d8cf6b    2 months ago
sl-ecs-admin-tools-sandbox    10.128.130.68    t2.small    i-2dff0299    3 days ago
sl-ecs-admin-tools-sandbox    10.128.131.228    t2.small    i-22db7eb5    3 days ago
sl-ecs-admin-tools-staging    10.128.130.50    t2.small    i-54fb06e0    3 days ago
sl-ecs-admin-tools-staging    10.128.131.185    t2.small    i-0eda7f99    3 days ago
sl-ecs-logging-service-staging    10.128.131.188    t2.medium    i-cba9228e    3 months ago
sl-ecs-proxy-services-staging    10.128.130.208    t2.medium    i-b45f1f01    3 months ago```
```sl-integration-test-staging    10.128.131.219    t2.micro    i-d53a4f90    2 months ago
staging-coldfusion-api-1    10.128.131.163    t2.large    i-ae6bfaeb    3 months ago
staging-coldfusion-api-2    10.128.130.133    t2.large    i-5b402bee    3 months ago
staging-coldfusion-app-1    10.128.131.190    t2.large    i-3ebd2d7b    3 months ago
staging-coldfusion-app-2    10.128.130.147    t2.large    i-4d442ff8    3 months ago
staging-common-mongodb-1    10.128.130.114    m4.large    i-111990a4    4 months ago
staging-common-mongodb-2    10.128.131.241    m4.large    i-b84ebf2f    4 months ago
staging-common-mongodb-3    10.128.130.174    m4.large    i-207eef95    4 months ago
staging-common-proxy-1    10.128.131.79    t2.micro    i-811256c4    a month ago
staging-common-proxy-2    10.128.130.119    t2.micro    i-d6baa863    a month ago
staging-fishtrack-proxy-1    10.128.130.47    t2.micro    i-7a36dace    20 days ago
staging-fishtrack-proxy-2    10.128.131.30    t2.micro    i-529442c5    20 days ago
staging-micro-services-proxy-1    10.128.130.239    t2.micro    i-8ec0553b    4 months ago
staging-web-proxy-1    10.128.131.15    t2.micro    i-4f41050a    a month ago
sturdy-wowza-tester    10.128.130.148    t2.large    i-0eeb14ba    15 hours ago
subsc-servi-backe-stagi    10.128.131.136    t2.small    i-647bb6f3    4 months ago
subsc-servi-backe-stagi    10.128.130.211    t2.small    i-28d28b9d    2 months ago
subscri-service-staging    10.128.131.253    t2.small    i-c6f3b283    a month ago
subscri-service-staging    10.128.130.191    t2.small    i-f3cba646    4 months ago
surfline-migration-devserver    10.128.131.224    m4.2xlarge    i-22b83667    a month ago
surfline-test-install    10.128.131.234    t2.micro    i-4d5cd58e    6 months ago
surfline-wowza-recorder-wc-qa    10.128.129.36    t2.medium    i-9d50880a    6 days ago
user-service-staging    10.128.130.252    t2.small    i-2203e696    a month ago
user-service-staging    10.128.131.222    t2.small    i-e4f2b3a1    a month ago
vpn-common-us-west-1b    10.128.128.5    t2.small    i-e4c7d056    8 months ago
wowza-test-1    10.128.131.172    t2.medium    i-5e731a1b    2 months ago```"
    msg.send msg_txt

