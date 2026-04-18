# python-docs-template

Starter template for a new [PEP 545](https://peps.python.org/pep-0545/)
translation of the Python documentation. Fork or copy this repository to
bootstrap a `python-docs-{LANGUAGE_TAG}` repo for any language.

The `main` branch carries the English source strings extracted from
CPython 3.14 (`make gettext` plus `sphinx-intl update`), with every
`msgstr` empty. Use it as the zero-state for a language you are about
to start translating.

## What is inside

- 535 `.po` files mirroring CPython's `Doc/` tree (flat layout: the same
  one used by `python/python-docs-fr`, `python/python-docs-tr`, etc.).
- `Makefile` pinned to a specific CPython commit so local builds are
  reproducible.
- `README.md`, `CONTRIBUTING.md`, `LICENSE` (CC0 1.0), `TRANSLATORS`,
  `.pre-commit-config.yaml`, `requirements-dev.txt`.

## Bootstrapping a new language

1. Pick a tag. Use the lowercased IETF BCP 47 tag with no redundant
   region subtag: `vi`, `ja`, `ko`, `de`, `pt-br`, `zh-hans`, ...
2. Fork or copy this repo to `python-docs-{TAG}`.
3. Edit `Makefile` and set `LANGUAGE := {TAG}`.
4. Rewrite `README.md` in the target language and add the PEP 545
   Documentation Contribution Agreement verbatim.
5. Add the initial coordinator to `TRANSLATORS`.
6. Start translating. Sphinx ignores fuzzy entries at build time, so
   partial translations are safe to merge.

## Regenerating the English source

If upstream CPython has moved and you want to refresh the msgids:

```sh
git clone --depth 1 --branch 3.14 https://github.com/python/cpython
cd cpython/Doc
make venv
make gettext
python3 -m pip install sphinx-intl
sphinx-intl update -p build/gettext -l {TAG}
rsync -a locales/{TAG}/LC_MESSAGES/ /path/to/python-docs-{TAG}/
```

The `sphinx-intl update` step runs `msgmerge` under the hood, so
existing translations are preserved and new/changed msgids surface as
fuzzy entries.

## Building the translated docs locally

```sh
python -m pip install -r requirements-dev.txt
make
```

This clones CPython into `venv/cpython/`, checks out the pinned commit,
copies the `.po` files into `locales/{LANGUAGE}/LC_MESSAGES/`, and runs
Sphinx with the target language. Output HTML lands in
`venv/cpython/Doc/build/html/index.html`.

## Documentation Contribution Agreement

Per PEP 545, contributions to a language translation are released under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). When you
fork this template for a new language, replace this section of the
downstream `README.md` with the agreement text quoted verbatim from
PEP 545 (translated teams typically keep the English agreement and add
a translated version below it).

## Real translations using this layout

- [python/python-docs-fr](https://github.com/python/python-docs-fr)
- [python/python-docs-tr](https://github.com/python/python-docs-tr)
- [python/python-docs-ja](https://github.com/python/python-docs-ja)
- [python/python-docs-ko](https://github.com/python/python-docs-ko)
- [python/python-docs-pt-br](https://github.com/python/python-docs-pt-br)
- [tamnd/python-docs-vi](https://github.com/tamnd/python-docs-vi)
