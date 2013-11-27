""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File: youtube.vim                                        "
" Author: Anhad Jai Singh                                  "
" Licence: WTFPL2                                          " 
"                                                          "
" Requirements:                                            "
"   i)  vim with python support (+python)                  "
"   ii) VLC's CLI                                          "
" Other Notes:                                             "
"   Runs on Linux (tested)                                 "
"   Probably will run on Mac (untested)                    "
"   Probably won't run on Windows (points and laughs at MS)"
"   Output might vary according to VLC settings, especially"
"   if you allow multiple VLCs to play/run in parallel     "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! YoutubeSearchAndPlay()
python << EOF
import json, vim
import urllib2, urllib
import subprocess
import re

def playYoutube():

	def searchYoutube(search_string):
		query = { 'q' : search_string, 'alt' : 'json' }
		data = urllib.urlencode(query)
		url = 'http://gdata.youtube.com/feeds/api/videos' + '?' + data
		req = urllib2.Request(url)
		response = json.load(urllib2.urlopen(req))
		# Ref: https://developers.google.com/youtube/2.0/developers_guide_protocol?hl=en#Understanding_Video_Entries
		title = response['feed']['entry'][0]['title']['$t']
		link = response['feed']['entry'][0]['link'][0]['href']
		return (title,link)

	# Ref: http://vim.wikia.com/wiki/User_input_from_a_script
	# Something about Typeahead errors, what is that?
	vim.command('let youtube_pattern=input("%s")' % 'Search Youtube: ')
	search_string = vim.eval('youtube_pattern')
	# Used to "flush" the previous prompt
	vim.command('redraw')
	title,link = searchYoutube(search_string)
	subprocess.Popen(["cvlc", "--no-video", "-Idummy", "--quiet", link], stderr=subprocess.PIPE)
	print "►",title

playYoutube()
EOF
endfunction

" Map the search to F12
map <F12> :call YoutubeSearchAndPlay()<CR>
