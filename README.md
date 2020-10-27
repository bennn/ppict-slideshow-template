ppict-slideshow-template
===

A simple `#lang slideshow` program that uses the `ppict` library.


# How to Install

1. [Set your PATH environment variable](https://github.com/racket/racket/wiki/Set-your-PATH-environment-variable) 
so you can use `raco` and other Racket command line functions.
2. either look for `from-template` in the DrRacket menu **File|Package Manager**, or run the `raco` command:
```bash
raco pkg install from-template
```
3. run this `raco` command:
```bash
raco new ppict-slideshow-template <destination-dir>
```
If you omit `<destination-dir>`, the command will copy the template to a folder called `ppict-slideshow-template` in the current folder.
4. install the newly-cloned package:
```bash
# optional: change the package name in 'info.rkt'
cd <destination-dir>
raco pkg install
```


# How to Use

To make a new slide, start by editing the code at the bottom of the file and
then run this command to generate a picture:

```bash
make pict
```

To preview the slideshow, run the following command. (If you are using the same
terminal window to edit the show, add an `&` to the end.)

```bash
make preview
```

To run the show:

```bash
make show
```

To create a PDF copy, run this command and hit "Enter" when a dialog box appears
on your screen:

```bash
make pdf
```


# Note

The `.ss` file extension is a pre-Racket way to make a PLT Scheme file.
I think it stands for "Scheme script."
Because a Slideshow program is similar to a Racket program but not really the
same, I like using `.ss` for "slide show" code.

The PLT Scheme website may say more about the `.ss` extension:
<https://www.plt-scheme.org>

