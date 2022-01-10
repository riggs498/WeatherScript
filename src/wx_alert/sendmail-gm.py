#!/usr/bin/python2
#
# sendmail-gm.py  - allstar wxscripts
#
#  by w0anm
#
# This script allows a user to send mail using their gmail account.  This is
# used to send weather alert messages if desired.  
#
# you will need to edit the file to include your gmail account information.
# Keep in mind that this is open text and anyone that reads this file can gain
# access to your gmail account.
#
#####################
# $Id: sendmail-gm.py 15 2015-01-07 23:59:43Z w0anm $

import sys, getopt
import smtplib
import ConfigParser

Subject = ''
Email_Addr = ''
ConfigFile = '/usr/local/etc/.sendmail.cfg'

# arguments
def main(argv):
   Subject = 'test message'
   Email_Addr = ''
   Inputfile = ''

   try:
      opts, args = getopt.getopt(argv,"hs:e:i:")
   except getopt.GetoptError:
      print '\nsendmail.py -s [<subject>] -e <Email_Addr> [-i <inputfile>]'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print '\nsendmail.py -s <subject> -e <Email_Addr> [-i <inputfile>]'
         sys.exit()
      elif opt in ("-s"):
         Subject = arg
      elif opt in ("-e"):
         Email_Addr = arg
      elif opt in ("-i"):
         Inputfile = arg


   # get the configuration values
   config = ConfigParser.RawConfigParser()
   config = ConfigParser.RawConfigParser(allow_no_value=True)
   config.read(ConfigFile)

   gmail_user = config.get('gmail_send', 'user')
   gmail_pwd = config.get('gmail_send', 'password')
   gmail_from= config.get('gmail_send', 'from')

   TO = [Email_Addr] #must be a list
   TEXT=''

   # if inputfile defined, then skip standard in
   if Inputfile == '':
       data = sys.stdin.readline()
       lines=''
       while data:
           lines=lines + data
           data = sys.stdin.readline()
 
   else:
       f = open(Inputfile)
       data= f.readline()
       lines=''
       while data:
           lines=lines + data
           data = f.readline()

       f.close() 

   TEXT=lines
       
   # Prepare actual message
   message = """\From: %s\nTo: %s\nSubject: %s\n\n%s
   """ % (gmail_from, ", ".join(TO), Subject, TEXT)
   try:
        #server = smtplib.SMTP(SERVER)
        server = smtplib.SMTP("smtp.gmail.com", 587) #or port 465 doesn't seem to work!
        server.ehlo()
        server.starttls()
        server.login(gmail_user, gmail_pwd)
        server.sendmail(gmail_from, TO, message)
        #server.quit()
        server.close()
        print 'successfully sent the mail'
   except:
        print "failed to send mail"

if __name__ == "__main__":
   main(sys.argv[1:])
