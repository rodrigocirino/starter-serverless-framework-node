#!/bin/bash
# -----------------------------------------------------------------------------
set -e
print() {
cat <<EOF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF
}
cat <<EOF
################################################################################
                $0
################################################################################
EOF
# -----------------------------------------------------------------------------



#
#
# NOT NECESSARY, CREATE NOTHING IN AWS CONSOLE
# DONT CREATE A DYNAMODB OR LAMBDA FUNCTIONS..
#
#

npm install
#// popule um json com random values
npm run fixtures
# //not necessary create a aws console db table
npm i serverless-dynamodb-local --save-dev
#// cria a pasta e faz o download de ./.dynamobd/DynamoDBLocal.jar
sls dynamodb install
# start db+api
sls offline start
# ou defina o stage 
# // $ sls offline start --stage dev, dev é o default
# Test application
curl --location --request GET 'http://localhost:3000/${stage}/pacientes?limit=2' | jq





# -----------------------------------------------------------------------------
cat <<EOF
################################################################################
        End of $0
################################################################################
EOF
