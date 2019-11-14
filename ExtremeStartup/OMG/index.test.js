
const request = require('supertest')
const app = require('./server')

describe('Extreme startup server', () => {

  it('should respond with name', async () => {
    const res = await request(app)
      .get('/?q=1bb1aad0:%20what%20is%20the%20english%20scrabble%20score%20of%20banana')
    expect(res.statusCode).toEqual(200)
    expect(res.text).toEqual('OMG')
  })
})

describe('Sample Test', () => {
  it('should test that true === true', () => {
    expect(true).toBe(true)
  })
})