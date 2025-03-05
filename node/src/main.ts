import Fastify, { FastifyReply, FastifyRequest } from 'fastify'

const fastify = Fastify({
  logger: true
})

fastify.get('/health', (request: FastifyRequest, reply: FastifyReply) => {
  reply.send({ message: 'healthy' })
})

fastify.listen({ port: 8080 }, (err: Error | null, address: string) => {
  if (err) {
    fastify.log.error(err)
    process.exit(1)
  }
})