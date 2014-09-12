#!/bin/bash

################################################################################
# Author: Anhad Jai Singh                                                      #
#                                                                              #
# Works with the index.html.template to be found in the same directory         #
################################################################################

# Specify file paths
TEMPLATE_PATH="/some/path"
PAGE_PATH="/some/other/path"



# Basic function definitions
yes(){
  echo "<font color='#D00000'>Yep.</font>"
}
no(){
  echo "<font color='#00CC00'>Nope.</font>"
}
probably(){
  echo "<font color='#CC9933'>It might be. idk man, I'm just a script.</font>"
}

# Check if uplink works
check_nkn(){

  ping -c 5 -q -W 2 google.com &>/dev/null
  STATUS=$?

  if [ $STATUS -eq 0 ]; then
    no
  else
    yes
  fi
}

# Check if squid is doing well
check_proxy(){

  /sbin/service squid status &>/dev/null
  STATUS=$?

  if [ $STATUS -eq 0 ];
  then
    no
  else
    # Sometimes there are greater problems than just the service not running
    yes
  fi
}


NKN=$(check_nkn)
PROXY=$(check_proxy)
TIMESTAMP=$(date)

# This is pretty tacky
STATUS=$(echo $NKN | grep -q Yep && echo $PROXY | grep -q Yep && echo Up || echo Down)

# Didn't sed have a way to apply multiple exprs in one go?
sed "s,{nkn},$NKN," $TEMPLATE_PATH |
sed "s,{proxy},$PROXY," |
sed "s,{updated},$TIMESTAMP," |
sed "s,{status},$STATUS," > $PAGE_PATH
