#!/bin/bash

# Put any tasks you would like to have carried
# out when the container is first created here

echo Your container args are: "$@"

USER_NAME=`basename $HHHOME`
HOME_NAME=`dirname $HHHOME`

USER_ID=`ls -lahn $HOME_NAME | grep $USER_NAME | awk {'print $3'}`
GROUP_ID=`ls -lahn $HOME_NAME | grep $USER_NAME | awk {'print $4'}`

groupadd -g $GROUP_ID qgis
useradd --shell /bin/bash --uid $USER_ID --gid $GROUP_ID $USER_NAME
# to add parameters, you can do the following
# su $USER_NAME -c "/usr/bin/qgis --profiles-path  ${HOME}/mycustomprofilespath $*"

# all the startup options can be shown by uncommenting this line:
# su $USER_NAME -c "qgis --help"

su $USER_NAME -c "/usr/bin/qgis $*"
