%% uoythesis.cls
%% Copyright 2023 A. Grau
%
% This work may be distributed and/or modified under the conditions of the LaTeX
% Project Public License, either version 1.3 of this license or (at your option)
% any later version, with the exception that distribution of Derived Work is not
% subject to the requirements of section 6.2.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.
%
%
% This work has the LPPL maintenance status `maintained`.
%
% The Current Maintainer of this work is A. Grau.
%
% This work consists of all the files listed in the README.md,
% and provides a copy of the original hosted on
% https://github.com/PDLT-University-of-York/UoYPhDThesis.

%% NOTE:
% Comments starting with `FORMAT` highlight requirements from the 
% University of York thesis regulations, as of December 2023.
% See https://www.york.ac.uk/research/graduate-school/academic/thesis/format/#tab-2

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uoythesis}[2023/12/23 v1.0 University of York Thesis]

\providecommand{\is@uoyth@classloaded}{true}
\RequirePackage{xkeyval}
\RequirePackage{etoolbox}
\RequirePackage{xstring}


%%% Set Class options
% helper functions
\newcommand{\uoyth@tmp@classoptionslist}{}
\newcommand{\AddToClassOptionList}[1]{\csappto{uoyth@tmp@classoptionslist}{, #1}}
\newcommand{\RaiseBooleanValueWarning}[1]{
  \ClassError{uoythesis}{The option {#1} must be set with either true or false}{Option #1 only accepts a boolean value}
}
\newcommand{\RaiseFontSizeValueWarning}[1]{
  \ClassWarning{uoythesis}{You gave size '#1' which is too small according to the guidelines. Automatically changing to the smallest value accepted: 11pt. (Classoptions:\@classoptionslist )}
}
\newcommand{\uoyth@fontsize}{12pt}
\newcommand{\uoyth@SetFontSize}[1]{
  \AddToClassOptionList{#1}
  \renewcommand{\uoyth@fontsize}{#1}
  \PassOptionsToClass{#1}{memoir}
}
    
% options passed onto memoir: draft, final, oneside, twoside
\newif\ifuoyth@draft
  \uoyth@draftfalse
\DeclareOptionX{draft}{\uoyth@drafttrue \PassOptionsToClass{draft}{memoir}}
\DeclareOptionX{final}{\uoyth@draftfalse \PassOptionsToClass{final}{memoir}}
\newif\ifuoyth@onesided
  \uoyth@onesidedfalse
\DeclareOptionX{oneside}{\uoyth@onesidedtrue \PassOptionsToClass{oneside}{memoir}}
\DeclareOptionX{twoside}{\uoyth@onesidedfalse \PassOptionsToClass{twoside}{memoir}}

% new global options: noxr, nohyperref, hyperfinal, hyperoptions
\define@boolkey+{uoythesis.cls}[uoyth@]{noxr}[true]{}{\RaiseBooleanValueWarning{noxr}}
\ExecuteOptionsX{noxr=false}
\define@boolkey+{uoythesis.cls}[uoyth@]{nohyperref}[true]{}{\RaiseBooleanValueWarning{nohyperref}}
\ExecuteOptionsX{nohyperref=false}
\define@boolkey+{uoythesis.cls}[uoyth@]{hyperfinal}[true]{}{\RaiseBooleanValueWarning{hyperfinal}}
\ExecuteOptionsX{hyperfinal}
\DeclareOptionX{hyperoptions}{
  \ClassInfo{uoythesis}{Passing options '#1' to package hyperref}
  \PassOptionsToPackage{#1}{hyperref}
}
\ExecuteOptionsX{hyperoptions={pdfversion=2.0}}

% new local options: page number placement and margins
\newif\ifuoyth@pgnbhead
  \uoyth@pgnbheadtrue
\define@choicekey*+{uoythesis.cls}{pagenb}[\userval\choiceval]{head,foot}[head]{
  \ifcase\choiceval\relax
  	  \uoyth@pgnbheadtrue
  \or
  	  \uoyth@pgnbheadfalse
  \fi
 }{
  \ClassWarning{uoythesis}{The \texttt{pagenb} option must be set to either `head' or `foot', but you gave `#1'}
}
\ExecuteOptionsX{pagenb=head}

\newif\ifuoyth@spineisdef
\newif\ifuoyth@foredgeisdef
\newif\ifuoyth@hratioisdef
\newif\ifuoyth@topisdef
\newif\ifuoyth@bottomisdef
\newif\ifuoyth@vratioisdef
\define@cmdkey{uoythesis.cls}[uoyth@]{spine}{\uoyth@spineisdeftrue}
\define@cmdkey{uoythesis.cls}[uoyth@]{foredge}{\uoyth@foredgeisdeftrue}
\define@cmdkey{uoythesis.cls}[uoyth@]{hratio}{\uoyth@hratioisdeftrue}
\define@cmdkey{uoythesis.cls}[uoyth@]{top}{\uoyth@topisdeftrue}
\define@cmdkey{uoythesis.cls}[uoyth@]{bottom}{\uoyth@bottomisdeftrue}
\define@cmdkey{uoythesis.cls}[uoyth@]{vratio}{\uoyth@vratioisdeftrue}
\define@key{uoythesis.cls}{hmargins}{\setkeys{uoythesis.cls}{spine=#1, foredge=#1}}
\define@key{uoythesis.cls}{vmargins}{\setkeys{uoythesis.cls}{top=#1, bottom=#1}}
\define@cmdkey{uoythesis.cls}[uoyth@]{margins}{\setkeys{uoythesis.cls}{#1}}

% Pass all remaining unknown options to memoir to deal with them
% FORMAT: Font size must be at least 11pt, so we disable small values
\DeclareOptionX*{%
  \IfEndWith{\CurrentOption}{pt}{ % this is possibly a font size
    \StrGobbleRight{\CurrentOption}{2}[\val]
    \IfInteger{\val}{ % as a font size verifies if at least 11
      \ifnum\val<12 % if too small, set to 11 and raise warning
        \RaiseFontSizeValueWarning{\CurrentOption}
        \uoyth@SetFontSize{11pt}
      \else
        \uoyth@SetFontSize{\CurrentOption}
      \fi
    }{
      \PassOptionsToClass{\CurrentOption}{memoir}
    }
  }{
    \PassOptionsToClass{\CurrentOption}{memoir}
  }
}

% Memoir has a problem with size 13pt, and uses its default size when
% uncountered instead, which is 10pt; so we force 12pt in this case
\DeclareOptionX{13pt}{
  \ClassInfo{uoythesis}{Font size 13pt not available, downsizing to 12pt}
  \uoyth@SetFontSize{12pt}
}

% Process options to be passed down
\ProcessOptionsX
\ifuoyth@draft 
  \AddToClassOptionList{draft} 
  \else 
  \AddToClassOptionList{final} 
\fi
\ifuoyth@onesided
  \AddToClassOptionList{oneside} 
  \else 
  \AddToClassOptionList{twoside} 
\fi
\renewcommand{\@classoptionslist}{\uoyth@tmp@classoptionslist}

% FORMAT: Document must be on A4 paper and avoid blank pages when starting new chapters
\LoadClass[a4paper,openany,\uoyth@fontsize]{memoir}

%%% Finish setup using keys
% Load packages xr-hyper and hyperref unless deactivated by options
\ifuoyth@hyperfinal 
  \newcommand{\uoyth@hyperoptions}{final} 
\else
  \newcommand{\uoyth@hyperoptions}{}
\fi
\ifuoyth@noxr
  \ifuoyth@nohyperref
  \else
    \RequirePackage[\uoyth@hyperoptions]{hyperref}
  \fi
\else
  \ifuoyth@nohyperref
    \RequirePackage{xr}
  \else
    \RequirePackage{xr-hyper}
    \RequirePackage[\uoyth@hyperoptions]{hyperref}
  \fi
\fi
% Remove keys that can only be used in the documentclass options
\disable@keys{uoythesis.cls}{noxr,nohyperref,hyperfinal,hyperoptions,draft,final,oneside,twoside}

% Allow keys to be set at a later point
\newcommand{\uoythsetup}[1]{
  \setkeys{uoythesis.cls}{#1}
  \uoyth@preparelayout
  \uoyth@prepareheadandfoot
}

%%% Formatting options

% FORMAT: Use 1.5 line spacing.
\OnehalfSpacing

% FORMAT: GRS states as a recommendation that:
%         "spine margin should be at least 40mm,
%         other margins should be at least 15mm."
% In effect, their view is the following:
% "We would recommend that they stick with the guidance re. margin on binding edge merely because we still get examiners who prefer to make themselves a physical copy to mark up, rather than using the digital annotation."
% According to the book binder recommended by the university, they only need a 
% 2.5cm margin on the spine to make a binding.
% I have taken the stand to set the default value to 3cm on both sizes horizontally,
% while putting 4cm vertically. The implementation below prevents the use of setting
% the blocksize and then letting the margins be defined by a value relatively to that
% blocksize. If you want to use these instead, you need to delete the macros below.
% Helper functions to set the block layout of the page
% FORMAT: GRS states the following:
%         "Theses need to be presented in such a way that 
%         they can be easily read in electronic form and 
%         printed without issue"
% As a default, margins are set with 3cm each side horizontally,
% and 4cm vertically.
% DOC: Check memoir package sec2.4.2 p.17-21
\newcommand{\horizontalmarginsvalue}[2][]{
  \if\relax#1\relax
    \setkeys{uoythesis.cls}{hmargins=#2}
  \else
    \setkeys{uoythesis.cls}{spine=#2, foredge=#1}
  \fi
  \uoyth@preparelayout
}
\newcommand{\horizontalmarginsratio}[2][]{
  \if\relax#1\relax
    \setkeys{uoythesis.cls}{hratio=1, spine=#2}
  \else
    \setkeys{uoythesis.cls}{hratio=#1, spine=#2}
  \fi
  \uoyth@preparelayout
}
\newcommand{\verticalmarginsvalue}[2][]{
  \if\relax#1\relax
    \setkeys{uoythesis.cls}{vmargins=#2}
  \else
    \setkeys{uoythesis.cls}{bottom=#1, top=#2}
  \fi
  \uoyth@preparelayout
}
\newcommand{\verticalmarginsratio}[2][]{
  \if\relax#1\relax
    \setkeys{uoythesis.cls}{vratio=1, top=#2}
  \else
    \setkeys{uoythesis.cls}{vratio=#1, top=#2}
  \fi
  \uoyth@preparelayout
}

\newcommand{\uoyth@preparelayout}{
  % Set layout horizontally
  \ifuoyth@spineisdef
    \ifuoyth@foredgeisdef
      \setlrmarginsandblock{\uoyth@spine}{\uoyth@foredge}{*}
    \else
      \ifuoyth@hratioisdef
        \setlrmarginsandblock{\uoyth@spine}{*}{\uoyth@hratio}
      \else
        \setlrmarginsandblock{\uoyth@spine}{*}{*}
      \fi      
    \fi  
  \else
    \ifuoyth@foredgeisdef
      \ifuoyth@hratioisdef
        \setlrmarginsandblock{*}{\uoyth@foredge}{\uoyth@hratio}
      \else
        \setlrmarginsandblock{*}{\uoyth@foredge}{*}
      \fi
    \else
      \setlrmarginsandblock{3cm}{*}{1} % default with 3cm each side
    \fi    
  \fi
  
  % Set layout vertically
  \ifuoyth@topisdef
    \ifuoyth@bottomisdef
      \setulmarginsandblock{\uoyth@top}{\uoyth@bottom}{*}
    \else
      \ifuoyth@vratioisdef
        \setulmarginsandblock{\uoyth@top}{*}{\uoyth@vratio}
      \else
        \setulmarginsandblock{\uoyth@top}{*}{*}
      \fi      
    \fi  
  \else
    \ifuoyth@bottomisdef
      \ifuoyth@vratioisdef
        \setulmarginsandblock{*}{\uoyth@bottom}{\uoyth@vratio}
      \else
        \setulmarginsandblock{*}{\uoyth@bottom}{*}
      \fi
    \else
      \setulmarginsandblock{4cm}{*}{1} % default with 4cm top and bottom
    \fi    
  \fi
  
  % Apply the layout to respect the values set
  \checkandfixthelayout
}

% FORMAT: The font size of the headings should be smaller than the font size of
%         the main text. We use heading which works well for that.
% NOTE: Hyperref messes up the capitalisation of headings containing a reference
%       label, so we use small-caps headings as a workaround.
%       See https://tex.stackexchange.com/q/562773/27664
\nouppercaseheads
\copypagestyle{uoythheadings}{headings}
\pagestyle{uoythheadings}

\newcommand{\uoyth@prepareheadandfoot}{
  \def\pageinheader{\ifuoyth@pgnbhead \thepage \else \relax \fi}
  \ifuoyth@onesided % 
    \makeoddhead{uoythheadings}{\small\slshape\scshape\rightmark}{}{\pageinheader}
  \else % two-sided
    \makeevenhead{uoythheadings}{\pageinheader}{}{\small\slshape\scshape\leftmark}
    \makeoddhead{uoythheadings}{\small\slshape\scshape\rightmark}{}{\pageinheader}
  \fi
  
  \ifuoyth@pgnbhead  
  \else
    \makeevenfoot{uoythheadings}{}{\thepage}{}
    \makeoddfoot{uoythheadings}{}{\thepage}{}
  \fi
}

\uoyth@preparelayout
\uoyth@prepareheadandfoot

% FORMAT: Table of contents must include all document subdivisions.
%         Do not go below subsubsections.
\settocdepth{subsubsection}
\setsecnumdepth{subsubsection}


% FORMAT: A bibliography should contain every item consulted in writing the
%         thesis, while a list of references only contains the items explicitly
%         mentioned in the document.
\renewcommand{\bibname}{References}


%%% Title page
\newcommand{\department}[1]{\def\uoyth@department{#1}}
\newcommand{\qualification}[1]{\providecommand{\uoyth@qualification}{#1}}
\newcommand{\submitdate}[1]{\def\uoyth@submitdate{#1}}
\newcommand{\subtitle}[1]{\def\uoyth@subtitle{#1}}

% Empty submitdate defaults to the current month and year.
% Taken from the yorkThesis class by J H Pickering:
% https://www.york.ac.uk/language/current/resources/software-resources/latex/
\def\uoyth@submitdate{%
  \ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\year}

% This front was initially taken from A. Pezzoni's thesis template
% at https://github.com/donbex/yorkthesis
\newlength{\droplen}
\newcommand*{\makethesistitle}{\begingroup%
  % FORMAT: The title page should have number 1 (not visible),
  %         hence the starred version of `titlingpage`.
  \begin{titlingpage*}
    % Centre the title with respect to the physical page, not the typeblock
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength}{-\unitlength}
      \droplen=0.1\textheight
      \vspace*{\droplen}
      \centering
      {\Huge\slshape \@title\strut}
      \@ifundefined{uoyth@subtitle}{}{\\[\baselineskip]{\large\scshape\uoyth@subtitle}}  \\[2\baselineskip]
      {\Large \itshape \@author}\par
      \begin{vplace}[2]  % Split surrounding vertical space with a 2:1 ratio
        {\large \scshape \uoyth@qualification}\\[2\baselineskip]
        {\LARGE \scshape University of York}\\[.5\baselineskip]
        {\LARGE \scshape \uoyth@department}
      \end{vplace}
      {\large \uoyth@submitdate}\par
      \vspace*{\droplen}
    \end{adjustwidth*}
    % FORMAT: The abstract should be on page 2, so we prevent clearing to
    %         the next recto page.
    \titlingpageend{\clearforchapter}{\clearforchapter}
  \end{titlingpage*}
\endgroup}

\endinput