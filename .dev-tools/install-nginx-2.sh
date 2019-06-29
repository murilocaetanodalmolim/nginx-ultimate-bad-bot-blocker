#!/bin/bash
# Travis CI Generating and Building for the Nginx Ultimate Bad Bot Blocker (using non standard folder locations)
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker

##############################################################################                                                                
#       _  __     _                                                          #
#      / |/ /__ _(_)__ __ __                                                 #
#     /    / _ `/ / _ \\ \ /                                                 #
#    /_/|_/\_, /_/_//_/_\_\                                                  #
#       __/___/      __   ___       __     ___  __         __                #
#      / _ )___ ____/ /  / _ )___  / /_   / _ )/ /__  ____/ /_____ ____      #
#     / _  / _ `/ _  /  / _  / _ \/ __/  / _  / / _ \/ __/  '_/ -_) __/      #
#    /____/\_,_/\_,_/  /____/\___/\__/  /____/_/\___/\__/_/\_\\__/_/         #
#                                                                            #
##############################################################################                                                                

# ------------------------------------------------------------------------------
# MIT License
# ------------------------------------------------------------------------------
# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza
# ------------------------------------------------------------------------------
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# ------------------------------------------------------------------------------
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# ------------------------------------------------------------------------------
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------

# ------------------------
# Set Terminal Font Colors
# ------------------------

bold=$(tput bold)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
defaultcolor=$(tput setaf default)

# ---------
# FUNCTIONS
# ---------

reloadNginX () {
printf "\n"
echo "${bold}${green}---------------"
echo "${bold}${green}Reloading Nginx"
echo "${bold}${green}---------------"
sudo nginx -t && sudo nginx -s reload
}

waitforReload () {
echo "${bold}${yellow}-----------------------------------------------------------------------"
echo "${bold}${yellow}Sleeping for 10 seconds to allow Nginx to Properly Reload inside Travis"
echo "${bold}${yellow}-----------------------------------------------------------------------"
printf "\n"
sleep 10s
}

