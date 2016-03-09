# flow-for-emacs

An emacs plugin for [Flow][flowtype], a static typechecker for JavaScript.

- Shows errors found by typechecking JavaScript code with Flow.
- Provides a bunch of common IDE features powered by Flow to aid reading and
  writing JavaScript code.

## Requirements

- Requires [Flow][flow] to be installed and available on your path.
- Requires projects containing JavaScript files to be initialised with `flow
  init`.
- Requires JavaScript files to be marked with `/* @flow */` at the top.

## Installation

```
cd ~/.emacs.d/
git clone https://github.com/flowtype/flow-for-emacs.git
echo -e "\n(load-file \"~/.emacs.d/flow-for-emacs/flow.el\")" >> ~/.emacs
```

## Commands

All Flow commands issued through the editor start a Flow server for the project
containing the current file (unless already started). Likewise, when you exit
the editor, the Flow server for the project containing the current file is
stopped.

### flow-status

Shows a list of current errors. 

Shortcut: `C-x RET`

### flow-type-at-pos

Shows the type of the expression at the current point.

Shortcut: `C-c C-t`

### flow-suggest

Shows a diff for the current file with missing types inferred.

Shortcut: `C-t`

### flow-get-def

Shows where the reference at the current point is defined.

Shortcut: `M-.`

### flow-autocomplete

Shows a list of possible completions at the current point.

Shortcut: `M-TAB`

[flowtype]: http://flowtype.org
[flow]: https://github.com/facebook/flow