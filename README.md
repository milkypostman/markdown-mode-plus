# markdown-mode+

**DEPRECATED:** This package is not currently used by the maintainer and has an [active issue](https://github.com/milkypostman/markdown-mode-plus/issues/4) with undefined functions, so it seems reasonable to deprecated the package and remove it from MELPA. If the package gets updates in the future it will get un-deprecated and put back in to circulation.

Additional functions for Emacs [markdown-mode].  Default support for
[pandoc].  Much of the functionality is tailored to OS X, with the end
goal to extend `markdown-mode` in useful ways for all platforms.


## Functions

`markdown-cleanup-list-numbers`
:   Renumber the numbered lists in the current Markdown document.

`markdown-export-latex`
:   Export the document to [LaTeX].

`markdown-copy-html`
:   Render the Markdown as HTML, using the program specified by
    `markdown-command`, and copy it by piping it to `markdown-copy-command`.

`markdown-copy-paste-html` **OS X Only**
:   By default, generates HTML, copies to clipboard, changes to
    previous application, and pastes.  If a file with the current
    buffer name followed by `.meta` exists, the command reads the
    first line and changes to that application.  Allows use of the
    `HTML as Markdown in Emacs.applescript` which automatically
    generates this *meta* file.

`markdown-copy-rtf`
:   Generates RTF from Markdown using the `markdown-rtf-command` and
    copies to the clipboard.

## Variables

`markdown-copy-command`
:   Command that takes data as input and copies it to the clipboard.

`markdown-rtf-command`
:   Command to generate RTF from Markdown

`markdown-latex-export-command`
:   Command to export Markdown to LaTeX, destination filename is
    appended and is either the basename -- without extension -- with
    `.tex` appended.



markdown-mode: http://jblevins.org/projects/markdown-mode/
pandoc: http://johnmacfarlane.net/pandoc/
