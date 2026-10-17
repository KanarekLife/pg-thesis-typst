#   make                build the template and the example into build/
#   make test           compile the test documents
#   make check          version consistency, all builds and typst-package-check
#   make watch          rebuild the example on every change
#   make install        install as @preview/pg-thesis for local `typst init`
#   make thumbnail      regenerate thumbnail.png
#   make bundle         stage the package files in build/bundle/
#   make docs           rebuild the PDFs in docs/ (CI does this on main)
#   make publish        open the typst/packages pull request for this version

TYPST     ?= typst
CONTAINER ?= $(shell command -v podman || command -v docker)
NAME      := $(shell sed -n 's/^name = "\(.*\)"/\1/p' typst.toml)
VERSION   := $(shell sed -n 's/^version = "\(.*\)"/\1/p' typst.toml)
# Repository-only files, left out of the typst/packages submission. Files in
# typst.toml's `exclude` that the README links to (docs/) must stay in it.
REPO_ONLY := .github .gitignore examples scripts tests Makefile CHANGELOG.md
BUILD     := build
# Package cache in which @preview/$(NAME):$(VERSION) is this checkout, so the
# template compiles exactly as it does after `typst init`.
CACHE     := $(BUILD)/packages
DATA_DIR  ?= $(or $(XDG_DATA_HOME),$(HOME)/.local/share)
EXAMPLE   := examples/pg-official
SOURCES   := lib.typ src template examples typst.toml
# PDFs carry the author date of the last commit that changed the sources, so
# rebuilding unchanged sources gives byte-identical files.
EPOCH     := $(shell git log -1 --format=%at -- $(SOURCES) 2>/dev/null)
DOCS_FLAGS = $(if $(EPOCH),--creation-timestamp $(EPOCH))

.PHONY: all docs publish template example test check check-version package-check bundle watch install thumbnail clean

all: template example

$(CACHE)/preview/$(NAME)/$(VERSION):
	mkdir -p $(dir $@)
	ln -sfn $(CURDIR) $@

template: $(CACHE)/preview/$(NAME)/$(VERSION)
	$(TYPST) compile --package-cache-path $(CACHE) template/main.typ $(BUILD)/template.pdf

example: $(CACHE)/preview/$(NAME)/$(VERSION)
	$(TYPST) compile --package-cache-path $(CACHE) $(EXAMPLE)/main.typ $(BUILD)/example.pdf

docs: $(CACHE)/preview/$(NAME)/$(VERSION)
	mkdir -p docs
	$(TYPST) compile $(DOCS_FLAGS) --package-cache-path $(CACHE) template/main.typ docs/template.pdf
	$(TYPST) compile $(DOCS_FLAGS) --package-cache-path $(CACHE) $(EXAMPLE)/main.typ docs/example.pdf

test:
	@mkdir -p $(BUILD)
	for f in tests/*.typ; do $(TYPST) compile --root . $$f $(BUILD)/$$(basename $$f .typ).pdf || exit 1; done

# Every package import must use the version from typst.toml, and so must TAG
# when given (the release workflow passes the pushed tag).
check-version:
	@bad=$$(grep -rhoE '@preview/$(NAME):[0-9]+\.[0-9]+\.[0-9]+' template examples README.md \
		| grep -v ':$(VERSION)$$' || true); \
	if [ -n "$$bad" ]; then echo "Version mismatch with typst.toml ($(VERSION)):"; echo "$$bad"; exit 1; fi
	@grep -q '^## \[$(VERSION)\]' CHANGELOG.md || { echo "CHANGELOG.md has no entry for $(VERSION)"; exit 1; }
	@if [ -n "$(TAG)" ] && [ "$(TAG)" != "v$(VERSION)" ]; then echo "Tag $(TAG) does not match version $(VERSION)"; exit 1; fi
	@echo "Version $(VERSION) is consistent"

# The files submitted to typst/packages.
bundle:
	rm -rf $(BUILD)/bundle && mkdir -p $(BUILD)/bundle
	git ls-files -z | xargs -0 tar -c | tar -x -C $(BUILD)/bundle
	cd $(BUILD)/bundle && rm -rf $(REPO_ONLY)

# Lints exactly what gets submitted, plus Universe's thumbnail size rule.
package-check: bundle
	$(CONTAINER) run --rm -v $(CURDIR)/$(BUILD)/bundle:/data:Z ghcr.io/typst/package-check:0.7.0 check
	@size=$$(file thumbnail.png | grep -oE '[0-9]+ x [0-9]+' | tr -d ' ' | tr x ' '); \
	set -- $$size; long=$$(( $$1 > $$2 ? $$1 : $$2 )); \
	[ $$long -ge 1080 ] || { echo "thumbnail.png longest edge is $$long px; Universe requires >= 1080"; exit 1; }

check: check-version all test package-check

publish: check-version bundle
	scripts/publish.sh $(NAME) $(VERSION) $(BUILD)/bundle

watch: $(CACHE)/preview/$(NAME)/$(VERSION)
	$(TYPST) watch --package-cache-path $(CACHE) $(EXAMPLE)/main.typ $(BUILD)/example.pdf

install: bundle
	rm -rf $(DATA_DIR)/typst/packages/preview/$(NAME)/$(VERSION)
	mkdir -p $(DATA_DIR)/typst/packages/preview/$(NAME)
	cp -r $(BUILD)/bundle $(DATA_DIR)/typst/packages/preview/$(NAME)/$(VERSION)

thumbnail: $(CACHE)/preview/$(NAME)/$(VERSION)
	$(TYPST) compile --package-cache-path $(CACHE) --pages 7 --ppi 140 template/main.typ thumbnail.png

clean:
	rm -rf $(BUILD)
