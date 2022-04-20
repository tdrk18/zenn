bootstrap:
	npm install

preview:
	npx zenn preview

lint:
	npx textlint -f checkstyle "articles/*.md" -o textlint_articles.log

new_article:
	npx zenn new:article
