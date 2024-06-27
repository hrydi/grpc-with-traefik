from concurrent import futures
import grpc
import os
import logging
from grpc_server.generated import ping_pb2
from grpc_server.generated import ping_pb2_grpc

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

class PingPongService(ping_pb2_grpc.PingPongServicer):
  def Start(self, request, context):
    logger.info('Receiving message from client %s', request.message)
    return ping_pb2.Pong(
      message='Pong' if request.message == 'Ping' else request.message
    )

def run():
  host = os.getenv('HOST') if os.getenv('HOST') is not None else '[::]'
  port = os.getenv('PORT') if os.getenv('PORT') is not None else '50051'
  address = '{host}:{port}'.format(host=host, port=port)
  server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
  ping_pb2_grpc.add_PingPongServicer_to_server(PingPongService(), server)
  server.add_insecure_port(address)
  server.start()
  logger.info('Server run @%s', address)
  server.wait_for_termination()

if __name__ == '__main__':
  run()
