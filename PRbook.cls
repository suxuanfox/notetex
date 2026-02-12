% Copyright 2021  李文威 (Wen-Wei Li).
% Permission is granted to copy, distribute and/or modify this
% document under the terms of the Creative Commons
% Attribution 4.0 International (CC BY 4.0)
% http://creativecommons.org/licenses/by/4.0/

% We make use of etoolbox. The package ntheorem is implicitly required.
% It will also import the files titles-setup.tex (for titles of sections) and font-setup-open.tex/font-setup-HEP.tex (for fonts).

% Identification
% --------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{PRbook}[2021/03/04 Class for the book project Methods of Algebra]

% 使用 key-val 格式指定选项之用, 一切以 @PR 起始.
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}

\SetupKeyvalOptions{
	family = @PR,
	prefix = @PR@
}

% Declaration of options
% ----------------------
\DeclareBoolOption[false]{draftmark}	% 是否打上未定稿标记
\DeclareBoolOption[true]{colors}	% 是否让链接带颜色
\DeclareBoolOption[true]{CJKthechapter}	% 是否让天眉的各章编号使用中文数字
\DeclareBoolOption[false]{traditional}	% 是否使用繁体中文
\DeclareBoolOption[false]{index}   % 是否生成索引

\DeclareStringOption[]{coverpage}	% 封面档档名, 默认为空
\DeclareStringOption[b5]{geometry}	% 版面 (默认 b5)

\PassOptionsToPackage{dvipsnames}{xcolor}	% 让 xcolor 带 dvipsnames 选项; tikz 随后会载入之.


% Execution of options
% ---------------------
\ProcessKeyvalOptions*
\relax

% Package loading
% ---------------------
% 基于 book class, 选项一并载入.
\LoadClass[10pt]{book}

\RequirePackage{fontspec}				% XeLaTeX
\RequirePackage[CJKchecksingle]{xeCJK}	% XeCJK
\RequirePackage{zhnumber}				% 中文数字转换

% 引入 AMS 宏包 + mathtools
\RequirePackage[intlimits]{amsmath}
\RequirePackage{amssymb}
\RequirePackage[centercolon]{mathtools}

% 支持直接引入 PDF 页面
\RequirePackage{pdfpages}

% 加入字串处理功能
\RequirePackage{xstring}

\RequirePackage{emptypage}
\RequirePackage[many]{tcolorbox}		% 制作方框

\RequirePackage{zhlineskip}	% 设定适于中文排版的行距

% 使用 biblatex + biber 制作书目
\RequirePackage[
	backend=biber,
	sorting=nyt,
	hyperref=auto,
	backref=true,
	backrefstyle=three]
	{biblatex}

% 要求载入 TikZ
\RequirePackage{tikz}

% 载入 paralist, 要求标签向右对齐.
\RequirePackage[neveradjust, neverdecrease]{paralist}

\if@PR@index
    \RequirePackage[xindy]{imakeidx}

    % 名词索引
    \makeindex[
        columns=2,
        program=truexindy,
        intoc=true,
        options=-M texindy -I xelatex -C utf8 -L english,
        title={名词索引暨英译}
    ]

    % 符号索引
    \makeindex[
        columns=3,
        program=truexindy,
        intoc=true,
        options=-M numeric-sort -M latex -M latex-loc-fmts -M makeindex -I xelatex -C utf8 -L english,
        name=sym,
        title={符号索引}
    ]
\fi

%内嵌字体

% 设置西文无衬线字体 
\setsansfont{TeX Gyre Heros}

% ========== 中文字体设置 ==========

% ========== 中文字体设置 ==========
\usepackage{xeCJK}

\setCJKsansfont[
    BoldFont=Source Han Sans SC Bold
]{Source Han Sans SC}

% 宋体（正文）
\setCJKmainfont[
    BoldFont=Source Han Serif SC Bold
]{Source Han Serif SC}

% 黑体
\setCJKfamilyfont{hei}[
    BoldFont=Source Han Sans SC Bold
]{Source Han Sans SC}

% 定理标题黑体（不自动加粗）
\setCJKfamilyfont{hei2}{Source Han Sans SC}

