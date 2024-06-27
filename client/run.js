const PROTO_PATH = __dirname + '/../backend/grpc_server/protofiles/ping.proto'
const grpc = require('@grpc/grpc-js')
const protoLoader = require('@grpc/proto-loader')
const packageDefinition = protoLoader.loadSync(
  PROTO_PATH,
  {
    keepCase: true,
    longs: String,
    enums: String,
    defaults: true,
    oneofs: true
  }
)

const ping_proto = grpc.loadPackageDefinition(packageDefinition).ping
function run() {
  const client = new ping_proto.PingPong(`grpc.web.local:80`, grpc.credentials.createInsecure())
  client.Start({ message: 'PingPing' }, function(err, response) {
    console.log({
      err,
      response
    });
  })
}

run()