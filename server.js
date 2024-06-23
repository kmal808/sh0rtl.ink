const express = require('express')
const app = express()
const PORT = 3000

app.use(express.json())

app.post('/shorten', (req, res) => {
	const { url } = req.body
	// Here, implement logic to generate short code and store it with the URL
	const shortCode = generateShortCode()
	storeUrl(shortCode, url)
	res.json({ shortUrl: `http://yourdomain.com/${shortCode}` })
})

app.get('/:shortCode', (req, res) => {
	const { shortCode } = req.params
	// Here, implement logic to retrieve the original URL using the short code
	const originalUrl = getUrl(shortCode)
	res.redirect(originalUrl)
})

app.listen(PORT, () => console.log(`Server running on port ${PORT}`))

function generateShortCode() {
	// Implement short code generation logic
}

function storeUrl(shortCode, url) {
	// Implement storage logic
}

function getUrl(shortCode) {
	// Implement retrieval logic
}
