# !/usr/bin/python
# -*- coding: utf-8 -*-
"""
    @Version:     python-2.7.11
    @Author:      cnshhi
    @CreateTime:  2016/10/25 10:02
    @linux:       redhat6.3
    @Description: 
"""

import smtplib
import string
import os
import urllib, urllib2
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from time import *

STIME = strftime('%Y-%m-%d_%k:%M', localtime(time()))
FROM = "cdrwarning@travelsky.com"
TO = ['**@travelsky.com', '**@travelsky.com']
password = "******"


pwd = os.getcwd()
text_ = pwd + '/ogg_status.log'
HOST = "mail.travelsky.com"
#HOST = "smtp.travelsky.com"

msg = MIMEMultipart()
msg['Subject'] = "ogg status"
msg['From'] = FROM
msg['To'] =','.join(TO)

xlsxpart = MIMEApplication(open(text_, 'rb').read())
xlsxpart.add_header('Content-Disposition', 'attachment', filename=STIME+'--ogg_status.doc'.\
        decode("utf-8").encode("gb18030"))
msg.attach(xlsxpart)
try:
    server = smtplib.SMTP()
    server.connect(HOST, "25")
    #server.connect(HOST,"465")
    server.starttls()
    server.login(FROM, password)
    server.sendmail(msg['From'], TO, msg.as_string())
    server.quit()
except smtplib.SMTPRecipientsRefused:
    print 'Recipient refused'
except smtplib.SMTPAuthenticationError:
    print 'Auth error'
except smtplib.SMTPSenderRefused:
    print 'Sender refused'
except smtplib.SMTPException,e:
    print e.message



