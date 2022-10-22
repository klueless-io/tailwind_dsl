# UI Components

A set of UI Components with supporting files.

Most of these files started from `templates/tailwind` where the original HTML component examples were stored.

This list of files was then processed to generate files under `ui-components/tailwind`

The output files are segmented by their extension.

## templates/tailwind

The original HTML file will contain tailwind CSS with both static content data. Any comments that were originally in the file are there as well. These files can be considered the source of truth and basically are copied form a source.

## ui-components/tailwind

- `[component-group][component-name].settings.json` - any settings that can be extracted from original html or have been manually updated live in this file.
- `[component-group][component-name].data.json` - any data that can be extracted from the HTML is in this file, this is done using GPT3.
- `[component-group][component-name].astro` - the HTML component and it's data interface (Astro.props) go into this file



