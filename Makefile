.DEFAULT_GOAL := help
.PHONY: help build

help: ## Show this help
	@grep -hE '^[a-zA-Z0-9_.-]+:' $(MAKEFILE_LIST) | grep -vE '^[a-zA-Z0-9_.-]+:=' | \
		awk 'BEGIN {FS = ":"} /^\./ {next} {name = $$1; sub(/[[:blank:]]+$$/, "", name); doc = $$0; sub(/^[^#]*## /, "", doc); if (doc == $$0) sub(/^[^:]*:[[:blank:]]*/, "", doc); printf "  \033[36m%-20s\033[0m %s\n", name, doc}'

build: ## Render the tech posts to wwwroot with pandoc
	@rm -rf wwwroot
	@mkdir -p wwwroot/tech
	@-cp -r src/static/* wwwroot/ 2> /dev/null || true
	@for f in src/tech/*.md; do \
		[ -e "$$f" ] || continue; \
		pandoc "$$f" -o "wwwroot/tech/$$(basename "$${f%.md}.html")" --template=src/templates/tech.html; \
	done
	@-cp -r src/tech/*.html wwwroot/tech/ 2> /dev/null || true
