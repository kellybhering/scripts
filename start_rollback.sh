####################################################################################
# Install aws command to you machine                                               #
#                                                                                  #
# Clone secops repository                                                          #
#                                                                                  #
# Setup your ~/.aws/credentials file:                                              #
# [default]                                                                        #
# AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxx                                            #
# AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxx                                            #
#                                                                                  #
#                                                                                  #
# Setup your ~/.aws/setup file:                                                    #
# SECOPS_CMD='secops command to run'                                               #
# ROLLBACK_CMD='rollback command to run. Variables ${application}, ${package} and  #
# ${version} are needed                                                            #
# AWS_REGION=xxxxxx                                                                #
# PROFILE_NAME='profile name used on secops command' 
#                                                                                  #
####################################################################################

echo "Your aws credentials are:"
echo
cat ~/.aws/credentials
source ~/.aws/setup
echo

eval $SECOPS_CMD

access_key="aws configure get --profile ${PROFILE_NAME} aws_access_key_id"
secret_access_key="aws configure get --profile ${PROFILE_NAME} aws_secret_access_key"
session_token="aws configure get --profile ${PROFILE_NAME} aws_session_token"

export AWS_ACCESS_KEY_ID=`$access_key`
export AWS_SECRET_ACCESS_KEY=`$secret_access_key`
export AWS_SESSION_TOKEN=`$session_token`

echo
echo "These are the environment variables created:"
printenv | grep AWS

echo
read -p "Do you want to rollback a package? (y/n)"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  read -p "Type the tag Application from the host to rollback: "
  application=$REPLY
  read -p "Type the package's name: "
  package=$REPLY
  read -p "Type the version to rollback to: "
  version=$REPLY

  echo
  rollbk_cmd=${ROLLBACK_CMD/'${application}'/$application}
  rollbk_cmd=${rollbk_cmd/'${package}'/$package}
  rollbk_cmd=${rollbk_cmd/'${version}'/$version}  
  echo $rollbk_cmd
  read -p "Above command is about to run, are you sure? (y/n)"

  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval $rollbk_cmd  
  fi    
fi
 
