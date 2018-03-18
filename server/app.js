const express = require("express")

const port = 4000
const app = express()

const html =
    `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Elm-SVG</title>
        <!-- <link rel="stylesheet" type="text/css" href="/static/styles.css"> -->
    </head>
    <body>
        <div id="elm-main"></div>
        <script src="/static/bundle.js"></script>
    </body>
    </html>
    `

app.get("/favicon.ico", express.static("static"))
app.use("/static", express.static("static"))
app.get("*", (req, res) => {
    res.send(html)
})

// Server
app.listen(port, () => console.log(`Server listening on port ${port}.`))
