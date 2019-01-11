const exp = require('express')
const app = exp()
const fsx = require('fs-extra')

app.use(exp.static(__dirname))

app.get('/', (req, res) => {
  res.sendFile(__dirname + '/index.html')
})

app.listen(8080, err => {
  // if (err) throw err
  console.info('> xplex-hq running on http://localhost:8080/')
})
