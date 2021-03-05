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

### ---------------------------------------------------------------------------------------

$ sls deploy --stage dev
$ sls deploy --stage qa

# remova tudo criado pelo sls deploy
$ serverless remove --stage dev --region us-east-1

## outros comandos
$ sls deploy
$ serverless create --template aws-nodejs --path temp
$ aws dynamodb batch-write-item --request-items file://pacientes.dynamodb.json
$ sls logs -f cadastro-pacientes-dev-obterPaciente --tail
$ sls logs -f https://xzf7jccxwg.execute-api.us-east-1.amazonaws.com/dev/pacientes --tail


======== SERVERLESS + AWS ==============================

- Instalar o AWS CLI e o Serverless, ambos via curl  no ubuntu
	- serverless é um aplicativo node, mas que roda nativo no ubuntu.
- Teste AWS
$ aws help
- Teste Serverless
- sls é um comando node run, logo sls sobe todas as instancias em package.json também!
$ sls help
$ serverless plugin list

- Crie um usuário padrão no IAM e configure na máquina local
$ aws configure

- Crie uma lambda function padrão no Console do AWS

- Teste com a lambda default criada criando um test no topo da página ou

- Crie um projeto nodejs local e suba via upload na lambda
	$ mkdir meus-clientes
	$ cd meus-clientes/
	$ npm init -y
	$ echo "console.log('Running');" >  handler.js
	$ node handler.js
	$ zip -r deploy.zip index.js node_modules/

- Upload via aws cli
	$ zip -r deploy.zip index.js node_modules/
	$ aws lambda update-function-code --function-name lambda-serverless-backside --zip-file fileb://deploy.zip

- Serverless config
- Crie os arquivos de configuracao
	$ serverless create --template aws-nodejs --path clientes-less
	$ cd clientes-less
	$ sls invoke local -f hello  # hello é o nome da funcao no handler.js

- Altere o handler.js para module.exports.meusClientes = async (event) .....
- Altere o serverless.yml para functions: meusClientes: handler: handler.meusClientes

- Passando parametros testando local
	$ sls invoke local -f meusClientes -d '{"teste":"ok"}'

- Deploy na AWS de produção !
- Configure o IAM para poder acessar o CloudFormation, S3, IAM, CloudWatchLogs, Lambda

- CloudFormation
- Vai ser criado uma stack https://console.aws.amazon.com/cloudformation
- Serverless usa o stage:dev para definir o ambiente ex: clientes-less-dev

- Abra a Lambda
- Resources > Physical ID > AWS::Lambda::Function

- Acesso via GET com API GATEWAY
- Antes de acesso IAM > permita uso de AmazonApiGateway

- Altere o serverless.yml
	events:
	  - httpApi:
		  path: /users/create

- Deploy via serverless
$ sls deploy
$ sls deploy -f minhaFunction
$ curl https://vcdgtid75f.execute-api.us-east-1.amazonaws.com/clientes | jq '.'

- Veja os logs usando o nome da funcao
https://www.serverless.com/framework/docs/providers/aws/cli-reference/logs/
$ sls logs -f listarPacientes -t
$ sls logs -f obterPaciente -t

- ===================================================================================================
- ====================== TESTANDO LOCALMENTE O SERVERLESS SEM SLS DEPLOY ============================
somente fazer (sls deploy) depois de testar tudo local
https://www.serverless.com/plugins/ e digite offline
$ npm i serverless-offline --save-dev
- Add in serverless.yml plugin line
- Check if is confg is ok
$ serverless --verbose
- Run locally
- See the logs in the same terminal of run
$ sls offline

- DynamoDB
- TABELA NAO SERA USADA APENAS PARA APRENDER !!!!!!
- Crie uma tabela no AWS Console
	- nome:pacientes
	- chave de partição: paciente_id:String
	- não marcar "Adicionar chave e classificação"
- Depois criado acesse a aba Item > Criar Item
	- Altere de tree para text no canto superior esquerda da modal aberta
	- Cole o json abaixo	{
		"paciente_id": "1-a",
		"nome": "Joe",
		"email": "joe@doe.com",
		"telefone": "41999999999"
		"data_nascimento": "2021-01-01",
		"status": true,
	},
	{
		"convenios": [
			"PARTICULAR",
			"EMPRESARIAL"
		],
		"data_nascimento": "2021-02-02",
		"email": "saint@doe.com",
		"nome": "Saint",
		"paciente_id": "2-a",
		"status": true,
		"telefone": "419999222222"
	}

- Exclua a tabela anterior, vamos criar no serverless!
- Permita o uso do DynamoDB
- Local não da erro porque local usamos nossas credencias de administrador local
- adicione iamRoleStatements
	provider:
	name: aws
	iamRoleStatements:
		- Effect: Allow
		Action:
			- DynamoDB:Query
			- DynamoDB:Scan
			- DynamoDB:PutItem
			- DynamoDB:DeleteItem
			- DynamoDB:GetItem
		Resource: arn:aws:DynamoDB:us-east-1:0000000000000:table/PACIENTES
		--MENSAGEM DE ERRO JÁ DIZ QUAL ARN INCLUIR


- No serverless.yml crie um novo resource
- Resources são recursos como Banco de dados ou Repositores do S3
https://www.serverless.com/framework/docs/providers/aws/guide/resources/
- Veja que é igual ao site acima
	resources:
	Resources:
		PacientesTable:
		Type: AWS::DynamoDB::Table
		Properties:
			TableName: PACIENTES
			AttributeDefinitions:
			- AttributeName: paciente_id
				AttributeType: S
			KeySchema:
			- AttributeName: paciente_id
				KeyType: HASH
			ProvisionedThroughput:
				ReadCapacityUnits: 1
				WriteCapacityUnits: 1

- Use o DynamoDB no seu código-fonte
	...
	const dynamoDb = new AWS.DynamoDB.DocumentClient();
	const params = {
		TableName: "PACIENTES",
	};
	...
	//scan information inside table
	let data = await dynamoDb.scan(params).promise();
	console.log(JSON.stringify(data.Items));
	...

- Popule o banco de dados com um json via aws-cli
$ aws DynamoDB batch-write-item --request-items file://pacientes.dynamoDb.json
$ sls deploy
$ curl --location --request GET 'https://aaaaa.execute-api.us-east-1.amazonaws.com/dev/pacientes/1234-def'

- Adicione um novo cliente
- se adicionar um com o mesmo id ele apenas atualiza sem criar ou novo
	curl --location --request POST 'http://localhost:3000/dev/pacientes' \
	--header 'Content-Type: application/json' \
	--data-raw '{
		"paciente_id": "999-abc",
		"nome": "Joe Doe",
		"data_nascimento": "2021-02-02",
		"email": "Joe@doe.com",
		"telefone": "419999222222"
	}'

- Deletar um paciente_id
- Para economizar em cloud ao inves de fazer duas operacoes uma para chegar se existe outra para deletar
	usamos a ConditionExpression da delete do DynamoDB
		await dynamoDb.delete({ ...params, 
			Key: {
			paciente_id: pacienteId
			},
			ConditionExpression: 'attribute_exists(paciente_id)'
		}).promise()
