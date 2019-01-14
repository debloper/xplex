const exp = require('express')
const rbp = require('body-parser')
const fsx = require('fs-extra')
const exe = require('child_process').exec

const app = exp()

app.use(exp.static(__dirname))

app.use(rbp.json())
app.use(rbp.urlencoded({ extended: true }))

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
})

app.post('/ingests', (req, res) => {
  fsx.writeJSON('./ingests.json', req.body.ingests)

  let nginxConfig = ''
  for (let ingest of req.body.ingests) {
    nginxConfig = [nginxConfig, ['push ', ingest, ';'].join(''),].join('\n')
  }

  fsx.outputFile('/usr/local/nginx/conf/xplex.conf', nginxConfig)
  .then(() => {
    res.status(204).send({})
    exe('/usr/local/nginx/sbin/nginx -s reload')
  })
  .catch(err => res.status(500).send({}))
})

app.listen(8080, err => {
  // if (err) throw err
  console.info('> xplex-hq running on http://localhost:8080/')
})
