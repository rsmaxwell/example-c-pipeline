#!/bin/bash

REPOSITORY=releases
REPOSITORYID=releases

GROUPID=com.rsmaxwell.example
ARTIFACTID=example-c_amd64-linux
VERSION=${BUILD_ID}
PACKAGING=zip

URL=https://server.rsmaxwell.co.uk/archiva/repository/${REPOSITORY}

FILENAME=${ARTIFACTID}_${VERSION}.${PACKAGING}

rm -rf ~/workspace/example-c_main/deploy
mkdir -p ~/workspace/example-c_main/deploy

cd ~/workspace/example-c_main/bin
zip ../deploy/${FILENAME} *

cd ~/workspace/example-c_main/deploy
mvn --batch-mode deploy:deploy-file -DgroupId=${GROUPID} -DartifactId=${ARTIFACTID} -Dversion=${VERSION} -Dpackaging=${PACKAGING} -Dfile=${FILENAME} -DrepositoryId=${REPOSITORYID} -Durl=${URL} -DrepositoryId=${REPOSITORYID}