% 仿宋（系统字体）
\setCJKfamilyfont{fangsong}[
    BoldFont=SimSun,
    ItalicFont=KaiTi
]{FangSong}

% 楷体（系统字体）
\setCJKfamilyfont{kai}{KaiTi}
\setCJKfamilyfont{song}{Source Han Serif SC}
\setCJKmonofont{Source Han Mono SC}
% section标题字体
\setCJKfamilyfont{sectionfont}[
    BoldFont=Source Han Sans SC Bold
]{Source Han Sans SC}

% proof环境字体
\setCJKfamilyfont{pffont}[
    BoldFont=Source Han Sans SC Bold
]{Source Han Sans SC}

% 强调字体
\setCJKfamilyfont{emfont}[
    BoldFont=Source Han Sans SC Bold
]{Source Han Sans SC}

\defaultfontfeatures{Ligatures=TeX}

% ========== 字体命令 ==========
\newcommand\kaishu{\CJKfamily{kai}}
\newcommand\songti{\CJKfamily{song}}
\newcommand\heiti{\CJKfamily{hei}}
\newcommand\thmheiti{\CJKfamily{hei2}}
\newcommand\fangsong{\CJKfamily{fangsong}}

% 强调命令
\renewcommand{\em}{\bfseries\mathversion{bold}\CJKfamily{emfont}}

%标题设置
\RequirePackage[calcwidth, nobottomtitles, explicit, newparttoc, indentafter]{titlesec}      % 标题格式: explicit 选项导致须在 titleformat 的 before-code 中加 #1. 选项 newparttoc 用来将各部分加入目录. indentafter: 首行一律缩进
\RequirePackage{titletoc}                 % 目录格式

