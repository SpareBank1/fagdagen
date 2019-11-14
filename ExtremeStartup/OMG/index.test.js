
const request = require('supertest')
const app = require('./server')

describe('Extreme startup server', () => {
  it('should create a new post', async () => {
    const res = await request(app)
      .get('/')
    expect(res.statusCode).toEqual(200)
    expect(res.text).toEqual('OK')
  })

  it('should respond with name', async () => {
    const res = await request(app)
      .get('/?q=3cd31d80:%20what%20is%20your%20name')
    expect(res.statusCode).toEqual(200)
    expect(res.text).toEqual('OMG')
  })
})

describe('Sample Test', () => {
  it('should test that true === true', () => {
    expect(true).toBe(true)
  })
})