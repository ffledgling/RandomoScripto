""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File: wiki.vim                                           "
" Author: Anhad Jai Singh                                  "
" Licence: WTFPL2                                          " 
"                                                          "
" Requirements:                                            "
"   i)  vim with python support (+python)                  "
"   (That's about it.)                                     "
"                                                          "
" Other Notes:                                             "
"   Tested on Linux.                                       "
"   Should ideally be cross platform given +python         "
"                                                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! WikipediaSearch()
    let wordUnderCursor = expand("<cword>")

    " TODO:
    " Add buffer magic here.
    " Display in a scratch/hidden buffer
    " Use scratch.vim for inspiration
    "
    " TODO:
    " Add supprt for phrase queries by using visual mode
    "
    " DAMN YOU BUFFERS
    " Y U SO HARD !!
    " :(

python << EOF
import json
import vim
import urllib, urllib2

"""
Sample query for the introductory paragraph for the article with title "Earth":
http://en.wikipedia.org/w/api.php?format=json&action=query&titles=Earth&prop=extracts&exintro

Ref:
https://www.mediawiki.org/wiki/API:Query
http://en.wikipedia.org/w/api.php
http://www.mediawiki.org/wiki/API:Main_page
https://www.mediawiki.org/wiki/Extension:TextExtracts#API
"""

def queryWikipedia():

    queryTerm = vim.eval('wordUnderCursor')

    queryParams  = {'format' : 'json', 'action' : 'query', 'titles' : queryTerm, 'prop' : 'extracts',
              'exintro' : '', 'explaintext' : '', 'redirects':''}
    queryData = urllib.urlencode(queryParams)

    queryURL = 'http://en.wikipedia.org/w/api.php'

    requestURL = queryURL + '?' + queryData

    try:
        request = urllib2.Request(requestURL)
        response = json.load(urllib2.urlopen(request))

        temp = response['query']['pages']
        theGoodStuff = temp[temp.keys()[0]]['extract']

    except:
        theGoodStuff = "Query seemed to have failed :("

    print "Wikipedia entry for %s Says:\n%s" % (queryTerm ,theGoodStuff)

queryWikipedia()

EOF
endfunction

map <F9> :call WikipediaSearch()<CR>
