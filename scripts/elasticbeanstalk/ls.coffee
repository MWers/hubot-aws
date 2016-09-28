# Description:
#   List elasticbeanstalk application info
#   Show detail about an application if specified an application name
#   Filter ec2 instances info if specified an instance name
#
# Commands:
#   hubot ec2 ls - Displays Instances

# Notes:
#   --instance_id=***     : [optional] The id of an instance. If omit it, returns info about all instances.
#   --instance_filter=*** : [optional] The name to be used for filtering return values by an instance name.

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
  robot.respond /elasticbeanstalk ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    ins_id  = arg_params.ins_id
    ins_filter = arg_params.ins_filter

    msg_txt = "Fetching #{ins_id || 'all (instance_id is not provided)'}"
    msg_txt += " containing '#{ins_filter}' in name" if ins_filter
    msg_txt += "..."
    msg.send msg_txt

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.describeInstances (if ins_id then { InstanceIds: [ins_id] } else null), (err, res) ->
      if err
        msg.send "DescribeInstancesError: #{err}"
      else
        if ins_id
          msg.send util.inspect(res, false, null)

          ec2.describeInstanceAttribute { InstanceId: ins_id, Attribute: 'userData' }, (err, res) ->
            if err
              msg.send "DescribeInstanceAttributeError: #{err}"
            else if res.UserData.Value
              msg.send new Buffer(res.UserData.Value, 'base64').toString('ascii')
        else
          messages = []
          for data in res.Reservations
            ins = data.Instances[0]

            name = '[NoName]'
            for tag in ins.Tags when tag.Key is 'Name'
              name = tag.Value

            continue if ins_filter and name.indexOf(ins_filter) is -1

            messages.push({
              name   : name || '[NoName]'
              ip     : ins.PrivateIpAddress
              type   : ins.InstanceType
              id     : ins.InstanceId
              time   : moment(ins.LaunchTime).fromNow()
# time   : moment(ins.LaunchTime).format('YYYY-MM-DD HH:mm:ssZ')
# state  : ins.State.Name
# image  : ins.ImageId
# az     : ins.Placement.AvailabilityZone
# subnet : ins.SubnetId
            })

          messages.sort (a, b) ->
# moment(a.time) - moment(b.time)
            if a.name > b.name
              return 1
            else if a.name < b.name
              return -1
            else
              return 0
          message = tsv.stringify(messages) || '[None]'
          message = '```' + message + '```'
          msg.send {text: message}
