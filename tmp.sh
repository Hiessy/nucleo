#!/usr/bin/env bash
TIMESTAMP=$(date +"%Y%m%d_%H%M");
LOG_FILE="/Users/martin.diaz/Documents/workspace/other/ms-start-up/log/ms_$TIMESTAMP.log";
WORKSPACE="~/Documents/workspace";
BASECONFPATH="/conf/base.conf";
BASECONFLINES[0]='creditMicroservice.hostUrl="http://localhost:9010"';
BASECONFLINES[1]='microservice.api.credit.enabled = "true"';

function log()
{
    timestamp=$(date +"%Y-%m-%d %T")
    echo "$timestamp $1 -- $2"
    echo "$timestamp $1 -- $2" >> "$LOG_FILE"
}


###
## Takes in two arguments:
##  $1: full path of the file to be searched in
##  $2: Array of Strings to be matched against
## 
## If found while set value of MATCHFOUND 1, if not found to -1 
## if error to 0
###
function searchInFile()
#Genera un arreglo con el contenido de $BASECONFPATH y lo guarda en TARGETFILE_ARRAY
#

{
  IFS=$'\r\n' GLOBIGNORE='*' command eval 'TARGETFILE_ARRAY=($(cat $BASECONFPATH))'
  #Arreglo con las lineas necesarias para el micro servicio
  for neededLine in ${BASECONFLINES[@]}
    do
      i=0
      #Arreglo con las lineas ingresadas
      for fileLine in ${TARGETFILE_ARRAY[@]}
        do
          log "DEBUG" "comparing line $fileLine in base.conf agaisnt $neededLine"
          if [[ $fileLine == *"$neededLine"* ]]; then
              log "DEBUG" "base config line ${BASECONFLINES[i]} for index $i was found"
              BASECONFLINES[$i]="1"
              i=$i+1
              break
          fi
        done
      if [[ BASECONFLINES[$i] != *"1"* ]]; then
        log "ERROR" "/conf/base.conf file is missing line: ${BASECONFLINES[i]}"
        break;
      fi
    done
}

function readLines()
{
  IFS=$'\r\n' GLOBIGNORE='*' command eval 'TARGETFILE_ARRAY=($(cat $BASECONFPATH))'
  COUNTER=0
  for line in ${TARGETFILE_ARRAY[@]}
    do 
      echo The counter is $line
      let COUNTER=COUNTER+1 
    done
}

####
## Starts vagrant 
## 
##
####
function startVagrant()
{
 log "INFO" "Starting vagrant locally"
 cd $WORKSPACE/vagrant-datastores; 
 vagrant up
 log "INFO" "Stopping vagrant subscriber"
 cd $WORKSPACE/vagrant-datastores/scripts/;
 ./stop_subscriber
}

# read base.conf
    # check for line `creditMicroservice.hostUrl = "http://localhost:9010"` and `microservice.api.credit.enabled = "true"`
    # if not present write the lines to file

function startDocker(){
  open --background -a Docker
}


#check if vagrant is up 
 #start vagrant 
# after vagrant starts stop subscriber
# start docker desktop

# start subscriber
  #read log for ok 

# start business-api
  #read log for ok 

# start mock-fico-service
  #read log for ok 

# start credit-service
  #read log for ok 

# start residential
	#read log for ok 
log "INFO" "Checking /conf/base.conf for correct configuration"
readLines
#searchInFile
#startVagrant
#startDocker

log "INFO" "Starting subscriber application"
#osascript -e 'tell app "Terminal" do script "cd $WORKSPACE/subscriber/;sbt ~tomcat:start" end tell'

# osascript -e 'tell app "Terminal" 
#  do script "echo subscriber"
#end tell'

log "INFO" "mock-fico-service"

#osascript -e 'tell app "Terminal" 
#  do script "cd $WORKSPACE/mock-fico-service/;sbt runAll" 
#end tell'

log "INFO" "business-api"
#osascript -e 'tell app "Terminal" 
#  do script "cd $WORKSPACE/business-api; sbt ~tomcat:start" 
#end tell'

log "INFO" "credit-service"
#osascript -e 'tell app "Terminal" 
#  do script "cd $WORKSPACE/credit-service/; sbt ~tomcat:start" 
#end tell'
