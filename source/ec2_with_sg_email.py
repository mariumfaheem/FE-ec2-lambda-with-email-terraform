# We have a security group called RMD_CYBER_SECURITY, we need a lambda functions that scans all the ec2 instances in aws
# and if the the group mentioned above not found send a email to the team,
# and ask the function also gives us an option to as true or false to attach the group to the instance.
# And this process will trigger every day.

import json
import boto3
import os
import smtplib


region = os.getenv('REGION')
sender = os.getenv('sender')
receiver = os.getenv('receiver')
password =os.getenv('password')
host = "smtp.gmail.com"
port = 587
RMD_CYBER_SECURITY  = os.getenv('RMD_CYBER_SECURITY')
vpc_id =os.getenv('VPC_ID')


def send_email_to_stalkholder(instance_id,action):
    try:
        server = smtplib.SMTP(host, port)
        server.ehlo()
        server.starttls()
        server.login(sender, password)
        server.sendmail(sender, receiver,msg="Subject: RMD_CYBER_SECURITY Alert\n\n RMD_CYBER_SECURITY is not found instance "+instance_id+", current action is set to "+action + "For Further information please check EC2 instance" )
        server.close()
        return True
    except Exception as ex:
        print (ex)
        return False


def lambda_handler(event, context):
    action = event.get('action')
    ec2 = boto3.resource('ec2',region_name = region)
    instances = ec2.instances.filter()
    for instance in instances:
        if vpc_id==instance.vpc_id:
            all_sg_ids = [sg['GroupId'] for sg in instance.security_groups]
            if RMD_CYBER_SECURITY not in all_sg_ids:
                send_email_to_stalkholder(instance.id,action)
            else:
                if action=='True':
                    print("action")
                    all_sg_ids.append(RMD_CYBER_SECURITY)
                    instance.modify_attribute(Groups=all_sg_ids)


    return {
        'statusCode': 200,
        'body': json.dumps('success')
    }

