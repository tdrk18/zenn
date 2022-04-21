bootstrap:
	@npm install

preview:
	@npx zenn preview

lint:
	@npx textlint -f checkstyle "articles/*.md" -o textlint_articles.log

new_article:
ifdef slug
	@npx zenn new:article --slug ${slug}
else
	@npx zenn new:article
endif
