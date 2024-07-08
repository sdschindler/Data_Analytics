#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 23 13:45:21 2024

@author: stevenschindler
"""

import boto3

def upload_file(file_name, bucket_name, object_name=None):
    """Upload a file to an S3 bucket


    :return: True if file was uploaded, else False
    """

    # Upload the file
    s3_client = boto3.client('s3')
    try:
        if object_name is None:
            object_name = file_name
        response = s3_client.upload_file(file_name, bucket_name, object_name)
    except Exception as e:
        print(f"Error uploading file {file_name} to S3 bucket: {e}")
        return False
    print(f"File uploaded successfully")
    return True

file_name = 'kindle_data-v2.csv'
bucket_name = 'kindlesales'
object_name = 'kindleins3.csv'

if upload_file(file_name, bucket_name, object_name):
    print("upload sucessful!")
else:
    print("upload failed")