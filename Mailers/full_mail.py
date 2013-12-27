#!/usr/bin/env python

#########################################################################
# Author: Anhad Jai Singh (:ffledgling)                                 #
# License: WTFPL2 [http://www.wtfpl.net/about/]                         #
#                                                                       #
# Description:                                                          #
#   A genric mail sending script with lots of options for cli useage.   #
#                                                                       #
# Note:                                                                 #
#   Although WTFPL2, an attribution/mention is always appreciated.      #
#########################################################################

import argparse
import getpass
import os
import sys

# Import smtplib to provide email functions
import smtplib

# Import the email modules
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Not verbose by default
verbose = False


class MailError(Exception):
# Generic MailError class
    def __init__(self, msg='Error while sending Mail'):
        self.msg = msg


parser = argparse.ArgumentParser(description='Mail utility script')

parser.add_argument('-a', '--attachment', help='attachment to be sent')
parser.add_argument('-f', '--force', help='Force send. Ignores lack of content, subject etc.',
                    action='store_true')
parser.add_argument('-l', '--list', help='List of emails to send to', required=True)
parser.add_argument('-m', '--server', help='Mail server\'s IP/URL', required=True)
parser.add_argument('-p', '--password', help='Password on cli. Optional.')
parser.add_argument('-s', '--subject', help='Subject for email.')
parser.add_argument('-t', '--text', help='file or string containing text')
parser.add_argument('-u', '--sender', help='Sender\'s user ID', required=True)
parser.add_argument('-v', '--verbose', help='Verbose output', action='store_true')
parser.add_argument('-w', '--wait', help='Wait time', type=int, default=1)
parser.add_argument('-x', '--html', help='file or string containing [X]HTML.')

args = parser.parse_args()

if args.verbose:
    verbose = True
    sys.stderr.write('Verbosity on.\n')

if verbose: sys.stderr.write('Error checking ...')
if not args.sender:
    raise MailError('No sender specified')

if not args.list:
    raise MailError('No reciepients specified')

if not args.server:
    raise MailError('No Mail Server Specified')

if not args.force:
    if not (args.text or args.html):
        raise MailError('No content specified')

    if not args.subject:
        raise MailError('Subject not specified')
else:
    if verbose: sys.stderr.write('Force. Skipping content and subject checks.')


if verbose: sys.stderr.write('Done.')

USER=args.sender
if verbose: sys.stderr.write('Sender username: %s\n' % (USER))

SERVER=args.server
if verbose: sys.stderr.write('Sender servername: %s\n' % (SERVER))

SUBJECT = args.subject if args.subject else ''
if verbose: sys.stderr.write('Subject: %s\n' % (SUBJECT))

ATTACHMENT = args.attachment if args.attachment else '' # Not supported at the moment
if verbose: sys.stderr.write('Attachment: %s\n ; Attachments not supported.\n' % (ATTACHMENT))

if args.text:
    if verbose: sys.stderr.write('Working on mail\'s text ...')
    if os.path.isfile(args.text):
        # It's a file, hopefully.
        if verbose: sys.stderr.write('It\'s a file\n')
        with open(args.text, 'r') as f:
            if verbose: sys.stderr.write('Reading from %s...' % args.text)
            TEXT = f.read()
        if verbose: sys.stderr.write('Done\n')
    else:
        if verbose: sys.stderr.write('It\'s text\n')
        # Assume it's text
        TEXT = args.text

if args.html:
    if verbose: sys.stderr.write('Working on mail\'s HTML ...')
    if os.path.isfile(args.html):
        # It's a file, hopefully.
        if verbose: sys.stderr.write('It\'s a file\n')
        with open(args.html, 'r') as f:
            if verbose: sys.stderr.write('Reading from %s...' % args.text)
            HTML = f.read()
        if verbose: sys.stderr.write('Done\n')
    else:
        # Assume it's text
        if verbose: sys.stderr.write('It\'s text\n')
        HTML = args.html
else:
    HTML = False

if args.list:
    if verbose: sys.stderr.write('Working on reciepient list ...')
    # Assume a list of \n (or , ?) separated emails
    if os.path.isfile(args.list):
        if verbose: sys.stderr.write('It\'s a file\n')
        # It's a file, hopefully.
        with open(args.list, 'r') as f:
            if verbose: sys.stderr.write('Reading from %s...' % args.text)
            LIST = f.read()
        if verbose: sys.stderr.write('Done\n')
    else:
        # Assume it's text
        if verbose: sys.stderr.write('It\'s text\n')
        LIST = args.list

if verbose: sys.stderr.write('Authenticating ...\n')
if args.password:
    PASS = args.password
else:
    PASS = getpass.getpass('Enter Password:')


### Large portions below shamelessly copied from Stackoverflow.com


for addr_to in LIST.split('\n')[:-1]:

    sys.stderr.write('Sending to ... %s ...' % addr_to)
    #sys.stdout.write('%s' % addr_to)
    # Define email addresses to use
    addr_from = USER+'@'+SERVER

    # Define SMTP email server details
    smtp_server = SERVER
    smtp_user   = USER
    smtp_pass   = PASS

    # Construct email
    msg = MIMEMultipart('alternative')
    msg['To'] = addr_to
    msg['From'] = addr_from
    msg['Subject'] = SUBJECT

    # Create the body of the message (a plain-text and an HTML version).
    text = TEXT if TEXT else '' # Text, otherwise empty string
    if HTML:
        html = HTML # Add HTML only if it's there

    # Record the MIME types of both parts - text/plain and text/html.

    # Attach parts into message container.
    # According to RFC 2046, the last part of a multipart message, in this case
    # the HTML message, is best and preferred.
    part1 = MIMEText(text, 'plain')
    msg.attach(part1)
    if HTML:
        part2 = MIMEText(html, 'html')
        msg.attach(part2)

    # Send the message via an SMTP server
    s = smtplib.SMTP(smtp_server)
    s.login(smtp_user, smtp_pass)
    s.sendmail(addr_from, addr_to, msg.as_string())
    sys.stderr.write('Done.\n')
    time.sleep(args.sleep)
s.quit()
