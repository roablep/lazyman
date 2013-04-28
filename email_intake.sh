#!/usr/bin/env python

'''
Gets email from outlook 
Thanks MM!
'''
import os, sys, imaplib, rfc822, re, StringIO
import email # for dealing with the actual email
import mimetypes
import zipfile
import csv
import pandas


server  ='foo.net'
username='.com'
password='SUPER SECRET'

print "Starting connection"
M = imaplib.IMAP4_SSL(server)
M.login(username, password)
print "Logged in"
M.select()
print "Selected inbox, starting search...",
# typ, data = M.search(None, '(UNSEEN FROM "Logwatch")')
typ, data = M.search(None, '(FROM "noreply@bar.net")')
print "completed search."
counter = 0
for num in data[0].split():
    typ, data = M.fetch(num, '(RFC822)')
    file = StringIO.StringIO(data[0][1])
    message = email.message_from_file(file)
    print message['from']
    print message['subject']
    for part in message.walk():
        # multipart/* are just containers
        if part.get_content_maintype() == 'multipart':
            continue
        # Applications should really sanitize the given filename so that an
        # email message can't be used to overwrite important files
        filename = part.get_filename()
        if not filename:
            continue
        print "attachment filename:",  filename
        counter += 1
        fn = "/tmp/"+filename
        fp = open(fn, 'wb')
        fp.write(part.get_payload(decode=True))
        fp.close()
        zipped_csv = zipfile.ZipFile(fn) # open the attachment as a zip stream
        for file in zipped_csv.namelist(): # should be just one
            print "file in zip", file
            temp_fn = "/tmp/%s" % file
            temp_fh_o = open(temp_fn, 'w')
            temp_fh_o.write(zipped_csv.read(file))
            temp_fh_o.close()
            df = pandas.read_csv(temp_fn, skiprows=14, skipfooter=1)
            print len(df)
            print df.head()
            os.system("rm %s" % temp_fn)
        os.system("rm %s" %fn)
    print '----'

M.close()
M.logout()
