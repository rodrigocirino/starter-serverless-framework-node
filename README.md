# curso-intro-serverless

# Run

```sh
#
#
# NOT NECESSARY, CREATE NOTHING IN AWS CONSOLE
# DONT CREATE A DYNAMODB OR LAMBDA FUNCTIONS..
# THIS PROJECT IS READY FOR DEPLOY TO AWS, BUT RUN AND DEBUG LOCALLY
#

npm install

#// popule um json com random values
npm run fixtures

#// cria a pasta e faz o download de ./.dynamobd/DynamoDBLocal.jar
sls dynamodb install

# start dynamo+handler.js, dev is the default
sls offline start --stage dev

# Run in debug mode
node --inspect=0.0.0.0:9000 ./node_modules/serverless/bin/serverless.js offline start

# Test application
curl --location --request GET 'http://localhost:3000/${stage}/pacientes?limit=2' | jq

```
