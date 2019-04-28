---
layout: default
title: (*.log) Daily log
parent: /output-files.html
nav_order: 14
nav_exclude: 1
---


# Daily log files
{: .no_toc }

Daily log files are ASCII files with the extension `.log`. They are usually found in the main`/log` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Daily log files contain logs of the <u>action history</u> window.

They are automatically created at the `rootfolder/log` location, with rootfolder the current root folder.

They are automatically updated when:
- new actions are added to the action history,
- closing MASH-FRET.


---

## File name

The file is named after its date of creation using the format `YYYY-M-D.log`.


---

## Structure

<u>Time</u> of action and action <u>description</u> are recorded using the following structure:

```
hh:mm -- action desription
```

