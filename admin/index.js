const exp = require('express')
const rbp = require('body-parser')
const app = exp()
const fsx = require('fs-extra')

app.use(exp.static(__dirname))

app.use(rbp.json())
app.use(rbp.urlencoded({ extended: true }))

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
})

app.post('/ingests', (req, res) => {
  fsx.writeJSON('./ingests.json', req.body.ingests)
  res.status(204).send({})
})

app.listen(8080, err => {
  // if (err) throw err
  console.info('> xplex-hq running on http://localhost:8080/')
})
