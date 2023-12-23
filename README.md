# UoYPhDThesis: an accessible template for PhD Theses at UoY

This repository contains a full template for writing a thesis at the University of York.
In particular, a new class called `uoythesis` is defined as a wrapper of the `memoir` class in order to provide the appropriate formatting for the title page required by the university, and to help students write their thesis by providing a working sandbox.
Another goal of this template is to make it as good as possible with regards to digital accessibility, using different capabilities of pdf tagging provided by the `hyperref` package and the LaTeX core.
There are still many things which are not optimal with this regard, but we will keep improving this template as new developments are added to the core of LaTeX3.


## Who is this for?
This template can be used by anyone at the University of York who wishes to typeset their PhD thesis into LaTeX while respecting the university regulations by default.
Of course, you are free to tweak any file and to adapt the style to your liking, or even to use it for other projects.

A preliminary version of this template has been used for the past two years by PhDs in the mathematics department, and its good reception prompted the initial author to share it more widely.

## How does this template work?

The idea of this template is to separate the different parts of the LaTeX required to write a thesis into multiple files in order to facilitate the writing process as well as the maintaining of it as the years go by.
Hence, the `Thesis.tex` file only contains the general structure of the final thesis, by delegating the text of the actual content to other files located in subfolders.
<details>
<summary>List of files with short description</summary>

- `uoythesis.cls`: the class file acting as a wrapper for `memoir`
- `uoythesisoptions.sty`: a package-style file to help setting options for the class and where you can customize the look of the thesis
- `preamble.tex`: a tex file to put all the packages you need to use and your personal macros
- `Thesis.tex`: the tex file of the thesis itself
- `abstract.tex`, `acknowledgements.tex`, `declaration.tex` in the `Frontmatter` folder: tex files for the front matter part of the thesis
- `C-Intro/intro.tex` and `C-Begin/beg.tex`: examples of subfiles containing main content
- `Appendices/appendix.tex`: example of a subfile containing an appendix
- `C-Bare/bare.tex`: a tex file that you should copy and rename every time you want to create a new subfile
- `Bibfiles/firstbib.bib`: a basic bib file to show integration with the `biblatex` package; we recommend against modifying this file manually, but by using an adapted software like Jabref instead
- `Figures/xkcd1991.png`: figure for use as an example with `\includegraphics`
</details>

### Getting started

If you are used to git, use `git clone` on this repository to download the full content.
Otherwise, you can download the latest code as a zip file by clicking on the `Code` button.

In your favourite software, compile the `Thesis.tex` file to verify that your installation is up to date before modifying anything. 
You can now start creating your own chapters by copying and renaming the `bare.tex` file, before including the subfile created into the `Thesis.tex` file at the corresponding place.  
_**Notice:**_ unless you use `latexmk`, you may need to change some settings in order to call `biber` instead of `bibtex` to work with `biblatex`.

### Note on overleaf
If you want to use [Overleaf](overleaf.com) and care about cross-referencing working in your subfiles, you will need to do some additional modifications after uploading the files there:
1. uncomment line 50-62 in `preamble.tex`
1. create the `latexmkrc` file according to the official [overleaf's documentation](https://www.overleaf.com/learn/how-to/Cross_referencing_with_the_xr_package_in_Overleaf#Creating_the_latexmkrc_file)
1. in each subfile where you need cross-referencing, uncomment the line:
```latex
\myexternaldocument{<file_name>}
```

## What if I have questions on the template?

First off, make sure you have read all the documentation and the comments present in the code of the different files.
If your question is not directly related to how the template works, you are more likely to get a timely (and good) answer by asking it on [stack exchange](tex.stackexchange.com).
Otherwise, you can go to the [Issues tab](https://github.com/PDLT-University-of-York/UoYPhDThesis/issues) to see if someone else has had a similar question or to post yours instead and we will try to answer as quickly as possible.

## I would like to use the template, but my department requires something specific that is not implemented
Some departments have specific requirements (for example with regards to citation) and it is usually possible to tweak the default behaviour to suit the purpose.
You could initially ask them for help by linking to this repository and asking them if they could provide some tex code to make the corresponding change or to discuss it further with the maintainers.
After that, you could also request this to be added as a feature by creating a new issue, and depending on how complicated this would be, we will see if we can accomodate for it.

## Can I contribute to the project?
Yes of course! The goal of this template is to evolve with time in order to stay up to date with the LaTeX distribution.
We will gladly welcome help from anyone, be it by answering other users' questions to close issues, correcting typos, reviewing and providing code, or by researching the latest news on the LaTeX community regarding accessibility.

## Future improvements
Expected additions to the current project:
- [ ] Write/improve the documentation
- [ ] Set up a wiki, and discussions
- [ ] Automate the compilation using Github Actions for PRs
- [ ] Link this with an overleaf project to allow copying it directly
- [ ] Set up a webpage running `latexdiff` to help for submission of corrections