% 目录部分: 章名除附录外仍用中文标号, 黑体显示. 以参数是否为大写拉丁字母来判定是否在附录 (烂招)
\if@PR@traditional
	\providecommand{\PRchapterttl}[1]{\IfSubStr{ABCDEFGHIJKLMNOPQRSTUVWXYZ}{#1}{附錄 #1	}{第\zhnumber{#1}章}}
\else
	\providecommand{\PRchapterttl}[1]{\IfSubStr{ABCDEFGHIJKLMNOPQRSTUVWXYZ}{#1}{附录 #1	}{第\zhnumber{#1}章}}
\fi

\newlength{\BoxTtlwidth}	% 用来计算各种盒子所需宽度

% 各章标题排版: \MakeChapBox{编号}{标题}, 除附录外, 各章用中文数字显示. 以参数是否为大写拉丁字母来判定是否在附录 (烂招)
\newcommand{\MakeChapBox}[2]{%
	\settowidth{\BoxTtlwidth}{\PRchapterttl{#1}} % 计算宽度
	\begin{tcolorbox}[ % 设置 tcolorbox
		enhanced jigsaw,
		skin = bicolor,
		frame engine = path,
		sharp corners = all,
		width = 0.9\textwidth,
		top = 4mm, bottom = 4mm,
		sidebyside,
		frame hidden,
		boxrule = 0mm,
		lefthand width = \BoxTtlwidth,
		colupper = white,
		colback = gray!80,
		colbacklower = gray!10,
		sidebyside align=center,
		halign=center]
		\PRchapterttl{#1}
		\tcblower
		#2
	\end{tcolorbox}%
}

% 无编号标题排版: \MakeChapBox{标题}
\newcommand{\MakeChapBoxSingle}[1]{%
	\begin{tcolorbox}[
		enhanced,
		width = 0.7\textwidth,
		sharp corners = all,
		top = 4mm, bottom = 4mm,
		frame hidden,
		boxrule = 0mm,
		colback = gray!10,
		halign=center]
		#1
	\end{tcolorbox}
}

% 各节标题排版: \MakeSectBox{文字}, 问题: 不允许断行
\newtcbox{\MakeSectBox}{
	enhanced,
	arc = 0pt, outer arc = 0pt,
	before skip = 0pt, after skip = 0.4em, left skip = 0pt, right skip = 0pt,
	top = 0pt, left = 0pt, right = 0pt, bottom = 1.5mm,
	sharp corners = all,
	valign=bottom,
	colback = white,
	colframe = white,
	boxsep = 0pt, leftrule = 0pt, rightrule=0pt, toprule=0pt, bottomrule = 0pt,
	overlay = { \draw[line width=1pt] (interior.south west) -- (interior.south east); }
}

% 用 titlesec 设置各章标题
\titleformat{name=\chapter}
	{\filright\sffamily\CJKfamily{hei2}\bfseries\mathversion{bold}\Huge}	% Format
	{}	% Label
	{0mm}	% Sep
	{\MakeChapBox{\thechapter}{#1}}	% Before-code
	[]	% After-code
\titlespacing*{name=\chapter}	% 设置间隔
	{1pc}{*4}{1em}	% {left}{before-sep}{after-sep}

\titleformat{name=\chapter, numberless}
	{\filcenter\sffamily\CJKfamily{hei2}\bfseries\mathversion{bold}\Huge}	% Format
	{}	% Label
	{0mm}	% Sep
	{\MakeChapBoxSingle{#1}}	% Before-code
	[{\if@mainmatter
		\addcontentsline{toc}{chapter}{#1}
		\markboth{#1}{}
	\fi}]	% After-code: 无号章如果出现在正文中, 就加入目录并相应地设置天眉.
\titlespacing*{name=\chapter, numberless}	% 设置间隔
	{1pc}{*4}{1em}	% {left}{before-sep}{after-sep}

\titleformat{name=\section} % 各节标题
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{}
	{0mm}
	{ \settowidth{\BoxTtlwidth}{\Huge \thesection \hspace{0.7em} \Large #1}  % 首先计算宽度
		\ifdim \BoxTtlwidth < \textwidth % 一般情形下调用 \MakeSectBox
			\MakeSectBox{\Huge \thesection \hspace{0.7em} \Large #1}\vskip-18pt%
		\else % 万一标题过长则不用 \MakeSectBox (烂招)
			\Huge \underline{\thesection} \hspace{0.7em} \Large #1%
		\fi %
	}
	[]

\titleformat{name=\section, numberless}	% 各节标题: 无编号情形
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{}
	{0mm}
	{ \settowidth{\BoxTtlwidth}{\Large #1}  % 首先计算宽度
		\ifdim \BoxTtlwidth < \textwidth % 一般情形下调用 \MakeSectBox
			\MakeSectBox{\Large #1}\vskip-18pt%
		\else % 万一标题过长则不用 \MakeSectBox (烂招)
			\Large #1 %
		\fi %
	}
	[]
	
\titlespacing*{name=\section}	% 设置间隔
	{1pc}{*1.3}{*1}    % {left}{before-sep}{after-sep}

\titleformat{name=\subsection} % 各子节标题, 采取 runin 形式较美观
	[runin]
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{\Large\thesubsection}	% Label
	{3mm}	% Sep
	{#1}	% Before-code
	[]		% After-code

\titleformat{name=\subsection, numberless}
	[runin]
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{}	% Label
	{0mm}	% Sep
	{#1}	% Before-code
	[]		% After-code
\titlespacing*{name=\subsection}	% 设置间隔
	{0pt}{*1}{1em}    % {left}{before-sep}{after-sep}

\titleformat{name=\subsubsection} % 次子节标题, 采取 runin 形式较美观
	[runin]
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{\thesubsubsection}	% Label
	{3mm}	% Sep
	{#1}	% Before-code
	[]		% After-code
	
\titleformat{name=\subsubsection, numberless}
	[runin]
	{\filleft\normalfont\sffamily\bfseries\mathversion{bold}\CJKfamily{sectionfont}}
	{}	% Label
	{0mm}	% Sep
	{#1}	% Before-code
	[]		% After-code

\titlespacing*{name=\subsubsection}	% 设置间隔
	{0pt}{*1}{1em}    % {left}{before-sep}{after-sep}

% 部分编号汉化
\renewcommand{\thepart}{\zhnum{part}}
\titleformat{name=\part}[display]	% 各部分标题
	{\filcenter\sffamily\bfseries\mathversion{bold}\CJKfamily{song}\Huge}	% Format
	{第{\thepart}部分}	% Label
	{1.5em}	% Sep
	{#1}	% Before-code
	[]	% After-code

\titleformat{name=\part, numberless}[display]	% 各部分标题
	{\filcenter\sffamily\bfseries\mathversion{bold}\CJKfamily{song}\Huge}	% Format
	{}	% Label
	{1.5em}	% Sep
	{#1}	% Before-code
	[]	% After-code

\titlecontents{chapter}
	[0pt]
	{\addvspace{1pc}\heiti}
	{\contentsmargin{0pt}\large\PRchapterttl{\thecontentslabel} \quad}
	{\contentsmargin{0pt}\large}
	{\titlerule*[.7pc]{.}\contentspage}

\titlecontents{section}
	[1.5em]
	{}
	{\thecontentslabel\quad}
	{\thecontentslabel}
	{\titlerule*[.7pc]{.}\contentspage}

\titlecontents{subsection}
	[3.9em]
	{\small}
	{\thecontentslabel\quad}
	{\ (\thecontentspage)}
	{\titlerule*[.7pc]{.}\contentspage}

\titlecontents{part}
	[0cm]
	{\addvspace{1pc}\fangsong}
	{\contentsmargin{0pt}\large{第{\thecontentslabel}部分}\quad}
	{\Large}
	{}




% Main codes
% ----------

\usetikzlibrary{shapes.symbols}	% 稍后定义 hint 环境所需

% 定义在 draftmark=true 模式下显示版本信息的指令
\RequirePackage[iso, english]{isodate}  % 使 \today 印出 yyyy-mm-dd
\providecommand{\@PR@draftstring}{{\color{gray!40}\heiti 未定稿: \today}}

\setlength{\parindent}{2em}	% 设置适合于汉语排版的段落缩进

% 扩展 \frontmatter: 制作封面和目录
\g@addto@macro\frontmatter{
	% 当 coverpage 参数非空时, 引入封面档制作封面, 否则 \relax.
	\ifdefempty{\@PR@coverpage}{%
		\relax
	}{%
		\pagestyle{empty}%	清空页面风格
		\renewcommand{\thepage}{C\arabic{page}}%	封面部分页码以 C 开头 (PDF: logical page numbers)
		\IfEndWith{\@PR@coverpage}{.pdf}{% 如果档名以 .pdf 或 .PDF 结尾则引入 PDF
			\includepdf{\@PR@coverpage}
		}{%
			\IfEndWith{\@PR@coverpage}{.PDF}{%
				\includepdf{\@PR@coverpage}
			}{%
				\input{\@PR@coverpage}		% 否则引入 .tex 源代码
			}
		}%
		\pagestyle{fancy}		% 复原页面风格为 fancy
		\pagenumbering{roman}	% 页码复原为小写罗马字母
	}

	% 重设页数: 封面页结束时应已经 \cleardoublepage
	\setcounter{page}{1}
	\thispagestyle{empty}
	\addtocontents{toc}{\protect\thispagestyle{empty}}

	% 重置目录标题
	\if@PR@traditional
		\renewcommand{\contentsname}{目錄}
	\else
		\renewcommand{\contentsname}{目录}
	\fi

	\tableofcontents	% 印出目录
}

% 扩张 \appendix: 重置天眉
\g@addto@macro\appendix{
	% 为附录重置天眉格式
	\if@PR@traditional
		\renewcommand{\appendixname}{附錄}
		\renewcommand{\chaptermark}[1]{\markboth{附錄 \thechapter \quad #1}{}}
	\else
		\renewcommand{\appendixname}{附录}
		\renewcommand{\chaptermark}[1]{\markboth{附录 \thechapter \quad #1}{}}
	\fi
	\renewcommand{\sectionmark}[1]{\markright{\S\thesection \quad #1}}
}

% 扩展 \backmatter: 设置文献显示方式. 注意: 若有附录则须重置天眉格式
\g@addto@macro\backmatter{
	\renewcommand{\em}{\itshape} % 书目部分以斜体表示强调
	% 汉化参考文献标题
	\if@PR@traditional
		\renewcommand{\refname}{參考文獻}
		\renewcommand{\bibname}{參考文獻}
	\else
		\renewcommand{\refname}{参考文献}
		\renewcommand{\bibname}{参考文献}
	\fi
}

% 以下设置 biblatex.
% bibLaTeX 部分第一步: 基本设置与汉化.
\DeclareFieldFormat{postnote}{#1}	% 功能是印出 \cite[postnote]{Book}
\if@PR@traditional
	\DefineBibliographyStrings{english}{%
		in = {刊於},
		editor = {主編},
		byeditor = {編者為},
		backrefpage = {引用於 p.\!},
		backrefpages = {引用於 pp.\!},
	}
	\else
		\DefineBibliographyStrings{english}{%
			in = {刊于},
			editor = {主编},
			byeditor = {编者为},
			backrefpage = {引用于 p.\!},
			backrefpages = {引用于 pp.\!},
	}
\fi
% biblatex 部分第二步: 要求在 doi 和 URL 并存时移除 URL. 仅适用于 Biblatex + Biber. 源码取自 https://tex.stackexchange.com/questions/119136/biblatex-convert-doi-url-into-doi-field  原文如下.
% The actual value inside \regexp can be adjusted.
% In the first step we create a doi field for each entry where the url field matches the regexp, and the novel field has the value of the url field. In the second step we remove the doi "namespace".
% In the second \map sequence the url and urldate fields are cleared if a doi field is present, to mimic the behavior in the first part of the original question. 
\DeclareSourcemap{
	\maps[datatype=bibtex]{
		\map{
			\step[ % copies url to doi field if it starts with http://dx.doi.org/
			fieldsource=url,
			match=\regexp{http://dx.doi.org/(.+)},
			fieldtarget=doi,
			]
			\step[ % removes http://dx.doi.org/ string from doi field
			fieldsource=doi,
			match=\regexp{http://dx.doi.org/(.+)},
			replace=\regexp{$1}
			]
		}
		\map{ % removes url + urldate field from all entries that have a doi field
			\step[fieldsource=doi, final]
			\step[fieldset=url, null]
			\step[fieldset=urldate, null]
		}
	}
}

% 脚注格式定制
\renewcommand{\thefootnote}{\arabic{footnote})}

% 汉化 figure 和 table 环境
\if@PR@traditional
	\renewcommand{\figurename}{圖}
	\renewcommand{\tablename}{表}
\else
	\renewcommand{\figurename}{图}
	\renewcommand{\tablename}{表}
\fi

% 汉化 figure 和 table 索引
\if@PR@traditional
	\renewcommand{\listfigurename}{圖片索引}
	\renewcommand{\listtablename}{表格索引}
\else
	\renewcommand{\listfigurename}{图片索引}
	\renewcommand{\listtablename}{表格索引}
\fi

% 将 figure 和 table 索引加入目录: 使用 etoolbox 提供的 patching
\pretocmd{\listoffigures}{%
	\cleardoublepage
	\phantomsection
	\addcontentsline{toc}{chapter}{\listfigurename}
}{}{}
\pretocmd{\listoftables}{%
	\cleardoublepage
	\phantomsection
	\addcontentsline{toc}{chapter}{\listtablename}
}{}{}


% 设置习题环境, 置于每章最后: 不用 \section* 以免格式混淆
\if@PR@traditional
	\newenvironment{Exercises}{%
		\markright{習題}
		\addcontentsline{toc}{section}{習題}
		\vspace{1em}\begin{center}
			\Large\CJKfamily{sectionfont} 習題
		\end{center}\vspace{0.7em}
		\begin{small}\begin{enumerate}[\bfseries 1.] %
			}{	% 结束
		\end{enumerate}\end{small}
	}
\else
	\newenvironment{Exercises}{%
		\markright{习题}
		\addcontentsline{toc}{section}{习题}
		\vspace{1em}\begin{center}
			\Large\CJKfamily{sectionfont} 习题
		\end{center}\vspace{0.7em}
		\begin{small}\begin{enumerate}[\bfseries 1.] %
			}{	% 结束
		\end{enumerate}\end{small}
	}
\fi

% 习题提示 (定义为环境, 穿插文中)
\newenvironment{hint}{%
	\ifvmode % 用 \ifvmode 测试: 如果提示另起新段, 则不加空白.
		\ignorespaces	% 消除横向空白, 优于 \unskip
	\else
		\quad	% 否则加入空白.
	\fi
	\begin{tikzpicture}[baseline=(H.base), every node/.style={signal, draw, very thin, signal to=east, signal from=nowhere, signal pointer angle=120, inner sep=2pt}]
		\node[anchor=mid west] (H) at (0,0) {\heiti\footnotesize 提示};
	\end{tikzpicture}
}{}

% 每章开头的学习提示 (定义为环境)
\if@PR@traditional
	\newtcolorbox{tips}{
		breakable,
		enhanced,
		width = \textwidth,
		colback = white, colbacktitle = white,
		colframe = gray!50, boxrule=0.2mm,
		coltitle = black,
		fonttitle = \sffamily,
		attach boxed title to top left = {yshift=-\tcboxedtitleheight/2,  xshift=\tcboxedtitlewidth/4},
		boxed title style = {boxrule=0pt, colframe=white},
		before skip = 0.5cm,
		top = 3mm,
		bottom = 3mm,
		title={閱讀提示}
	}
\else
	\newtcolorbox{tips}{
		breakable,
		enhanced,
		width = \textwidth,
		colback = white, colbacktitle = white,
		colframe = gray!50, boxrule=0.2mm,
		coltitle = black,
		fonttitle = \sffamily,
		attach boxed title to top left = {yshift=-\tcboxedtitleheight/2,  xshift=\tcboxedtitlewidth/4},
		boxed title style = {boxrule=0pt, colframe=white},
		before skip = 0.5cm,
		top = 3mm,
		bottom = 3mm,
		title={阅读提示}
	}
\fi

\AtEndPreamble{
	\RequirePackage[thmmarks, amsmath, hyperref]{ntheorem}	% 设置定理环境所需
	
	% 若 hyperref 已载入, 则按 colors 的 Bool 值设置链接色彩.
	\@ifpackageloaded{hyperref}{
		\if@PR@colors
			\hypersetup{
			colorlinks = true,
			linkcolor = blue,
			citecolor = violet,
			urlcolor = teal}
		\else
			\hypersetup{hidelinks}
		\fi}
	{}
	
	% 设置页面尺寸
	\RequirePackage{geometry}
	\IfStrEq{\@PR@geometry}{b5}{% 载入 b5 版面设置
	\geometry{
		paper=b5paper,
		headheight=5ex,
		headsep=5ex,
		textwidth=132mm,
		textheight=198mm,
		twoside,
		% bindingoffset=18pt,
		asymmetric	% 单双数页不分
	}}{}

	\IfStrEq{\@PR@geometry}{a4}{% 载入 a4 版面设置
	\geometry{
		paper=a4paper,
		top=3cm,
		inner=2.54cm,
		outer=2.54cm,
		bottom=3cm,
		headheight=6ex,
		headsep=6ex,
		twoside,
		asymmetric
	}}{}

	% 设置天眉所需
	\RequirePackage{fancyhdr}
	% 使空页恒空
	\fancypagestyle{plain}{
		\fancyhead{}
		\renewcommand{\headrulewidth}{0pt}
	}
	
	% 设置天眉
	\pagestyle{fancy}
	\if@PR@CJKthechapter
		\renewcommand{\chaptermark}[1]{\markboth{
			第\zhnumber{\thechapter}章\quad #1
			}{}}
	\else
		\renewcommand{\chaptermark}[1]{\markboth{
			第 \thechapter 章\quad #1
			}{}}
	\fi
	\renewcommand{\sectionmark}[1]{\markright{\S\arabic{chapter}.\arabic{section} \quad #1}}
	\fancyhf{} % 先清空
	\fancyhead[EC]{\CJKfamily{hei2}\footnotesize{\leftmark}\vspace{1mm}}
	\fancyhead[OC]{\CJKfamily{hei2}\footnotesize{\rightmark}\vspace{1mm}}
	\fancyhead[LE,RO]{{\footnotesize \thepage}\vspace{1mm}} %
	\fancyhead[RE,LO]{}
	\if@PR@draftmark
		\fancyfoot[C]{\@PR@draftstring} % 在 draftmark=true 时打印版本信息
	\fi
	\renewcommand{\headrulewidth}{0pt}	% 天眉暂不加横线
	\renewcommand{\footrulewidth}{0pt}
	\addtolength{\headheight}{0.5pt}
}

\AtBeginDocument{
	% 重置 \Re, \Im, \emptyset. 由于可能用到 unicode-math, 这必须在 \begin{document} 后进行.
	\renewcommand{\Re}{\operatorname{Re}}
	\renewcommand{\Im}{\operatorname{Im}}
	\renewcommand{\emptyset}{\ensuremath{\varnothing}}
	
	\newcommand{\openbox}{\leavevmode	% 复制 amsthm 的 QED 符号: 空心方格
	\hbox to.77778em{%
		\hfil\vrule
		\vbox to.675em{\hrule width.6em\vfil\hrule}%
		\vrule\hfil}}
		
	\theorembodyfont{\fangsong}	% 以下用 ntheorem 定义定理等环境
	\theoremheaderfont{\sffamily\bfseries\thmheiti}	% 须与 \setsansfont 选择的字体兼容
	\theoremseparator{\ }
	\setlength{\theorempreskipamount}{2mm}
	\setlength{\theorempostskipamount}{2mm}
	
	\if@PR@traditional
		\newtheorem{theorem}{定理}[section] % 按section编号
		\newtheorem{corollary}[theorem]{推論}
		\newtheorem{lemma}[theorem]{引理}
		\newtheorem{proposition}[theorem]{命題}
		\newtheorem{definition}[theorem]{定義}
		\newtheorem{definition-theorem}[theorem]{定義--定理}
		\newtheorem{definition-proposition}[theorem]{定義--命題}
		\newtheorem{hypothesis}[theorem]{假設}
		\newtheorem{conjecture}[theorem]{猜想}

		\theorembodyfont{\songti}
		\newtheorem{example}[theorem]{例}
		\newtheorem{remark}[theorem]{注記}
		\newtheorem{convention}[theorem]{約定}
		\newtheorem{exercise}[theorem]{練習}		% 穿插于文中的习题

		\theorembodyfont{}
		\theoremstyle{nonumberplain}
		\theoremheaderfont{\sffamily\bfseries\CJKfamily{pffont}}
		\theoremseparator{\enspace}
		\theoremsymbol{\openbox} % 模拟标准的 Proof 环境
		\newtheorem{proof}{證明}
	\else
		\newtheorem{theorem}{定理}[section] % 按section编号
		\newtheorem{corollary}[theorem]{推论}
		\newtheorem{lemma}[theorem]{引理}
		\newtheorem{proposition}[theorem]{命题}
		\newtheorem{definition}[theorem]{定义}
		\newtheorem{definition-theorem}[theorem]{定义--定理}
		\newtheorem{definition-proposition}[theorem]{定义--命题}
		\newtheorem{hypothesis}[theorem]{假设}
		\newtheorem{conjecture}[theorem]{猜想}

		\theorembodyfont{\songti}
		\newtheorem{example}[theorem]{例}
		\newtheorem{remark}[theorem]{注记}
		\newtheorem{convention}[theorem]{约定}
		\newtheorem{exercise}[theorem]{练习}		% 穿插于文中的习题

		\theorembodyfont{}
		\theoremstyle{nonumberplain}
		\theoremheaderfont{\sffamily\bfseries\CJKfamily{pffont}}
		\theoremseparator{\enspace}
		\theoremsymbol{\openbox} % 模拟标准的 Proof 环境
		\newtheorem{proof}{证明}
	\fi
}

% Print index at end
% =============================
\AtEndDocument{
    \if@PR@index
        {\footnotesize\printindex[sym]}
        {\footnotesize\printindex}
    \fi
}
