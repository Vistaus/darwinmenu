# Darwin Menu Translations

Translation system powered by custom Ruby scripts. All logic lives in `translate/translation-lib/`.

## Install

Make the launcher executable:

```sh
chmod +x translation
```

Then run from `translate/`:

```sh
./translation build
```

To test in Plasma:

```sh
./translation build && plasmoidviewer ..
```

## Add a New Translation

**Option 1 — via issue:**

1. Translate [`template.pot`](template.pot) and save as `yourlang.txt`
2. Open a [new issue](https://github.com/lasaczka/darwinmenu/issues/new) and attach the file

**Option 2 — via pull request:**

1. Copy `template.pot` to `xx.po` (e.g. `fr.po`)
2. Fill in all `msgstr ""` entries

## Workflow

```sh
./translation extract   # scan source files and generate template.pot
./translation merge     # update .po files from template.pot
./translation build     # compile .po to .mo and install to contents/locale
./translation status    # show translation progress
```

## Status

See [`Status.md`](Status.md)
