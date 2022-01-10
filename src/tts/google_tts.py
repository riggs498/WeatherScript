#!/usr/bin/python2
#
# google_tts.py - allstar Text to Speech
#
# by w0anm
#
# This script will convert text to speech (audio file). This uses google's
# online text to speech services.
#    http://translate.google.com/translate_tts?tl=en&"
#
#######################
# $Id: google_tts.py 28 2015-07-27 02:10:47Z w0anm $

import urllib, pycurl, os, sys

print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

print "length of string:"
print len(sys.argv[1])

textmsg=str(sys.argv[1])
print textmsg


def downloadFile(url, fileName):
    fp = open(fileName, "wb")
    curl = pycurl.Curl()
    curl.setopt(pycurl.URL, url)
    curl.setopt(pycurl.USERAGENT, 'Mozilla/5.0 (X11; Linux i686; rv:28.0) Gecko/20100101 Firefox/28.0')
    curl.setopt(pycurl.WRITEDATA, fp)
    curl.perform()
    curl.close()
    fp.close()

def getGoogleSpeechURL(phrase):
    googleTranslateURL = "http://translate.google.com/translate_tts?tl=en&"
    parameters = {'q': phrase}
    data = urllib.urlencode(parameters)
    googleTranslateURL = "%s%s" % (googleTranslateURL,data)
    return googleTranslateURL

# just download, don't play it
def speakSpeechFromText(phrase):
    googleSpeechURL = getGoogleSpeechURL(phrase)
    downloadFile(googleSpeechURL,"/tmp/tts/tts.mp3")
    # os.system("mplayer tts.mp3 -af extrastereo=0 &")
    # os.system("mplayer tts.mp3 > /dev/null 2>&1" )

# speakSpeechFromText("testing, testing, 1 2 3. Lets try this")
speakSpeechFromText(textmsg)
print "done..."
