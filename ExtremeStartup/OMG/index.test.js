
const request = require('supertest')
const app = require('./server')

describe('Get Hello World', () => {
  it('should create a new post', async () => {
    const res = await request(app)
      .get('/')
    expect(res.statusCode).toEqual(200)
    //console.log('', res)
    expect(res.text).toEqual('Hello World!')
  })
})

describe('Respond with name', () => {
  it('should create a new post', async () => {
    const res = await request(app)
      .get('/?q=3cd31d80:%20what%20is%20your%20name')
    expect(res.statusCode).toEqual(200)
    //console.log('', res)
    expect(res.text).toEqual('Hello World!')
  })
})



describe('Sample Test', () => {
  it('should test that true === true', () => {
    expect(true).toBe(true)
  })
})