---
layout: default
title: (*.log) Daily log
parent: Output files
nav_exclude: 1
nav_order: 14
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Daily log files
{: .no_toc }

Daily log files are ASCII files with the extension `.log`. They are usually found in the `MASH-FRET/log` installation folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Daily log files contain logs of the <u>action history</u> window.

They are automatically created at the `[...]/MASH-FRET/log` location, with `[...]` the installation folder.

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