cleanupNginx1 () {
echo "${bold}${yellow}-----------------------------------"
echo "${bold}${yellow}Removing Files from Install Nginx 1"
echo "${bold}${yellow}-----------------------------------"
printf "\n"
sudo rm /etc/nginx/sites-available/default.vhost
sudo rm /etc/nginx/sites-enabled/default.vhost
sudo rm /var/www/html/*
sudo rm /etc/nginx/conf.d/*.conf
sudo rm /etc/nginx/bots.d/*.conf
}

checkDirectories () {
ls -la /etc/nginx/conf.d/
ls -la /etc/nginx/bots.d/
ls -la /etc/nginx/sites-available/
ls -la /etc/nginx/sites-enabled/
ls -la /var/www/html/
echo "${bold}${yellow}-------------------------------------------------"
echo "${bold}${yellow}Confirming Files from Install Nginx 1 are Removed"
echo "${bold}${yellow}-------------------------------------------------"
printf "\n"
}

activateVHost () {
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/default.vhost /etc/nginx/sites-available/default.vhost
sudo ln -s /etc/nginx/sites-available/default.vhost /etc/nginx/sites-enabled/default.vhost
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/index.html /var/www/html/index.html
echo "${bold}${yellow}---------------------------------------------"
echo "${bold}${yellow}Activating default.vhost and linking to Nginx"
echo "${bold}${yellow}---------------------------------------------"
printf "\n"
}

getinstallngxblocker () {
printf "\n"
echo "${bold}${magenta}--------------------------------------"
echo "${bold}${magenta}Fetch install-ngxblocker from the repo"
echo "${bold}${magenta}--------------------------------------"
printf "\n"
sudo wget https://raw.githubusercontent.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker/master/install-ngxblocker -O /usr/sbin/install-ngxblocker
sudo chmod +x /usr/sbin/install-ngxblocker
}

runinstallngxblocker () {
echo "${bold}${magenta}--------------------------"
echo "${bold}${magenta}Execute install-ngxblocker"
echo "${bold}${magenta}--------------------------"
printf "\n"
cd /usr/sbin
sudo bash ./install-ngxblocker -x -c /usr/local/nginx/conf.d -b /usr/local/nginx/bots.d
}

runsetupngxblocker1 () {
echo "${bold}${magenta}------------------------"
echo "${bold}${magenta}Execute setup-ngxblocker"
echo "${bold}${magenta}------------------------"
printf "\n"
cd /usr/sbin
sudo bash ./setup-ngxblocker -x -c /usr/local/nginx/conf.d -b /usr/local/nginx/bots.d
}

makeScriptsExecutable () {
sudo chmod +x /usr/sbin/install-ngxblocker
sudo chmod +x /usr/sbin/setup-ngxblocker
sudo chmod +x /usr/sbin/update-ngxblocker
}

copyNginxConf () {
echo "${bold}${magenta}------------------------------"
echo "${bold}${magenta}Copy nginx.conf to /etc/nginx/"
echo "${bold}${magenta}------------------------------"
printf "\n"
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/test_units/nginx.conf-newformat /etc/nginx/nginx.conf
}

loadNginxConf () {
echo "${bold}${magenta}---------------"
echo "${bold}${magenta}Load nginx.conf"
echo "${bold}${magenta}---------------"
printf "\n"
sudo nginx -c /etc/nginx/nginx.conf
}

forceUpdateTest1 () {
printf "\n"
echo "${bold}${yellow}----------------------------------------------------"
echo "${bold}${yellow}Copy older globalblacklist.conf file to force update"
echo "${bold}${yellow}----------------------------------------------------"
printf "\n"
sudo cp ${TRAVIS_BUILD_DIR}/.dev-tools/globalblacklist-dummy.conf /usr/local/nginx/conf.d/globalblacklist.conf
}

forceUpdateTest2 () {
printf "\n"
echo "${bold}${yellow}--------------------------------------"
echo "${bold}${yellow}Delete Files to test update-ngxblocker"
echo "${bold}${yellow}--------------------------------------"
printf "\n"
sudo rm /usr/local/nginx/conf.d/*.conf
sudo rm /usr/local/nginx/bots.d/*.conf
ls -la /usr/local/nginx/conf.d/
ls -la /usr/local/nginx/bots.d/
}

runupdatengxblocker () {
printf "\n"
echo "${bold}${magenta}-------------------------"
echo "${bold}${magenta}Execute update-ngxblocker"
echo "${bold}${magenta}-------------------------"
printf "\n"
cd /usr/sbin
sudo bash ./update-ngxblocker -c /usr/local/nginx/conf.d -b /usr/local/nginx/bots.d -n
}

activateLatestBlacklist () {
printf "\n"
echo "${bold}${yellow}------------------------------------------------------------"
echo "${bold}${yellow}Make sure we test with latest generated globalblacklist.conf"
echo "${bold}${yellow}------------------------------------------------------------"
printf "\n"
sudo cp ${TRAVIS_BUILD_DIR}/conf.d/globalblacklist.conf /usr/local/nginx/conf.d/globalblacklist.conf
}

backupConfFiles () {
printf "\n"
echo "${bold}${green}------------------------------------------------------------"
echo "${bold}${green}Make Backup all conf files and folders used during this test"
echo "${bold}${green}------------------------------------------------------------"
printf "\n"
sudo cp /usr/local/nginx/bots.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/conf_files_test2/bots.d/
sudo cp /usr/local/nginx/conf.d/* ${TRAVIS_BUILD_DIR}/.dev-tools/conf_files_test2/conf.d/
sudo cp /etc/nginx/sites-available/default.vhost ${TRAVIS_BUILD_DIR}/.dev-tools/conf_files_test2/default.vhost
sudo cp /etc/nginx/nginx.conf ${TRAVIS_BUILD_DIR}/.dev-tools/conf_files_test2/nginx.conf
}


# -----------------
# Trigger Functions
# -----------------

cleanupNginx1
checkDirectories
activateVHost
getinstallngxblocker
runinstallngxblocker
makeScriptsExecutable
copyNginxConf
runsetupngxblocker1
loadNginxConf
forceUpdateTest1
runupdatengxblocker
reloadNginX
waitforReload
forceUpdateTest2
runupdatengxblocker
runsetupngxblocker1
reloadNginX
waitforReload
activateLatestBlacklist
runsetupngxblocker1
reloadNginX
waitforReload
backupConfFiles

# ----------------------
# Exit With Error Number
# ----------------------

exit ${?}

# ------------------------------------------------------------------------------
# MIT License
# ------------------------------------------------------------------------------
# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza
# ------------------------------------------------------------------------------
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# ------------------------------------------------------------------------------
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# ------------------------------------------------------------------------------
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------
