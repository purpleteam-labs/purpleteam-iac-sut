# Copyright (C) 2017-2021 BinaryMist Limited. All rights reserved.

# This file is part of PurpleTeam.

# PurpleTeam is free software: you can redistribute it and/or modify
# it under the terms of the MIT License.

# PurpleTeam is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# MIT License for more details.

import boto3
import json
import sys


def json_serial(obj):
    """JSON serializer for objects not serializable by default json code
        Args:
            obj: object to serialize into JSON
    """
    _serialize = {
        "int": lambda o: int(o),
        "float": lambda o: float(o),
        "decimal": lambda o: float(o) if o % 1 > 0 else int(o),
        "date": lambda o: o.isoformat(),
        "datetime": lambda o: o.isoformat(),
        "str": lambda o: o,
    }
    return _serialize[type(obj).__name__.lower()](obj)


def pretty_json(dict):
    """
    Pretty print Python dictionary
    Args:
        dict: Python dictionary
    Returns:
        Pretty JSON
    """
    return json.dumps(dict, indent=2, default=json_serial, sort_keys=True, )


def get_nlb_private_ips(data):
    session = boto3.Session(region_name=data['aws_region'], profile_name=data['aws_profile'])
    ec2 = session.client('ec2')
    response = ec2.describe_network_interfaces(
        Filters=[
            {
                'Name': 'description',
                'Values': [
                    "ELB net/{AWS_NLB_NAME}/*".format(
                        AWS_NLB_NAME=data['aws_nlb_name'])
                ]
            },
            {
                'Name': 'vpc-id',
                'Values': [
                    data['aws_vpc_id']
                ]
            },
            {
                'Name': 'status',
                'Values': [
                    "in-use"
                ]
            },
            {
                'Name': 'attachment.status',
                'Values': [
                    "attached"
                ]
            }
        ]
    )

    # print(pretty_json(response))
    interfaces = response['NetworkInterfaces']

    # ifs = list(map(lamba index: interfaces[index]['PrivateIpAddresses'], xrange(len(interfaces))))
    # --------------------------------------------------------------------------------
    # Private IP addresses associated to an interface (ENI)
    # Each association has the format:
    #   {
    #     "Association": {
    #       "IpOwnerId": "693054447076",
    #       "PublicDnsName": "ec2-52-88-47-177.us-west-2.compute.amazonaws.com",
    #       "PublicIp": "52.88.47.177"
    #     },
    #     "Primary": true,
    #     "PrivateDnsName": "ip-10-5-1-205.us-west-2.compute.internal",
    #     "PrivateIpAddress": "10.5.1.205"
    #   },
    # --------------------------------------------------------------------------------
    associations = [
        association for interface in interfaces
        for association in interface['PrivateIpAddresses']
    ]
    # --------------------------------------------------------------------------------
    # Get IP from each IP association
    # --------------------------------------------------------------------------------
    private_ips = [association['PrivateIpAddress'] for association in
                   associations]

    return private_ips


def load_json():
    data = json.load(sys.stdin)
    return data


def main():
    #print sys.argv[1]
    #print sys.argv[2]
    #print sys.argv[3]
    #print sys.argv[4]
    data = load_json()
    """
    print(data['aws_region'])
    print(data['aws_vpc_id'])
    print(data['aws_nlb_name'])
    print(data['aws_profile'])
    """
    ips = get_nlb_private_ips(data)
    print(json.dumps({"private_ips": json.dumps(ips)}))


if __name__ == '__main__':
    main()
