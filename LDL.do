*ssc install texdoc, replace
*net from http://www.stata-journal.com/production
*net install sjlatex

texdoc init LDL, replace logdir(log) gropts(optargs(width=0.8\textwidth))
set linesize 100

/***

\documentclass[11pt]{article}
\usepackage{fullpage}
\usepackage{siunitx}
\usepackage{hyperref,graphicx,booktabs,dcolumn}
\usepackage{stata}
\usepackage[x11names]{xcolor}
\usepackage{natbib}
\usepackage{chngcntr}
\usepackage{pgfplotstable}
\usepackage{pdflscape}

\usepackage{multirow}
\usepackage{booktabs}

\newcommand{\specialcell}[2][c]{%
  \begin{tabular}[#1]{@{}l@{}}#2\end{tabular}}
\newcommand{\specialcelll}[3][c]{%
  \begin{tabular}[#1]{@{}l@{}l@{}}#2\end{tabular}}
\newcommand{\specialcellll}[4][c]{%
  \begin{tabular}[#1]{@{}l@{}l@{}l@{}}#2\end{tabular}}
  
  
\newcommand{\thedate}{\today}

\counterwithin{figure}{section}
\counterwithin{table}{section}

\bibliographystyle{unsrt}

\begin{document}

\begin{titlepage}
    \begin{flushright}
        \Huge
        \textbf{Lipid-lowering strategies for primary prevention of coronary heart disease 
in the United Kingdom: A cost-effectiveness analysis}
\color{black}
\rule{16cm}{2mm} \\
\Large
\color{black}
Protocol \\
\thedate \\
\color{blue}
\url{https://github.com/jimb0w/LDL} \\
\color{black}
       \vfill
    \end{flushright}
        \Large

\noindent
Jedidiah Morton \\
Research Fellow \\
\color{blue}
\href{mailto:Jedidiah.Morton@Monash.edu}{Jedidiah.Morton@monash.edu} \\ 
\color{black}
\\
Monash University, Melbourne, Australia \\\
\\
\end{titlepage}

\begin{abstract}


This is the protocol for the paper \emph{Lipid-lowering strategies for primary prevention of coronary heart disease 
in the United Kingdom: A cost-effectiveness analysis}. In this protocol, the construction of 
a microsimulation model (based on the results of Mendelian randomisation analyses)
that ages people from the UK Biobank study from 30-85 years, tracking coronary heart disease (CHD),
is outlined. Using this model, the efficacy of different lipid-lowering strategies (LLS) for the primary
prevention of coronary heart disease (CHD) are simulated. These strategies include: low/moderate intensity statins;
high intensity statins; low/moderate intensity statins and ezetimibe; and inclisiran. 
All lead to varying to degress of low-density lipoprotein-cholesterol (LDL-C) reduction, come at a vast range of costs, 
and may have different levels of adherence, which makes comparison of cost-effectiveness
of these agents interesting. These lipid lowering strategies are also tested across a range of ages at intervention, because
the risk of CHD is proportional to the cumulative exposure to LDL-C, and, thus, earlier lowering of LDL-C will lead to greater
benefit in the longer-term; however, even if it is more effective to lower LDL-C at a younger age, at what age it is most
cost-effective to intervene is unclear. Therefore, we use the cumulative causal effect of LDL-C on CHD risk in this model
to estimate the effectiveness and cost-effectiveness of each LLS at ages 30, 40, 50, and 60, from the UK healthcare perspective. 
These analyses mostly utilise data from the UK Biobank study, and for estimates not directly estimable from the UK Biobank, 
other UK sources are used (for utilities and healthcare costs). The analyses use the UK willingness-to-pay 
threshold range of \textsterling 20,000-30,000. 

The results show that LLS initiated earlier in life prevent more MIs and are more cost-effective than LLS initiated later in life. 
Moreover, because absolute risk is higher in males and people with higher LDL-C, 
cost-effectiveness improves by targeting these interventions to these clinical sub-groups. 
Indeed, some of the statin-based LLS were cost-saving in people with high LDL-C, 
although they were also cost-effective at all ages for most sub-groups. 
Inclisiran was not cost-effective in any subgroup or any simulation. 
These results demonstrate that statin-based LLS are a highly cost-effective method of 
reducing the lifetime risk of CHD when initiated from as young as 30 years of
age and support a shift in the approach to primary prevention of CHD away from
short-term absolute risk estimates to early and sustained lowering of LDL-C.

\end{abstract}

\pagebreak
\tableofcontents
\pagebreak
\listoftables
\pagebreak
\listoffigures
\pagebreak

\pagebreak
\Large
\noindent
\textbf{Preface}
\normalsize

This work was completed with funding from the National Health and Medical Research Council of Australia, Ideas grant, 
Application ID: 2012582, which was obtained by Zanfina Ademi as the Chief Investigator, who supervised this work. Contributors 
to this project include: Clara Marquina, Melanie Lloyd, Gerald Watts, Sophia Zoungas, Danny Liew, and Zanfina Ademi. 

To generate this document, the Stata package texdoc \cite{Jann2016Stata} was used, which is 
available from: \color{blue} \url{http://repec.sowi.unibe.ch/stata/texdoc/} \color{black} (accessed 14 November 2022). 
The final Stata do file and this pdf are available at: \color{blue} \url{https://github.com/jimb0w/LDL} \color{black} -- 
The code in this pdf is 99.9999\% complete, except for certain unicode characters used in some tables and figures, 
so for complete reproducibility use the do file. 
For most plots throughout, the colour schemes used are \emph{inferno} and \emph{viridis} from the
\emph{viridis} package \cite{GarnierR2021}. \\

\pagebreak
\Large
\noindent
\textbf{Abbreviations}
\normalsize

\begin{itemize}
\item CHD: Coronary heart disease
\item LDL-C: Low-density lipoprotein-cholesterol
\item LLS: Lipid lowering strategy
\item MI: Myocardial infarction
\item MR: Mendelian randomisation
\item NHS: National Health Service (of the United Kingdom)
\item OSA: One-way sensitivity analysis
\item PSA: Probabilistic sensitivity analysis
\item QALY: Quality-adjusted life year
\item RR: Relative risk
\item SE: Standard error
\item UK: United Kingdom
\item YLL: Years of life lived
\end{itemize}

\pagebreak
\section{Introduction}

Coronary heart disease (CHD) remains a leading cause of morbidity and mortality worldwide \cite{RothJACC2020}.
An important causal determinant of CHD are low-density lipoproteins (LDL) \cite{FerenceEHJ2017}, 
whereby exposure to high levels of LDL over time exerts a cumulative effect on the risk for CHD 
(i.e., risk is proportional to both magnitude and duration of exposure) \cite{FerenceJAMA2019}.
However, robust estimates of the cost-effectiveness of strategies 
for early and intensive pharmacological lowering of LDL-cholesterol (LDL-C) on the lifetime 
risk of CHD based on this causal effect are lacking \cite{AdemiPE2022}. 

These estimates would ideally be derived from a randomized clinical trial; 
however, such a trial is unlikely to ever be undertaken given that it would 
take multiple decades and would be prohibitively expensive. 
Therefore, in this analysis, the causal effect of LDL-C on CHD derived from 
Mendelian randomisation (MR) analyses is used to develop a microsimulation model that integrates
the cumulative, causal effect of lowering low-density lipoprotein-cholesterol (LDL-C) on risk of CHD. 
The rationale for this, and the proposed approach have been reviewed in detail previously
\cite{AdemiPE2022}. The primary data source will be the UK Biobank 
\cite{SudlowPLOSMED2015}, and where data from the UK Biobank is not directly available (utilities and
healthcare costs), the best available sources are selected. 

Specifically, here, I examine the effect of the following lipid-lowering strategies (LLS) for primary
prevention of CHD: low/moderate intensity statins; high intensity statins; low/moderate intensity statins 
and ezetimibe; and inclisiran. Indeed, because these strategies
lead to varying to degress of low-density lipoprotein-cholesterol (LDL-C) reduction, come at a vast range of costs, 
and may have different levels of adherence, comparison of cost-effectiveness
of these agents is of considerable interest, and may help select the best agents to implement for primary
prevention of CHD at scale. 

Let us first outline why we would consider so many agents. Statins are undoubtedly the standard for LDL-C reduction,
as they are efficacious and cheap. However, side effects occur, and statin intolerance occurs in a non-trivial
number of people \cite{BytyciEHJ2022}, and the risk of intolerance increases with increasing statin dose \cite{BytyciEHJ2022}. 
To combat these issues, other agents can be used in combination with, or instead of statins. Ezetimibe
offers an option for intensifying LDL-C reduction when used in combination with low/moderate intensity statins, 
which leads to greater efficacy (in terms of LDL-C reduction) and less intolerance-related drug discontinuation 
\cite{KimLancet2022,AmbeAth2014}. 
Alternatively, Inclisiran is injected twice a year, and achieves large and sustained LDL-C reductions with just this twice-yearly dosing
scheme; Inclisiran may offer an advantage over the other therapies, as the others are all orally taken, and some have suggested 
the twice-yearly dosing scheme will improve adherence \cite{GencerEHJ2022}. (Note: improved adherence to injectables is only speculation, 
and has not yet been demonstrated; it is also possible people are less likely to agree to use an injectable when a 
\emph{much} cheaper pill is available.) This also explains why we wouldn't consider Monoclonal Antibodies to PCSK9 --
they are injected much more frequently, come at a far higher cost, and could be very difficult to manufacture at scale, making them
poor options for primary prevention of CHD. 

So, with all this information, the question arises: Which of these LLS are cost-effective, and at what 
age should they be implemented for primary prevention of CHD? The answer to this question will of course vary for different
groups in the population, especially based on absolute risk for CHD over the lifetime. Thus, 
in this analysis, the answer to this question will be sought for the overall UK Biobank population, 
and stratified by sub-groups (male and female, and by baseline LDL-C). 


\pagebreak
\section{Model structure}
\label{modelstructure}

To orient ourselves before even touching the data, let's first look at the structure of the model 
that I will be building here (figure~\ref{Schematic}). All individuals will start in the 
``No CHD'' health state at age 30 years (the risk of CHD before age 30 is
negligible). The model then simulates the cohort up to age 85 years, ageing individuals in 0.1-year increments.
In each cycle, individuals in the ``No CHD'' health state can move out of the ``No CHD'' health state and 
into the ``CHD'' health state by experiencing a non-fatal MI, or move into the ``Death'' health state
by dying from Non-CHD causes or from from a fatal MI or CHD death. ``Death'' is the only absorbing
state in this model. The other transition is from ``CHD'' to ``Death'', which occurs when people with 
CHD experience death from any cause. 

The focus of this model is for \emph{primary prevention} of CHD. This has two consequences for the model. First, 
repeat events are not considered -- once an individual experiences a non-fatal MI, they are only at risk
of all-cause mortality (the disutilities and healthcare costs of repeat MIs are assumed to be captured in the
chronic utilities and costs of this health state). Second, the risk of all-cause mortality in people with 
existing CHD is assumed to be unrelated to their LDL-C or cumulative LDL-C. 

The UK Biobank will be used as the population of the model and 
to estimate all these transition probabilities, the methods of which are 
detailed in section ~\ref{TPs}. Briefly, the transitions out of the ``No CHD'' health state are 
estimated using age-period-cohort models \cite{CarstensenSTATMED2007}, and the transition from 
``CHD'' to ``Death'' using a similar model. The incidence of non-fatal MI and rate of Fatal MI/CHD death
are assumed to be proportional to mean cumulative LDL-C; thus, these rates are adjusted as proportional
to the mean cumulative LDL-C over the lifetime for each UK Biobank participant (calculated in section
~\ref{LDLtrajsection}). These are the transition probabilities on which the interventions to lower LDL-C
operate (through altering mean cumulative LDL-C). 

This has now oriented us to what we hope to achieve with the data, so let's proceed to data cleaning.

\begin{figure}
    \centering
    \includegraphics[width=0.8\textwidth]{Model schematic.pdf}
    \caption{Model structure. Dashed lines are transition probabilities influenced by mean cumulative LDL-C; solid lines are transition probabilities not influenced by LDL-C.}
    \label{Schematic}
\end{figure}

\clearpage
\pagebreak
\section{Data cleaning}

Even though the UK Biobank is curated and probably very sound, it is worth conducting data 
cleaning/sanity checks to minimise the probability of major mistakes, in addition to creating a 
usable working dataset. 

First let's load the dataset, one variable at a time (for speed).
The variables of interest for this study are:
\begin{itemize}
\item Participant ID (Unique Data Identifier (UDI): eid))
\item Sex (UDI: 31-0.0)
\item Date of assessment (UDI: 53-0.0--53-3.0)
\item UK Biobank assessment centre (UDI: 54-0.0--54-3.0)
\item Year of birth (UDI: 34-0.0)
\item Month of birth (UDI: 52-0.0)
\item Date and source of first myocardial infarction (MI) (UDI: 42000-0.0--42001-0.0)
\item Date and causes of death (UDI: 40000-0.0--40002-1.14)
\item LDL-C measurement and date (UDI: 30780-0.0--30781-1.0)
\item Pre-coded medication use (UDI: 6153-0.0--6153-3.3 (females) \& 6177-0.0--6177-3.2 (males))
\end{itemize}

Then I have to drop all the people who have withdrawn consent since the download of this 
data extract. 

\color{Blue4}
***/

texdoc stlog, nodo cmdlog
cd "/home/jed/Documents/LDL"
mkdir CSV
mkdir GPH
mkdir LDLtraj
mkdir MIrisk
mkdir OSA
mkdir PSA
mkdir SCE
mkdir statins2021
import delimited "ukb669154.csv", clear varnames(1) colrange(1:1)
save DS_1, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(7:7)
rename v1 sex
save DS_2, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(74:81)
rename (v1 v5) (DOA1 AC1)
keep DOA1 AC1
save DS_3, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(8:8)
rename v1 YOB
save DS_4, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(73:73)
rename v1 MOB
save DS_5, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(13731:13732)
rename (v1 v2) (MIdate MIsource)
save DS_6, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(11680:11682)
rename (v1 v2 v3) (dod1 dod2 ucod)
save DS_7, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(11510:11513)
rename (v1 v2 v3 v4) (LDL1 LDL2 LDLdate1 LDLdate2)
save DS_8, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(6070:6073)
forval i = 1/4 {
rename v`i' F_meduse`i'
}
save DS_9, replace
import delimited "ukb669154.csv", clear varnames(1) colrange(6270:6272)
forval i = 1/3 {
rename v`i' M_meduse`i'
}
save DS_10, replace
use DS_1, clear
forval i = 2/10 {
merge 1:1 _n using DS_`i'
drop _merge
}
save DS_comb, replace
import delimited w88775_2023-04-25.csv, clear
rename v1 eid
save eiddrop, replace
use DS_comb, clear
merge 1:1 eid using eiddrop
keep if _merge == 1
drop _merge
save DS, replace
texdoc stlog close
texdoc stlog
use DS, clear
describe
ta sex
texdoc stlog close

/***
\color{black}
Date of assessment is the first variable of interest.
\color{Blue4}
***/

texdoc stlog
use DS, clear
destring sex, replace
gen DA1 = date(DOA1,"YMD")
format DA1 %td
count if missing(DOA1)
hist DA1, bin(1000) color(gs0) frequency graphregion(color(white)) xtitle("First study visit date")
texdoc graph, label(DAhist) fontface("Liberation Sans") caption(Initial study visit date for UK Biobank participants)
texdoc stlog close

/***
\color{black}

In figure~\ref{DAhist} the initial pilot study is evident before the main recruitment phase (that stops around Christmas evidently). 
All looks fine for this. 

Now place of assessment. It's also worth placing people in England/Scotland/Wales as this will become important later when using 
hospital and mortality data.

\color{Blue4}
***/

texdoc stlog
ta AC1
gen AC = "England"
replace AC = "Wales" if AC1 == "11003" | AC1 == "11022" | AC1 == "11023"
replace AC = "Scotland" if AC1 == "11004" | AC1 == "11005"
ta AC
texdoc stlog close

/***
\color{black}

This extract doesn't have date of birth, so it must be created from month and year of birth. 

\color{Blue4}
***/

texdoc stlog, cmdlog
set seed 616
gen DB = runiformint(1,28) if MOB == "2"
replace DB = runiformint(1,31) if MOB == "1" | MOB == "3" | MOB == "5" | MOB == "7" | MOB == "8" | MOB == "10" | MOB == "12"
replace DB = runiformint(1,30) if MOB == "4" | MOB == "6" | MOB == "9" | MOB == "11"
tostring DB, replace
replace DB = "0" + DB if length(DB)==1
replace MOB = "0" + MOB if length(MOB)==1
gen DBB = DB+MOB+YOB
gen DOB = date(DBB,"DMY")
format DOB %td
texdoc stlog close
texdoc stlog
count if missing(DOB)
count if missing(YOB) & missing(DOB)
count if missing(MOB) & missing(DOB)
texdoc local N = r(N)
texdoc stlog close

/***
\color{black}

Only a small number of people (`N') have no available year or month of birth, who will be excluded from analyses. 

\color{Blue4}
***/

texdoc stlog
hist DOB, bin(500) color(gs0) frequency graphregion(color(white)) xtitle("Date of birth") ///
tlabel(01jan1940 01jan1950 01jan1960 01jan1970)
texdoc graph, label(DOBhist) fontface("Liberation Sans") caption(Date of birth for UK Biobank participants)
texdoc stlog close

/***
\color{black}

Overall, date of birth looks sensible (figure~\ref{DOBhist}).
Next, MIs.
Note for MIsource the values mean the following:
\begin{itemize}
\item 0 Self-report only
\item 11 Hospital primary
\item 12 Death primary
\item 21 Hospital secondary
\item 22 Death secondary
\end{itemize}

\color{Blue4}
***/

texdoc stlog
gen MId = date(MIdate, "YMD")
format MId %td
count if MId!=.
count if MId <= DA1
count if MId > DA1 & MId!=.
texdoc local N1 = r(N)
ta MIsource if MId == td(1,1,1900)
texdoc local N2 = r(N)
ta MIsource if MId <= DA1
ta MIsource if MId > DA1 & MId!=., matcell(A)
texdoc local N3 = round((100*(A[4,1]+A[5,1])/r(N)),1)
hist MId, bin(500) color(gs0) frequency graphregion(color(white)) xtitle("Date of first MI")
texdoc graph, label(MIhist) fontface("Liberation Sans") caption(Date of first MI for UK Biobank participants)
texdoc stlog close

/***
\color{black}

So there are about `N1' incident MIs (I use about because dates of follow-up haven't been defined yet), 
which should give us some power. What is a bit concerning is that `N3' \% are from a secondary diagnosis on an admission, 
because you would expect that an MI would be the primary reason for a hospital admission and be coded as such, 
whereas a secondary diagnosis might indicate it is a historical MI (meaning the "date", and therefore the age, of the incident MI might be off).
It's probably reasonable to assume that having an MI as any diagnosis is sufficient to indicate that this individual 
has had an MI.
Also note that there are `N2' missing dates for MI, but because the interest in this study is only incident MI and
they're all self-reported, it's okay to assume these are just prevalent MI at first visit. 

Date of death is next. Not sure why there are two fields \ldots

\color{Blue4}
***/

texdoc stlog
count if dod2!=""
count if dod2!=dod1 & dod2!=""
texdoc stlog close

/***
\color{black}

No one has two dates of death, so that's good. 

\color{Blue4}
***/

texdoc stlog
gen dod = date(dod1, "YMD")
format dod %td
count if dod!=.
count if dod <= DA1
count if dod > DA1 & dod!=.
hist dod, bin(500) color(gs0) frequency graphregion(color(white)) xtitle("Date of death") ///
tlabel(01jan2006 01jan2010 01jan2014 01jan2018 01jan2022)
texdoc graph, label(dodhist) fontface("Liberation Sans") caption(Date of death for UK Biobank participants)
count if MId > dod & MId!=.
count if dod == MId & MId!=.
ta MIsource if dod == MId & MId!=.
ta MIsource if dod != MId & MId!=.
texdoc stlog close

/***
\color{black}

So this makes sense, and the deaths that coincide with MIs seem reasonable, which is good. 


In terms of cause of death, the only deaths of interest in this study are deaths from CHD,
so it can be defined easily here.
The definition of CHD death used will be the same as Ference et al. \cite{FerenceJAMA2019}
because that's where the estimate of the effect of LDL-C on MI and coronary death will come from. 
However, it appears Ference et al. used all contributing causes of death to define coronary death, which was fine for 
their purposes. But for this study, it only makes sense to include coronary death if
it is the underlying cause of death, as if someone dies of cancer/dementia or anything
else with CVD, it's not really fair to assume that LDL reduction would have prevented
that death. 

\color{Blue4}
***/

texdoc stlog
gen CHD_death = 1 if inrange(ucod,"I21","I249") | (inrange(ucod,"I25","I259") & ucod!="I254")
count if CHD_death == 1
count if CHD_death == 1 & MId!=.
count if CHD_death == 1 & MId==.
texdoc stlog close

/***
\color{black}

Now LDL-C. There are two values for LDL-C, of varying completeness:

\color{Blue4}
***/

texdoc stlog
count if missing(LDL1)
count if missing(LDL2)
count if missing(LDL1) & missing(LDL2)
count if missing(LDL1)==0 & missing(LDL2)==0
count if missing(LDL1) & missing(LDL2)==0
texdoc stlog close

/***
\color{black}

This will be collapsed into a single value for LDL-C, as most people have only one. 
While LDL-C will vary over time for some people, it is likely LDL-C at one 
point in time is a good proxy for LDL-C over the lifetime as most people don't 
have substantial variation in their LDL-C over time 
(unless they start a lipid-lowering therapy) \cite{DuncanJAHA2019}. 

\color{Blue4}
***/

texdoc stlog
replace LDL1 = LDL2 if missing(LDL1) & missing(LDL2)==0
destring LDL1, replace
hist LDL1, bin(500) color(gs0) frequency graphregion(color(white)) xtitle("LDL-C (mmol/L)")
texdoc graph, label(LDLhist) fontface("Liberation Sans") caption(LDL-C for UK Biobank participants)
su(LDL1), detail
texdoc stlog close

/***
\color{black}

Again, still looking fine (figure~\ref{LDLhist}), as expected for UK Biobank. 
Not everyone has a value, so again these individuals will need to be 
dropped for certain analyses. 

It's also worth stratifying LDL-C by lipid-lowering therapy (LLT) use
to ensure that field makes sense:

\color{Blue4}
***/

texdoc stlog
gen LLT=0
forval i = 1/4 {
replace LLT = 1 if F_meduse`i' == "1"
}
forval i = 1/3 {
replace LLT = 1 if M_meduse`i' == "1"
}
su LDL1 if LLT==0
su LDL1 if LLT==1
hist LDL1 if LLT == 0, bin(500) color(gs0) frequency graphregion(color(white))  ///
xtitle("LDL-C (mmol/L)") title("No LLT", placement(west) size(medium) color(gs0))
graph save "Graph" GPH/LDLLLT0, replace
hist LDL1 if LLT == 1, bin(500) color(gs0) frequency graphregion(color(white)) ///
xtitle("LDL-C (mmol/L)") title("LLT", placement(west) size(medium) color(gs0))
graph save "Graph" GPH/LDLLLT1, replace
graph combine GPH/LDLLLT0.gph GPH/LDLLLT1.gph, altshrink cols(1) xsize(3) graphregion(color(white))
texdoc graph, label(LDLhist2) fontface("Liberation Sans") caption(LDL-C for UK Biobank participants by LLT status)
texdoc stlog close

/***
\color{black}

Finally, strip the dataset to keep only what is needed.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
keep eid sex DA1 AC DOB MId MIsource dod LDL1 CHD_death LLT
rename (DA1 LDL1 DOB MId AC MIsource CHD_death LLT) (dofa ldl dob mid ubc mis chd llt)
save UKB_working, replace
texdoc stlog close

/***
\color{black}

\clearpage
\pagebreak
\section{Transition probabilities}
\label{TPs}

In this section, I outline the methods used to estimate the transition probabilities 
for the model (at this stage, unadjusted for LDL-C). 
The first step in this is converting the UK Biobank data to survival-time data. 
For that a censoring date is needed. According to UK Biobank 
(\color{blue}
\url{https://biobank.ctsu.ox.ac.uk/showcase/exinfo.cgi?src=Data_providers_and_dates}
\color{black}
; accessed 14 November 2022), 
follow-up is complete up to:
\begin{itemize}
\item 30 September 2021 for mortality data from England and Wales
\item 31 October 2021 for mortality data from Scotland
\item 30 September 2021 for hospital data from England
\item 31 July 2021 for hospital data from Scotland
\item 28 February 2018 for hospital data from Wales
\end{itemize}

So it would make sense to censor at 28 February 2018 for Wales, 31 July 2021 for Scotland, and 30 September 2021 for England. 

With this the survival time data can be assembled, dropping those with no available date of birth and with prevalent MI at
their first assessment. Thus, follow-up starts from date of first assessment and continues until the first of a non-fatal MI, 
death, or end of follow-up. Also, any MI where death occurred within two weeks will be treated as fatal 
(and dealt with later as a fatal MI).

\subsection{Non-fatal MI} 

\color{Blue4}
***/

texdoc stlog, cmdlog do
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate) 
gen fail = 1 if mid==faildate & faildate!=dod
replace fail = . if inrange(dod-mid,0,14)
recode fail .=0
gen origin = td(1,1,2006)
texdoc stlog close
texdoc stlog
stset faildate, fail(fail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
strate, per(1000)
texdoc stlog close

/***
\color{black}

This makes sense as a rate, and there is a reasonable amount of power.
Now by age and sex: 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
preserve
stsplit age, at(0(5)100) after(time=dob)
gen py = _t-_t0
collapse (sum) fail py, by(age sex)
gen rate = 1000*fail/py
gen age2 = age+4
tostring age-py age2, force format(%9.0f) replace
tostring rate, force format(%9.1f) replace
replace age = age + "-" + age2 if age!="85"
replace age = age+ "+" if age == "85"
drop age2
reshape wide fail py rate, i(age) j(sex)
export delimited using CSV/MINtable.csv, novarnames replace
restore
texdoc stlog close

/***
\color{black}

\begin{table}[h!]
  \begin{center}
    \caption{Crude non-fatal MI counts}
    \label{MItable}
    \pgfplotstabletypeset[
      multicolumn names,
      col sep=comma,
      string type,
      display columns/0/.style={column name=$Age$, column type={l}, text indicator="},
      display columns/1/.style={column name=$MIs$, column type={r}, column type/.add={|}{}},
      display columns/2/.style={column name=$Person-years$, column type={r}},
      display columns/3/.style={column name=$Incidence$, column type={r}},
      display columns/4/.style={column name=$MIs$, column type={r}, column type/.add={|}{}},
      display columns/5/.style={column name=$Person-years$, column type={r}},
      display columns/6/.style={column name=$Incidence$, column type={r}},
      every head row/.style={
        before row={\toprule
					& \multicolumn{3}{c}{Females} & \multicolumn{3}{c}{Males}\\
					},
        after row={ &  &  & (per 1000py) &  &  & (per 1000py) \\
        \midrule}
            },
        every last row/.style={after row=\bottomrule},
    ]{CSV/MINtable.csv}
  \end{center}
\end{table}

Okay, so there is reasonable power from ages 40-80 (table~\ref{MItable}), 
but not enough follow-up to do anything over age 80 with any confidence. 

Now the age-specific incidence of non-fatal MI can be modelled.
The method used will be the age-period-cohort (APC) model \cite{CarstensenSTATMED2007}.
What will be done here is as follows:
The data will be tabulated into 0.5-year intervals by age and year (i.e. date of follow-up).
Each unit contains the number of events and person-years of follow-up. The model is then fit on
this tabulated data, using the midpoint of each interval to represent the value of age and year
in the model. The model is a Poisson model, with spline effects of age, year, and cohort (year minus
age), using the log of person-time as the offset. Knot locations are those suggested by Frank Harrel \cite{Harrell2001Springer}.
Males and females are analysed in separate models. 
These models are then used to predict the incidence of non-fatal MI at each age (in 0.1-year increments,
for use in the model later, which will have 0.1-year increments), with the prediction year set at 2016. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
stsplit age, at(0(0.5)100) after(time=dob)
stsplit year, at(0(0.5)20)
gen py = _t-_t0
collapse (sum) fail py, by(age sex year)
save MIcollapseset, replace
forval s = 0/1 {
use MIcollapseset, clear
keep if sex == `s'
gen coh = year-age
replace age = age+0.25
replace year = year+0.25
pctile AA=age [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local a`i' = r(r`i')
}
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
pctile BB=year [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local b`i' = r(r`i')
}
mkspline yearsp = year, cubic knots(`b2' `b11' `b20' `b29' `b38')
pctile CC=coh [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local c`i' = r(r`i')
}
mkspline cohsp = coh, cubic knots(`c2' `c11' `c20' `c29' `c38')
poisson fail agesp* yearsp* cohsp*, exposure(py)
clear
set obs 550
gen age = ((_n+299)/10)+0.05
gen year = 10
gen coh = year-age
gen py = 1
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
mkspline yearsp = year, cubic knots(`b2' `b11' `b20' `b29' `b38')
mkspline cohsp = coh, cubic knots(`c2' `c11' `c20' `c29' `c38')
predict rate, ir
predict errr, stdp
replace age = age-0.05
replace age = round(age,.1)
gen sex = `s'
keep age sex rate errr
save MI_inc_`s', replace
}
texdoc stlog close
texdoc stlog, cmdlog
clear
append using MI_inc_0
append using MI_inc_1
tostring age, replace force format(%9.1f)
destring age, replace
save MI_inc, replace
use MI_inc, clear
replace rate = rate*1000
gen lb = exp(ln(rate)-1.96*errr)
gen ub = exp(ln(rate)+1.96*errr)
twoway ///
(rarea ub lb age if sex == 0, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1, color(blue) lpattern(solid)) ///
, legend(symxsize(0.13cm) position(11) ring(0) region(lcolor(white) color(none)) ///
order(2 "Females" ///
4 "Males") ///
cols(1)) ///
graphregion(color(white)) ///
ylabel(0(5)15, format(%9.0f) angle(0)) ///
xlabel(30(10)80, nogrid) ///
ytitle("Incidence (per 1,000 person-years)") ///
xtitle("Age (years)")
texdoc graph, label(MIinc) fontface("Liberation Sans") caption(Age- and sex-specific incidence of non-fatal MI among UK Biobank participants)
texdoc stlog close

/***
\color{black}

Realistically, it would have been good to limit prediction of rates to between 40 and 80, 
because those are the years for which there is reasonable data. However, I want to
model the lifetime risk of MI up to age 85 years, as 80 is a bit too
young to call a "lifetime risk". Admittedly, the general rule for extrapolating outside the range of your data is: don't; 
but the benefits probably outweigh the drawbacks here. It certainly won't be a problem under 40 as the very 
low rates won't really affect the model.

\subsection{Fatal MI and mortality in people without MI}

To complete the transition probabilities for the model 
age-specific mortality rates for people with and without MI will need to be estimated. 
Moreover, for people without MI, deaths will be split into MI/coronary (CHD) and non-CHD, 
as the model will assume CHD deaths are influenced by cumulative LDL, and non-CHD deaths are not. 

As a reminder, the censoring dates are:
\begin{itemize}
\item 30 September 2021 for mortality data from England and Wales
\item 31 October 2021 for mortality data from Scotland
\item 30 September 2021 for hospital data from England
\item 31 July 2021 for hospital data from Scotland
\item 28 February 2018 for hospital data from Wales
\end{itemize}

Even though there is more follow-up time for mortality data, to be sure of MI status, 
the hospital follow-up time still needs to be factored in.
So the censoring dates will be the same as those for non-fatal MI. 
This time, it's a bit more difficult for people with MI, because they need
to be censored at development of MI, and then followed up with MI to estimate
the mortality rate. 
Note that I will still exclude people with pre-existing MI at baseline, because to include them in this 
calculation would introduce selection bias (because they survived from their MI to inclusion
in UK Biobank, biasing the mortality estimates). 

First will be people without MI (again, fatal MIs are defined
by mortality within 14 days). People are followed from date of first assessment
until the first of a non-fatal MI, death (from MI/CHD or other causes), or end of follow-up: 

\color{Blue4}
***/

texdoc stlog, cmdlog do
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate)
gen MIfail = 1 if dod==faildate & mid == dod
replace MIfail = 1 if mid==faildate & inrange(dod-mid,0,14)
replace MIfail = 1 if chd==1 & dod==faildate
gen NCfail = 1 if dod==faildate & MIfail==.
recode MIfail .=0
recode NCfail .=0
gen origin = td(1,1,2006)
texdoc stlog close
texdoc stlog
stset faildate, fail(MIfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
strate, per(1000)
stset faildate, fail(NCfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
strate, per(1000)
texdoc stlog close

/***
\color{black}

The crude rates make sense for CHD and non-CHD, now by age and sex:

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
preserve
stset faildate, fail(MIfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
stsplit age, at(0(5)100) after(time=dob)
gen py = _t-_t0
collapse (sum) MIfail py, by(age sex)
gen rate = 1000*MIfail/py
gen age2 = age+4
tostring age-py age2, force format(%9.0f) replace
tostring rate, force format(%9.1f) replace
replace age = age + "-" + age2 if age!="85"
replace age = age+ "+" if age == "85"
drop age2
rename rate rateMI
save MIdcount, replace
restore
preserve
stset faildate, fail(NCfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
stsplit age, at(0(5)100) after(time=dob)
gen py = _t-_t0
collapse (sum) NCfail py, by(age sex)
gen rate = 1000*NCfail/py
gen age2 = age+4
tostring age-py age2, force format(%9.0f) replace
tostring rate, force format(%9.1f) replace
replace age = age + "-" + age2 if age!="85"
replace age = age+ "+" if age == "85"
drop age2
merge 1:1 sex age using MIdcount
drop _merge
tostring sex, force format(%9.0f) replace
replace sex ="" if _n!=1 & _n!= 12
replace sex = "Female" if sex == "0"
replace sex = "Male" if sex == "1"
order sex age py MIfail rateMI NCfail rate
export delimited using CSV/nCVDdeathNtable.csv, novarnames replace
restore
texdoc stlog close

/***
\color{black}

\begin{table}[h!]
  \begin{center}
    \caption{Crude death counts for people without MI}
    \label{D1table}
    \pgfplotstabletypeset[
      multicolumn names,
      col sep=comma,
      header=false,
      string type,
	  display columns/0/.style={column name=$Sex$,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{11}{*}{##1}}}},
      display columns/1/.style={column name=$Age$, column type={l}, text indicator="},
      display columns/2/.style={column name=$Person-years$, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=$Deaths$, column type={r}},
      display columns/4/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=$Deaths$, column type={r}},
      display columns/6/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & & \multicolumn{2}{c}{CHD} & \multicolumn{2}{c}{Non-CHD} \\
					},
        after row={ & & & & (per 1000py) & & (per 1000py) \\
        \midrule}
            },
        every nth row={11}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/nCVDdeathNtable.csv}
  \end{center}
\end{table}

Again, APC models are used (methods exactly the same as for non-fatal MI above), fitting a separate model for each outcome and sex.  

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
preserve
stset faildate, fail(MIfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
stsplit age, at(0(0.5)100) after(time=dob)
stsplit year, at(0(0.5)20)
gen py = _t-_t0
collapse (sum) MIfail py, by(age sex year)
save MIdeathcollapseset, replace
restore
stset faildate, fail(NCfail==1) entry(dofa) origin(origin) scale(365.25) id(eid)
stsplit double age, at(0(0.5)100) after(time=dob)
stsplit year, at(0(0.5)20)
gen py = _t-_t0
collapse (sum) NCfail py, by(age sex year)
save NCdeathcollapseset, replace
foreach z in MI NC {
forval s = 0/1 {
use `z'deathcollapseset, clear
rename `z'fail fail
keep if sex == `s'
gen coh = year-age
replace age = age+0.25
replace year = year+0.25
pctile AA=age [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local a`i' = r(r`i')
}
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
pctile BB=year [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local b`i' = r(r`i')
}
mkspline yearsp = year, cubic knots(`b2' `b11' `b20' `b29' `b38')
pctile CC=coh [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local c`i' = r(r`i')
}
mkspline cohsp = coh, cubic knots(`c2' `c11' `c20' `c29' `c38')
poisson fail agesp* yearsp* cohsp*, exposure(py)
clear
set obs 550
gen age = ((_n+299)/10)+0.05
gen year = 10
gen coh = year-age
gen py = 1
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
mkspline yearsp = year, cubic knots(`b2' `b11' `b20' `b29' `b38')
mkspline cohsp = coh, cubic knots(`c2' `c11' `c20' `c29' `c38')
predict rate, ir
predict errr, stdp
replace age = age-0.05
replace age = round(age,.1)
gen sex = `s'
gen `z' = 1
keep age sex rate errr `z'
save `z'd_`s', replace
}
}
clear
append using MId_0 MId_1 
tostring age, replace force format(%9.1f)
destring age, replace
save MIdrates, replace
clear
append using NCd_0 NCd_1
tostring age, replace force format(%9.1f)
destring age, replace
save NCdrates, replace
texdoc stlog close
texdoc stlog, cmdlog
clear
append using MIdrates NCdrates
replace rate = rate*1000
gen lb = exp(ln(rate)-1.96*errr)
gen ub = exp(ln(rate)+1.96*errr)
twoway ///
(rarea ub lb age if sex == 0 & NC== 1, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & NC == 1, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1 & NC == 1, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & NC == 1, color(blue) lpattern(solid)) ///
(rarea ub lb age if sex == 0 & MI == 1, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & MI == 1, color(red) lpattern(dash)) ///
(rarea ub lb age if sex == 1 & MI == 1, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & MI == 1, color(blue) lpattern(dash)) ///
, legend(symxsize(0.13cm) position(11) ring(0) region(lcolor(white) color(none)) ///
order(2 "Females - non-CHD death" ///
4 "Males - non-CHD death" ///
6 "Females - CHD death" ///
8 "Males - CHD death") ///
cols(2)) ///
graphregion(color(white)) ///
yscale(log range(0.0008 100)) ///
ylabel(0.001 "0.001" 0.01 "0.01" 0.1 "0.1" 1 "1" 10 "10", angle(0)) ///
xlabel(30(10)80, nogrid) ///
ytitle("Mortality (per 1,000 person-years)") ///
xtitle("Age (years)")
texdoc graph, label(NOCVDmort) fontface("Liberation Sans") caption(Age-, sex-, and cause-specific mortality among UK Biobank participants without CVD)
texdoc stlog close

/***
\color{black}

\subsection{Mortality following MI}

Now for mortality in the other health state, ``CHD'' (i.e., pre-existing MI). 
Here, people are followed from date of first MI (plus 14 days as to not introduce 
immortal-time bias, given how fatal MI is defined) until death or end of follow-up:

\color{Blue4}
***/

texdoc stlog, cmdlog do
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
replace mid = mid+14
drop if mid >= dod & mid!=.
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = dod if dod < faildate
drop if mid >= faildate
gen fail = 1 if dod==faildate
recode fail .=0
gen origin = td(1,1,2006)
texdoc stlog close
texdoc stlog
stset faildate, fail(fail==1) entry(mid) origin(origin) scale(365.25) id(eid)
strate, per(1000)
texdoc stlog close
texdoc stlog, cmdlog nodo
preserve
stsplit age, at(0(5)100) after(time=dob)
gen py = _t-_t0
collapse (sum) fail py, by(age sex)
gen rate = 1000*fail/py
gen age2 = age+4
tostring age-py age2, force format(%9.0f) replace
tostring rate, force format(%9.1f) replace
replace age = age + "-" + age2 if age!="85"
replace age = age+ "+" if age == "85"
drop age2
reshape wide (fail py rate), i(age) j(sex)
gen A = "Post-MI"
order A
save PMIcount, replace
restore
preserve
stsplit durn, at(0 0.25 0.5 1 2 5) after(time=mid)
gen py = _t-_t0
collapse (sum) fail py, by(durn sex)
gen rate = 1000*fail/py
gen dur = "0-3 months" if durn == 0
replace dur = "3-6 months" if durn == 0.25
replace dur = "6-12 months" if durn == 0.5
replace dur = "1-2 years" if durn == 1
replace dur = "2-5 years" if durn == 2
replace dur = "5+ years" if durn == 5
tostring fail-py, force format(%9.0f) replace
tostring rate, force format(%9.1f) replace
reshape wide (fail py rate), i(durn dur) j(sex)
drop durn
gen A = "Post-MI"
order A
save PMIcountdur, replace
restore
stsplit age, at(0(0.5)100) after(time=dob)
stsplit durn, at(0(0.5)20) after(time=mid)
stsplit year, at(0(0.5)20)
gen py = _t-_t0
collapse (sum) fail py, by(age durn sex year)
save PMIcollapseset, replace
clear
append using PMIcount
replace A ="" if _n !=1
export delimited using CSV/PCVdeathtable.csv, novarnames replace
clear
append using PMIcountdur
replace A ="" if _n !=1
export delimited using CSV/PCVdeathtabledur.csv, novarnames replace
texdoc stlog close

/***
\color{black}

\begin{table}[h!]
  \begin{center}
    \caption{Crude death counts for people with MI, by age and sex}
    \label{D2table}
    \pgfplotstabletypeset[
      multicolumn names,
      col sep=comma,
      header=false,
      string type,
	  display columns/0/.style={column name=$Cohort$,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=$Age$, column type={l}, text indicator="},
      display columns/2/.style={column name=$Deaths$, column type={r}, column type/.add={|}{}},
      display columns/3/.style={column name=$Person-years$, column type={r}},
      display columns/4/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=$Deaths$, column type={r}},
      display columns/6/.style={column name=$Person-years$, column type={r}},
      display columns/7/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      display columns/8/.style={column name=$Deaths$, column type={r}},
      display columns/9/.style={column name=$Person-years$, column type={r}},
      display columns/10/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{3}{c}{Females} & \multicolumn{3}{c}{Males}\\
					},
        after row={ & & & & (per 1000py) & & & (per 1000py) \\
        \midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/PCVdeathtable.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Crude death counts for people with MI, by time since event and sex}
    \label{D3table}
     \fontsize{9pt}{11pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=comma,
      header=false,
      string type,
	  display columns/0/.style={column name=$Cohort$,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{6}{*}{##1}}}},
      display columns/1/.style={column name=$Time-since-event$, column type={l}, text indicator="},
      display columns/2/.style={column name=$Deaths$, column type={r}, column type/.add={|}{}},
      display columns/3/.style={column name=$Person-years$, column type={r}},
      display columns/4/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=$Deaths$, column type={r}},
      display columns/6/.style={column name=$Person-years$, column type={r}},
      display columns/7/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      display columns/8/.style={column name=$Deaths$, column type={r}},
      display columns/9/.style={column name=$Person-years$, column type={r}},
      display columns/10/.style={column name=$Mortality$, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{3}{c}{Females} & \multicolumn{3}{c}{Males}\\
					},
        after row={ & & & & (per 1000py) & & & (per 1000py) \\
        \midrule}
            },
        every nth row={6}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/PCVdeathtabledur.csv}
  \end{center}
\end{table}

\clearpage

The mortality rates are much higher than for people without MI, as expected.
Mortality is also very high immediately after the event (i.e., is influenced by
time since the event) (table~\ref{D3table}). This can be factored in by including a time-since-event term in the Poisson model
used to estimate mortality rates post-MI. 
Again, the methods will be drawn from Bendix Carstensen \cite{CarstensenBMJO2020}. The methods are similar 
to those described above. In this analysis, data are tabulated into 0.5-year intervals by age, year (i.e. date of follow-up),
and duration (i.e. time since the MI). Each unit contains the number of events and person-years of follow-up. 
The model is then fit on this tabulated data, using the midpoint of each interval to represent the value of age, year, and duration
in the model. The model is a Poisson model, with spline effects of age, duration, and age at MI (age minus duration), a log-linear effect
of time (year), using the log of person-time as the offset. 
Knot locations are those suggested by Frank Harrel \cite{Harrell2001Springer}, except for duration, because
the majority of deaths occur very early on, so I had to specify knots specific to this data to avoid duplicated knot locations.
Again, males and females are analysed in separate models. 
These models are then used to predict the incidence of non-fatal MI at each age (in 0.1-year increments,
for use in the model later, which will have 0.1-year increments) and time-since MI (i.e., a much larger prediction matrix than before)
, with the prediction year again set at 2016. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
foreach z in MI {
forval s = 0/1 {
use P`z'collapseset, clear
keep if sex == `s'
gen adx = age-durn
replace age = age+0.25
replace durn = durn+0.25
replace year = year+0.25
pctile AA=age [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local a`i' = r(r`i')
}
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
pctile BB=durn [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local b`i' = r(r`i')
}
mkspline durnsp = durn, cubic knots(0 0.25 0.5 1.5 4 7)
pctile CC=adx [weight=fail], nq(40)
foreach i in 2 11 20 29 38 {
local c`i' = r(r`i')
}
mkspline adxsp = adx, cubic knots(`c2' `c11' `c20' `c29' `c38')
poisson fail agesp* durnsp* adxsp* year, exposure(py)
clear
set obs 550
gen adx = ((_n+299)/10)+0.05
expand 550
bysort adx : gen durn = (_n-1)/10
gen year = 10
gen age = adx+durn
drop if age > 85
gen py = 1
mkspline agesp = age, cubic knots(`a2' `a11' `a20' `a29' `a38')
mkspline durnsp = durn, cubic knots(0 0.25 0.5 1.5 4 7)
mkspline adxsp = adx, cubic knots(`c2' `c11' `c20' `c29' `c38')
predict rate, ir
predict errr, stdp
replace adx = adx-0.05
replace age = age-0.05
replace age = round(age,.1)
gen sex = `s'
gen `z' = 1
keep age durn adx sex rate errr `z'
save P`z'd_`s', replace
}
}
clear
append using PMId_0 PMId_1
tostring age, replace force format(%9.1f)
destring age, replace
save PMId, replace
texdoc stlog close
texdoc stlog, cmdlog
use PMId, clear
keep if adx == 40 | adx == 50 | adx == 60 | adx == 70
keep if durn < 15
replace rate = rate*1000
gen lb = exp(ln(rate)-1.96*errr)
gen ub = exp(ln(rate)+1.96*errr)
drop if age > 80
twoway ///
(rarea ub lb age if sex == 0 & adx == 40, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & adx == 40, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1 & adx == 40, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & adx == 40, color(blue) lpattern(solid)) ///
(rarea ub lb age if sex == 0 & adx == 50, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & adx == 50, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1 & adx == 50, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & adx == 50, color(blue) lpattern(solid)) ///
(rarea ub lb age if sex == 0 & adx == 60, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & adx == 60, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1 & adx == 60, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & adx == 60, color(blue) lpattern(solid)) ///
(rarea ub lb age if sex == 0 & adx == 70, color(red%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 0 & adx == 70, color(red) lpattern(solid)) ///
(rarea ub lb age if sex == 1 & adx == 70, color(blue%30) fintensity(inten80) lwidth(none)) ///
(line rate age if sex == 1 & adx == 70, color(blue) lpattern(solid)) ///
, legend(symxsize(0.13cm) position(11) ring(0) region(lcolor(white) color(none)) ///
order(2 "Females" ///
4 "Males" ) ///
cols(1)) ///
graphregion(color(white)) ///
yscale(log) ///
ylabel(1 2 5 10 20 50 100 200, angle(0)) ///
xlabel(40(10)80, nogrid) ///
ytitle("Mortality (per 1,000 person-years)") ///
xtitle("Age (years)")
texdoc graph, label(PMImort) fontface("Liberation Sans") caption(Age-, sex-, and time-since-MI-specific mortality among UK Biobank participants with MI)
texdoc stlog close

/***
\color{black}

As expected, uncertainty around these mortality rates is very high (figure~\ref{PMImort}), 
especially a few years after the event (for which there is little data).
This is probably not going to be a major issue, given the interest in this study is primary prevention. 

Finally, note these are just examples in figure~\ref{PMImort} --
a mortality rate has been predicted for every sex/age/time-since-event possible. 

\clearpage
\pagebreak
\section{LDL-C trajectories}
\label{LDLtrajsection}

\subsection{Mean LDL-C in UK Biobank}

At this point, the relevant transition probabilities for the model have been estimated. 
However, they are currently independent of LDL-C, so this will need to be incorporated into the non-fatal MI
and fatal MI/CHD death transition probabilities. 
For this study, the effect estimates of LDL-C on CHD will be derived from MR, 
as this gives a causal estimate of the effect. Specifically, the results of 
Ference et al. \cite{FerenceJAMA2019} will be used, 
which showed that for every 1 mmol/L reduction in LDL-C over the lifetime, 
the odds ratio for CHD was 0.46 (to be converted into a relative risk later on, see section~\ref{LDLAMI}). 
This number applies to the LDL-C over the lifetime, not instantaneous LDL-C at a given age. 
Thus, the model will require a projection of the lifetime LDL-C for everyone in the sample, which can be used
to estimate the cumulative LDL-C at any given age or each individual, 
which in turn is compared to the mean mean [two means intentional] cumulative 
LDL-C of the entire sample (i.e., first calculate the mean cumulative LDL-C for each individual at a given age, and
then estimate the mean of this value, for the ``mean mean cumulative LDL-C'') to calculate the reduction in MI risk. 
However, UK Biobank only has LDL-C at a single point in time (for the majority), and only assessed medication use at 
enrolment, so assumptions will need to be made to estimate cumulative LDL-C. These assumptions are as follows:

\begin{itemize}
\item LDL-C is constant from age 40 onwards. This is supported by some literature 
for people who don't take LLT \cite{DuncanJAHA2019}. 
\item Mean LDL-C is 0.75 mmol/L  at birth \cite{DescampsAth2004}, 
increases linearly to a mean of 2 mmol/L by age 5
(assumption based on \cite{KitJAMA2012}), and after this increases linearly to whatever value
the individual has recorded in UK Biobank by age 40. 
\item Where an individual sits on the LDL-C distribution is constant throughout life (i.e., someone in the 
5th percentile of LDL-C will be in that percentile for life). 
\item People receiving LLT at baseline initiated therapy 5 years before their date of first assessment. 
Given how low LLT persistence is, \cite{TothLHD2019,TalicCDT2021,OforiJOG2017} 
this is probably a reasonably conservative assumption.
\item People persist on LLT forever once they start LLT. Now this is really unrealistic, 
but it's also really conservative, so it is probably suitable. 
\item People not on LLT at baseline initiate LLT at an average rate of approximately 10 people
per 1,000 person-years. This estimate is taken from O'Keefe et al. \cite{OKeefeCLINEPI2016}, which also showed that LLT initiation
is highly dependent on age, so the LLT initiation rate will be:
\begin{itemize}
\item 1 per 1,000 person-years for people aged 40-49
\item 15 per 1,000 person-years for people aged 50-59
\item 35 per 1,000 person-years for people aged 60 and above
\end{itemize}
These numbers are all interpreted from Figure 1C in the O'Keefe et al. paper. Moreover, it is reasonable to assume that
LDL-C would affect probability of LLT initation, as would sex. The O'Keefe paper suggests that males are approximately 10-20\%
more likely to initiate LLT; thus, males will be 10\% more likely to initiate LLT than females. 
As for LDL-C, it's very unlikely robust data linking LDL-C, age, and sex to LLT initiation exists; 
thus, I will simply assume that for every standard deviation above the mean LDL-C that an individual is, 
they become 3 times more likely to initiate LLT (this may or may not reflect real clinical practice, 
which uses LDL-C cut-offs and risk calculators but is a very conserative approach in the absence of 
more data). 
\item LLT lowers LDL-C by 30\%. This is an assumption based on real-world studies of statin 
effectiveness \cite{FangLHD2021,BacquerEJPC2020}.
\end{itemize}

Note that these assumptions are as generous as possible, to lower the LDL-C as much as possible for 
the sample (and thus, the control condition, which will come into play later). In other words, 
I have taken a very conservative approach so that the effect of the interventions is minimised. 

Once LDL-C trajectories have been calculated for each person, these can then be used to
model age- and sex-specific mean LDL-C, and in turn use those values to calculate LDL-C adjusted MI incidence (in the next section). 
Interventions will be modelled later on. 

First, LDL-C trajectories for the UK Biobank cohort are estimated from age 0 to end of follow-up. 
To visualize the process, just 20 observations are kept at first, and 
I will then calculate trajectories for everyone. 

\color{Blue4}
***/

texdoc stlog, cmdlog do
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
keep if njm <= 20
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate)
gen agefail = (faildate-dob)/365.25
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
set seed 23254638
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : replace agellt = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt) if llt1 == 1
replace ldl = ldl*0.7 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = . if age > agefail
twoway ///
(line ldl age if njm == 1, color(gs0)) ///
(line ldl age if njm == 2, color(gs0)) ///
(line ldl age if njm == 3, color(gs0)) ///
(line ldl age if njm == 4, color(gs0)) ///
(line ldl age if njm == 5, color(gs0)) ///
(line ldl age if njm == 6, color(gs0)) ///
(line ldl age if njm == 7, color(gs0)) ///
(line ldl age if njm == 8, color(gs0)) ///
(line ldl age if njm == 9, color(gs0)) ///
(line ldl age if njm == 10, color(gs0)) ///
(line ldl age if njm == 11, color(gs0)) ///
(line ldl age if njm == 12, color(gs0)) ///
(line ldl age if njm == 13, color(gs0)) ///
(line ldl age if njm == 14, color(gs0)) ///
(line ldl age if njm == 15, color(gs0)) ///
(line ldl age if njm == 16, color(gs0)) ///
(line ldl age if njm == 17, color(gs0)) ///
(line ldl age if njm == 18, color(gs0)) ///
(line ldl age if njm == 19, color(gs0)) ///
(line ldl age if njm == 20, color(gs0)) ///
, legend(off) graphregion(color(white)) ///
ytitle(LDL-C (mmol/L)) xtitle(Age)
texdoc graph, label(LDL201) fontface("Liberation Sans") caption(Uncorrected LDL-C trajectories in 20 UK Biobank participants)
texdoc stlog close

/***
\color{black}

At this point (figure~\ref{LDL201}), LDL-C is just constant over the lifetime until LLT initiation
, but it needs to be adjusted at younger ages.

\color{Blue4}
***/

texdoc stlog, cmdlog do
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
twoway ///
(line ldl age if njm == 1, color(gs0)) ///
(line ldl age if njm == 2, color(gs0)) ///
(line ldl age if njm == 3, color(gs0)) ///
(line ldl age if njm == 4, color(gs0)) ///
(line ldl age if njm == 5, color(gs0)) ///
(line ldl age if njm == 6, color(gs0)) ///
(line ldl age if njm == 7, color(gs0)) ///
(line ldl age if njm == 8, color(gs0)) ///
(line ldl age if njm == 9, color(gs0)) ///
(line ldl age if njm == 10, color(gs0)) ///
(line ldl age if njm == 11, color(gs0)) ///
(line ldl age if njm == 12, color(gs0)) ///
(line ldl age if njm == 13, color(gs0)) ///
(line ldl age if njm == 14, color(gs0)) ///
(line ldl age if njm == 15, color(gs0)) ///
(line ldl age if njm == 16, color(gs0)) ///
(line ldl age if njm == 17, color(gs0)) ///
(line ldl age if njm == 18, color(gs0)) ///
(line ldl age if njm == 19, color(gs0)) ///
(line ldl age if njm == 20, color(gs0)) ///
, legend(off) graphregion(color(white)) ///
ytitle(LDL-C (mmol/L)) xtitle(Age)
texdoc graph, label(LDLage20) fontface("Liberation Sans") caption(LDL-C trajectories in 20 UK Biobank participants)
texdoc stlog close

/***
\color{black}

This is very clunky (figure~\ref{LDLage20}), but better than assuming a constant lifetime LDL-C.
Moreover, the model ultimately only uses mean cumulative LDL-C, so that will smooth the 
results. 

\color{Blue4}
***/

texdoc stlog, cmdlog do
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
sort eid age
twoway ///
(line cumldl age if njm == 1, color(gs0)) ///
(line cumldl age if njm == 2, color(gs0)) ///
(line cumldl age if njm == 3, color(gs0)) ///
(line cumldl age if njm == 4, color(gs0)) ///
(line cumldl age if njm == 5, color(gs0)) ///
(line cumldl age if njm == 6, color(gs0)) ///
(line cumldl age if njm == 7, color(gs0)) ///
(line cumldl age if njm == 8, color(gs0)) ///
(line cumldl age if njm == 9, color(gs0)) ///
(line cumldl age if njm == 10, color(gs0)) ///
(line cumldl age if njm == 11, color(gs0)) ///
(line cumldl age if njm == 12, color(gs0)) ///
(line cumldl age if njm == 13, color(gs0)) ///
(line cumldl age if njm == 14, color(gs0)) ///
(line cumldl age if njm == 15, color(gs0)) ///
(line cumldl age if njm == 16, color(gs0)) ///
(line cumldl age if njm == 17, color(gs0)) ///
(line cumldl age if njm == 18, color(gs0)) ///
(line cumldl age if njm == 19, color(gs0)) ///
(line cumldl age if njm == 20, color(gs0)) ///
, legend(off) graphregion(color(white)) ///
ytitle(Cumulative LDL-C (mmol/L * years)) xtitle(Age)
texdoc graph, label(cumLDLage20) fontface("Liberation Sans") caption(Cumulative LDL-C trajectories in 20 UK Biobank participants)
twoway ///
(line aveldl age if njm == 1, color(gs0)) ///
(line aveldl age if njm == 2, color(gs0)) ///
(line aveldl age if njm == 3, color(gs0)) ///
(line aveldl age if njm == 4, color(gs0)) ///
(line aveldl age if njm == 5, color(gs0)) ///
(line aveldl age if njm == 6, color(gs0)) ///
(line aveldl age if njm == 7, color(gs0)) ///
(line aveldl age if njm == 8, color(gs0)) ///
(line aveldl age if njm == 9, color(gs0)) ///
(line aveldl age if njm == 10, color(gs0)) ///
(line aveldl age if njm == 11, color(gs0)) ///
(line aveldl age if njm == 12, color(gs0)) ///
(line aveldl age if njm == 13, color(gs0)) ///
(line aveldl age if njm == 14, color(gs0)) ///
(line aveldl age if njm == 15, color(gs0)) ///
(line aveldl age if njm == 16, color(gs0)) ///
(line aveldl age if njm == 17, color(gs0)) ///
(line aveldl age if njm == 18, color(gs0)) ///
(line aveldl age if njm == 19, color(gs0)) ///
(line aveldl age if njm == 20, color(gs0)) ///
, legend(off) graphregion(color(white)) ///
ytitle(Mean cumulative LDL-C (mmol/L)) xtitle(Age)
texdoc graph, label(aveLDLage20) fontface("Liberation Sans") caption(Mean cumulative LDL-C trajectories in 20 UK Biobank participants)
texdoc stlog close

/***
\color{black}

These look okay (figures~\ref{cumLDLage20} \& \ref{aveLDLage20}).
Now this process can be repeated for the entire sample. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate)
gen agefail = (faildate-dob)/365.25
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : replace agellt = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt) if llt1 == 1
replace ldl = ldl*0.7 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = . if age > agefail
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
sort eid age
matrix A = (.,.,.,.)
forval i = 30(0.1)84.9 {
local j = `i'-0.01
local k = `i'+0.01
su(aveldl) if inrange(age,`j',`k') & sex == 0
matrix A = (A\0,`i',r(mean),r(N))
su(aveldl) if inrange(age,`j',`k') & sex == 1
matrix A = (A\1,`i',r(mean),r(N))
}
clear
svmat double A
drop if A1==.
rename (A1 A2 A3 A4) (sex age ldlave N)
sort sex age
save LDLtraj/ldlave_`a', replace
}
clear
forval a = 1(1000)458001 {
append using LDLtraj/ldlave_`a'
}
matrix A = (.,.,.,.)
forval i = 30(0.1)84.9 {
local j = `i'-0.01
local k = `i'+0.01
su(ldlave) [aweight=N] if inrange(age,`j',`k') & sex == 0
matrix A = (A\0,`i',r(mean),r(sum_w))
su(ldlave) [aweight=N] if inrange(age,`j',`k') & sex == 1
matrix A = (A\1,`i',r(mean),r(sum_w))
}
clear
svmat double A
drop if A1==.
rename (A1 A2 A3 A4) (sex age ldlave N)
sort sex age
save ldlave, replace
texdoc stlog close
texdoc stlog, cmdlog do
use ldlave, clear
twoway ///
(line ldlave age if sex == 0, color(red)) ///
(line ldlave age if sex == 1, color(blue)) ///
, legend(order(1 "Females" 2 "Males") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none)) ) ///
graphregion(color(white)) ///
ytitle(Mean cumulative LDL-C (mmol/L)) xtitle(Age)
texdoc graph, label(cummeanLDL) fontface("Liberation Sans") caption(Mean cumulative LDL-C by sex)
texdoc stlog close

/***
\color{black}

This is pretty nasty after age ~80 (figure~\ref{cummeanLDL}), so to fix that:

\color{Blue4}
***/

texdoc stlog, cmdlog do
mkspline agesp = age, cubic knots(30(10)80)
reg ldlave agesp* [aweight=N] if sex == 0
predict ldlf if sex == 0
reg ldlave agesp* [aweight=N] if sex == 1
predict ldlm if sex == 1
twoway ///
(line ldlave age if sex == 0, color(red)) ///
(line ldlave age if sex == 1, color(blue)) ///
(line ldlf age if sex == 0, color(red) lpattern(dash)) ///
(line ldlm age if sex == 1, color(blue) lpattern(dash)) ///
, legend(order(1 "Females" 3 "Females - modelled" 2 "Males" 4 "Males - modelled") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none)) ) ///
graphregion(color(white)) ///
ytitle(Mean cumulative LDL-C (mmol/L)) xtitle(Age)
texdoc graph, label(cummeanLDLmod) fontface("Liberation Sans") caption(Mean cumulative LDL-C by sex, modelled)
replace ldlave = ldlf if sex == 0
replace ldlave = ldlm if sex == 1
keep sex age ldlave
tostring age, replace force format(%9.1f)
destring age, replace
save ldlave_reg, replace
texdoc stlog close

/***
\color{black}

Much nicer (figure~\ref{cummeanLDLmod}). To re-iterate, what I have calculated so far is the mean mean cumulative LDL-C estimates for the
UK Biobank population, which is not the same as the standard of care/control scenario. That is done below. 
Before that, it is worth using this process to work out the proportion of people in the 
primary prevention population on LLT in the control scenario 
at ages 40, 50, 60, 70, and 80 (Table~\ref{statinproptab}).

\begin{table}[h!]
  \begin{center}
    \caption{Proportion of primary prevention population in the control scenario on LLT 
at or before a given age, stratified by sex and LDL-C.}
    \label{statinproptab}
     \selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Sex,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Age, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Overall, column type={r}},
      display columns/3/.style={column name=$\geq$3.0, column type={r}},
      display columns/4/.style={column name=$\geq$4.0, column type={r}},
      display columns/5/.style={column name=$\geq$5.0, column type={r}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{4}{c}{LDL-C (mmol/L)}\\
					},
        after row={\midrule}
            },
        every nth row={5}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/statinprop.csv}
  \end{center}
\end{table}

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate)
gen agefail = (faildate-dob)/365.25
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : replace agellt = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt) if llt1 == 1
replace ldl = ldl*0.7 if age >= agellt1 & llt1 == 1
sort eid age
gen lltage = min(agellt,agellt1)
bysort eid (age) : keep if _n == 1
keep eid lltage
save LDLtraj/lltage_`a', replace
}
clear
forval a = 1(1000)458001 {
append using LDLtraj/lltage_`a'
}
save lltage, replace
use lltage, clear
merge 1:1 eid using UKB_working
drop if _merge == 2
drop _merge
keep eid lltage ldl sex
matrix B = (.,.,.,.,.)
forval s = 0/1 {
foreach l in 0 3 4 5 {
count if sex == `s' & ldl>=`l'
local b = (r(N))
forval i = 40(10)80 {
count if lltage <= `i' & sex == `s' & ldl>=`l'
matrix B = (B\0`s',`l',`i',r(N),`b')
}
}
}
clear
svmat B
drop if _n == 1
gen perc = 100*B4/B5
tostring perc, replace force format(%9.2f)
replace perc = perc + "\%"
drop B4 B5
reshape wide perc, i(B1 B3) j(B2)
tostring B1 B3, replace force format(%9.0f)
bysort B1 (B3) : replace B1 ="" if _n!=1
replace B1 = "Females" if B1 == "0"
replace B1 = "Males" if B1 == "1"
export delimited using CSV/statinprop.csv, delimiter(":") novarnames replace
forval a = 1(1000)458001 {
erase LDLtraj/lltage_`a'.dta
}
texdoc stlog close

/***
\color{black}

\subsection{Interventions}

Indeed, I now need to simulate LDL-C trajectories for our full cohort over the lifetime, and under several conditions (i.e., drugs).
The conditions, and their respective LDL-C reductions, are as follows:
\begin{enumerate}
\setcounter{enumi}{-1}
\item Standard of care/control. This is similar to that described above. In short, this arm is current standard of care, 
where: people receiving LLT at baseline are assumed to have initiated therapy 5 years before their date of first assessment;
people persist on LLT forever once they start LLT; and
people not on LLT at baseline initiate LLT at an average rate of approximately 10 people per 1,000 person-years,
and this rate is affected by age, sex, and LDL-C. Again, all these assumptions are very generous to take the 
most conservative approach and minimise the effectiveness of the other interventions. 
The only difference between this control scenario with the estimation of average LDL-C during follow-up described above 
is that LLT will lower LDL-C by 45\% (a generous (and therefore conservative) assumption based on the effects of low/moderate intensity statins, 
high intensity statins, and low/moderate intensity statins, outlined in the following dot points), not 30\% as above.
\item Low/moderate intensity statins. The most common statin in this category (as defined by the ACC/AHA \cite{StoneJACC2014}) 
in the UK in June 2021 was Atorvastatin (20mg and 10mg; see below), and the best available evidence for the effect of atorvastatin on 
LDL-C comes from a systematic review, which estimated a 42.3\% (95\%CI: 42.0, 42.6) reduction at 20mg, and 37.1\% (36.9, 37.3) for 10mg
\cite{AdamsCDSR2015}. 
The next most common was Simvastatin (40mg and 20mg), which reduced LDL-C by 35\% over follow up in the  LDL-C 
Scandinavian Simvastatin Survival Study \cite{4SLancet1994}. Thus, a reasonable estimate for LDL-C reduction on low/moderate intensity statins
would be 40\%, with a 95\% CI of 39 to 41 (which happens to be the exact result from the 
Collaborative Atorvastatin Diabetes Study (CARDS) trial, the major primary prevention trial with atorvastatin \cite{ColhounLancet2004}). 
\item High intensity statins. Again, the most common in this category is Atorvastatin (40mg and 80mg), and the aforementioned
systematic review puts the LDL-C reduction with 40mg of Atorvastatin at 47.4\% (46.9, 48.0), and 51.7\% (51.2, 52.2) for 80mg 
\cite{AdamsCDSR2015}. 
Thus, 50\% (49, 51) would be a reasonable estimate for LDL-C reduction with high-intensity statins. 
\item Low/moderate intensity statins and ezetimibe. The best evidence for the effect of ezetimibe added to statins is 
taken from a systematic review \cite{AmbeAth2014}, which estimates that adding ezetimibe to ongoing statin reduced LDL-C by 26.0\% 
(25.2, 26.8), while switching to high-intensity Rosuvastatin 10mg reduced LDL-C by 19.7\% (17.7, 21.7). This suggests
that a reasonable estimate of the effect of low/moderate intensity statins on LDL-C (compared to nothing at all) would be 55\% 
(54, 56). 
\item Inclisiran. The LDL-C reduction for people taking Inclisiran is 51.5\% (95\% CI, 49.0 to 53.9), 
based on a weighted average of the results (time-weighted average reduction in LDL-C) 
of the ORION-10 and ORION-11 trials \cite{KausikNEJM2020},
which were selected as the most relevant evidence (phase III trials in a population where ~99\% of the people did
not have familial hypercholesterolaemia). 
\end{enumerate}

For all interventions (i.e., everything above except the control), they are implemented at ages 30, 40, 50, and 60 years
(i.e., 4 different strategies per intervention), and it is assumed that LLT initiation is as in the control arm until 
the age of the intervention, at which everyone gets the intervention. 

This is how the current Statin use in the UK was assessed: 


\color{Blue4}
***/

texdoc stlog, cmdlog nodo
import delimited "epd_202106.csv", clear varname(1) rowrange(18000000:18999999)
forval i = 1(1000000)18000000 {
local j = `i'+999999
import delimited "epd_202106.csv", clear varnames(1) rowrange(`i':`j')
gen AA = ""
replace AA = substr(bnf_des,1,12) if substr(bnf_des,1,12)=="Atorvastatin"
replace AA = substr(bnf_des,1,11) if substr(bnf_des,1,11)=="Pravastatin"
replace AA = substr(bnf_des,1,11) if substr(bnf_des,1,11)=="Simvastatin"
replace AA = substr(bnf_des,1,12) if substr(bnf_des,1,12)=="Rosuvastatin"
replace AA = substr(bnf_des,1,11) if substr(bnf_des,1,11)=="Fluvastatin"
keep if AA !=""
save statins2021/st_`i', replace
}
texdoc stlog close
texdoc stlog, cmdlog
clear
forval i = 1(1000000)18000000 {
append using statins2021/st_`i'
}
texdoc stlog close
texdoc stlog
collapse (sum) items, by(bnf_description AA)
ta AA [aweight=item]
ta bnf_description [weight=items]
texdoc stlog close

/***
\color{black}

Back to calculation of LDL-C trajectories. 
For these calculations, mortality is not taken into account yet, as that will be part of the model. 
So, even if an individual lacks follow-up, I can still estimate an LDL-C trajectory across their
entire lifespan.

Just to visualise it, the interventions will just be applied to two people at first
, one with a very low LDL-C, the other very high.

\color{Blue4}
***/

texdoc stlog, cmdlog do
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
keep if _n == 114 | _n == 115
gen njm = _n
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*0.55 if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
set seed 0240
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*0.55 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
keep eid sex ldl age njm ldl_0_30-ldl_0_60
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*0.6 if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*0.5 if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*0.45 if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*0.485 if age >= `i'
}
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')/10
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
}
}
preserve
use inferno, clear
local col1 = var6[2]
local col2 = var6[3]
local col3 = var6[4]
local col4 = var6[5]
local col5 = var6[6]
restore
twoway ///
(line ldl age if njm == 1, color("`col1'")) ///
(line ldl_1_30 age if njm == 1, color("`col2'")) ///
(line ldl_1_40 age if njm == 1, color("`col2'")) ///
(line ldl_1_50 age if njm == 1, color("`col2'")) ///
(line ldl_1_60 age if njm == 1, color("`col2'")) ///
(line ldl_2_30 age if njm == 1, color("`col3'")) ///
(line ldl_2_40 age if njm == 1, color("`col3'")) ///
(line ldl_2_50 age if njm == 1, color("`col3'")) ///
(line ldl_2_60 age if njm == 1, color("`col3'")) ///
(line ldl_3_30 age if njm == 1, color("`col4'")) ///
(line ldl_3_40 age if njm == 1, color("`col4'")) ///
(line ldl_3_50 age if njm == 1, color("`col4'")) ///
(line ldl_3_60 age if njm == 1, color("`col4'")) ///
(line ldl_4_30 age if njm == 1, color("`col5'")) ///
(line ldl_4_40 age if njm == 1, color("`col5'")) ///
(line ldl_4_50 age if njm == 1, color("`col5'")) ///
(line ldl_4_60 age if njm == 1, color("`col5'")) ///
(line ldl age if njm == 2, color("`col1'")) ///
(line ldl_1_30 age if njm == 2, color("`col2'")) ///
(line ldl_1_40 age if njm == 2, color("`col2'")) ///
(line ldl_1_50 age if njm == 2, color("`col2'")) ///
(line ldl_1_60 age if njm == 2, color("`col2'")) ///
(line ldl_2_30 age if njm == 2, color("`col3'")) ///
(line ldl_2_40 age if njm == 2, color("`col3'")) ///
(line ldl_2_50 age if njm == 2, color("`col3'")) ///
(line ldl_2_60 age if njm == 2, color("`col3'")) ///
(line ldl_3_30 age if njm == 2, color("`col4'")) ///
(line ldl_3_40 age if njm == 2, color("`col4'")) ///
(line ldl_3_50 age if njm == 2, color("`col4'")) ///
(line ldl_3_60 age if njm == 2, color("`col4'")) ///
(line ldl_4_30 age if njm == 2, color("`col5'")) ///
(line ldl_4_40 age if njm == 2, color("`col5'")) ///
(line ldl_4_50 age if njm == 2, color("`col5'")) ///
(line ldl_4_60 age if njm == 2, color("`col5'")) ///
, legend(order(1 "Control" ///
2 "Low/moderate intensity statins" ///
6 "High intensity statins" ///
10 "Low/moderate intensity statins and ezetimibe" ///
14 "Inclisiran") ///
cols(1) position(3) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(LDL-C (mmol/L)) xtitle(Age) xsize(10)
texdoc graph, label(LDLwithint) fontface("Liberation Sans") caption(LDL-C with various interventions for 2 individuals)
texdoc stlog close

/***
\color{black}
Some things to note here (figure~\ref{LDLwithint}):
There's a large difference in 
absolute LDL-C reduction by baseline LDL-C (as expected/by definition). 
Also, the control condition can result in a lower LDL-C at the end of life than 
low/moderate intensity statins. This is good -- this analysis is seeking
to answer the question as to whether it's more cost-effective to intervene to 
lower LDL-C earlier in life, 
so comparing a strategy that usually results in intense LDL-C lowering later in life
(the control) with a less intense strategy earlier in life is interesting. 
\color{Blue4}
***/

texdoc stlog, cmdlog do
preserve
use inferno, clear
local col1 = var6[2]
local col2 = var6[3]
local col3 = var6[4]
local col4 = var6[5]
local col5 = var6[6]
restore
twoway ///
(line cumldl age if njm == 1, color("`col1'")) ///
(line cumldl_1_30 age if njm == 1, color("`col2'")) ///
(line cumldl_1_40 age if njm == 1, color("`col2'")) ///
(line cumldl_1_50 age if njm == 1, color("`col2'")) ///
(line cumldl_1_60 age if njm == 1, color("`col2'")) ///
(line cumldl_2_30 age if njm == 1, color("`col3'")) ///
(line cumldl_2_40 age if njm == 1, color("`col3'")) ///
(line cumldl_2_50 age if njm == 1, color("`col3'")) ///
(line cumldl_2_60 age if njm == 1, color("`col3'")) ///
(line cumldl_3_30 age if njm == 1, color("`col4'")) ///
(line cumldl_3_40 age if njm == 1, color("`col4'")) ///
(line cumldl_3_50 age if njm == 1, color("`col4'")) ///
(line cumldl_3_60 age if njm == 1, color("`col4'")) ///
(line cumldl_4_30 age if njm == 1, color("`col5'")) ///
(line cumldl_4_40 age if njm == 1, color("`col5'")) ///
(line cumldl_4_50 age if njm == 1, color("`col5'")) ///
(line cumldl_4_60 age if njm == 1, color("`col5'")) ///
(line cumldl age if njm == 2, color("`col1'")) ///
(line cumldl_1_30 age if njm == 2, color("`col2'")) ///
(line cumldl_1_40 age if njm == 2, color("`col2'")) ///
(line cumldl_1_50 age if njm == 2, color("`col2'")) ///
(line cumldl_1_60 age if njm == 2, color("`col2'")) ///
(line cumldl_2_30 age if njm == 2, color("`col3'")) ///
(line cumldl_2_40 age if njm == 2, color("`col3'")) ///
(line cumldl_2_50 age if njm == 2, color("`col3'")) ///
(line cumldl_2_60 age if njm == 2, color("`col3'")) ///
(line cumldl_3_30 age if njm == 2, color("`col4'")) ///
(line cumldl_3_40 age if njm == 2, color("`col4'")) ///
(line cumldl_3_50 age if njm == 2, color("`col4'")) ///
(line cumldl_3_60 age if njm == 2, color("`col4'")) ///
(line cumldl_4_30 age if njm == 2, color("`col5'")) ///
(line cumldl_4_40 age if njm == 2, color("`col5'")) ///
(line cumldl_4_50 age if njm == 2, color("`col5'")) ///
(line cumldl_4_60 age if njm == 2, color("`col5'")) ///
, legend(order(1 "Control" ///
2 "Low/moderate intensity statins" ///
6 "High intensity statins" ///
10 "Low/moderate intensity statins and ezetimibe" ///
14 "Inclisiran") ///
cols(1) position(3) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative LDL-C (mmol/L years)) xtitle(Age) xsize(10)
texdoc graph, label(cumLDLwithint) fontface("Liberation Sans") caption(Cumulative LDL-C with various interventions for 2 individuals)
twoway ///
(line aveldl age if njm == 1, color("`col1'")) ///
(line aveldl_1_30 age if njm == 1, color("`col2'")) ///
(line aveldl_1_40 age if njm == 1, color("`col2'")) ///
(line aveldl_1_50 age if njm == 1, color("`col2'")) ///
(line aveldl_1_60 age if njm == 1, color("`col2'")) ///
(line aveldl_2_30 age if njm == 1, color("`col3'")) ///
(line aveldl_2_40 age if njm == 1, color("`col3'")) ///
(line aveldl_2_50 age if njm == 1, color("`col3'")) ///
(line aveldl_2_60 age if njm == 1, color("`col3'")) ///
(line aveldl_3_30 age if njm == 1, color("`col4'")) ///
(line aveldl_3_40 age if njm == 1, color("`col4'")) ///
(line aveldl_3_50 age if njm == 1, color("`col4'")) ///
(line aveldl_3_60 age if njm == 1, color("`col4'")) ///
(line aveldl_4_30 age if njm == 1, color("`col5'")) ///
(line aveldl_4_40 age if njm == 1, color("`col5'")) ///
(line aveldl_4_50 age if njm == 1, color("`col5'")) ///
(line aveldl_4_60 age if njm == 1, color("`col5'")) ///
(line aveldl age if njm == 2, color("`col1'")) ///
(line aveldl_1_30 age if njm == 2, color("`col2'")) ///
(line aveldl_1_40 age if njm == 2, color("`col2'")) ///
(line aveldl_1_50 age if njm == 2, color("`col2'")) ///
(line aveldl_1_60 age if njm == 2, color("`col2'")) ///
(line aveldl_2_30 age if njm == 2, color("`col3'")) ///
(line aveldl_2_40 age if njm == 2, color("`col3'")) ///
(line aveldl_2_50 age if njm == 2, color("`col3'")) ///
(line aveldl_2_60 age if njm == 2, color("`col3'")) ///
(line aveldl_3_30 age if njm == 2, color("`col4'")) ///
(line aveldl_3_40 age if njm == 2, color("`col4'")) ///
(line aveldl_3_50 age if njm == 2, color("`col4'")) ///
(line aveldl_3_60 age if njm == 2, color("`col4'")) ///
(line aveldl_4_30 age if njm == 2, color("`col5'")) ///
(line aveldl_4_40 age if njm == 2, color("`col5'")) ///
(line aveldl_4_50 age if njm == 2, color("`col5'")) ///
(line aveldl_4_60 age if njm == 2, color("`col5'")) ///
, legend(order(1 "Control" ///
2 "Low/moderate intensity statins" ///
6 "High intensity statins" ///
10 "Low/moderate intensity statins and ezetimibe" ///
14 "Inclisiran") ///
cols(1) position(3) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Mean cumulative LDL-C (mmol/L)) xtitle(Age) xsize(10)
texdoc graph, label(aveLDLwithint) fontface("Liberation Sans") caption(Mean cumulative LDL-C with various interventions for 2 individuals)
texdoc stlog close

/***
\color{black}
Now it can be repeated for everyone under all 17 scenarios (16 interventions and 1 control):
\color{Blue4}
***/

texdoc stlog, cmdlog nodo
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*0.55 if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*0.55 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
preserve
bysort eid (age) : keep if _n == 1
gen agellt2 = min(agellt,agellt1)
keep eid agellt2
rename agellt2 agellt
replace agellt = round(agellt,0.1)
tostring agellt, force format(%9.1f) replace
destring agellt, replace
save LDLtraj/agellt_control_`a', replace
restore
keep eid sex ldl age njm ldl_0_30-ldl_0_60
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*0.6 if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*0.5 if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*0.45 if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*0.485 if age >= `i'
}
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')/10
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
}
}
keep eid sex age aveldl ///
aveldl_1_30 aveldl_1_40 aveldl_1_50 aveldl_1_60 ///
aveldl_2_30 aveldl_2_40 aveldl_2_50 aveldl_2_60 ///
aveldl_3_30 aveldl_3_40 aveldl_3_50 aveldl_3_60 ///
aveldl_4_30 aveldl_4_40 aveldl_4_50 aveldl_4_60
keep if age >= 30
tostring age, replace force format(%9.1f)
destring age, replace
merge m:1 sex age using ldlave_reg
drop if _merge == 2
drop _merge
merge m:1 sex age using MI_inc
drop if _merge == 2
drop _merge
rename rate nfMIrate
rename errr nfMIerrr
merge m:1 sex age using MIdrates
drop if _merge == 2
drop _merge MI
rename rate fMIrate
rename errr fMIerrr
sort eid age
save LDLtraj/LDL_trajectories_`a', replace
}
clear
forval a = 1(1000)458001 {
append using LDLtraj/agellt_control_`a'
}
save agellt_control, replace
forval a = 1(1000)458001 {
erase LDLtraj/agellt_control_`a'.dta
}
texdoc stlog close

/***
\color{black}

\clearpage
\pagebreak
\section{LDL-C--adjusted MI incidence}
\label{LDLAMI}

Now that LDL-C trajectories over the lifetime for everyone in the model population under all scenarios 
have been estimated, the incidence of MI at a given age, sex, and mean cumulative LDL-C can be estimated.

As mentioned above, the effect of LDL-C on CHD is summarised with the
odds ratio for CHD of 0.46 per mmol/L reduction in (lifetime) LDL-C \cite{FerenceJAMA2019}.
This needs to be converted into a relative risk before use in the model. 
This is done using the formula: 

\begin{quote}
\begin{math} 
RR = \frac{OR}{(1-P_0)+(P_0 \times OR)}
\end{math}
\end{quote}

where \begin{math} OR \end{math} is the odds ratio, 
\begin{math} RR \end{math} the relative risk, and 
\begin{math} P_0 \end{math} the risk of the outcome
in the unexposed group \cite{ZhangJAMA1998}. 

This yields a RR of:

\begin{quote}
\begin{math} 
\frac{0.46}{(1-0.064)+(0.064 \times 0.46)} = 0.48
\end{math}
\end{quote}

Which is the number that will be applied to estimate the relative risk for MI for the cohort using the following equation:

\begin{quote}
\begin{math} 
R_a = R \times 0.48^{(LDL_\mu-LDL_\tau)}
\end{math}
\end{quote}

where \begin{math} R_a \end{math} is the adjusted age-specific rate, 
\begin{math} R \end{math} the original age-specific rate (estimated in section~\ref{TPs}),
\begin{math} LDL_\mu \end{math} the mean cumulative LDL-C for UK Biobank 
sample at that given age (estimated in section~\ref{LDLtrajsection})
, and \begin{math} LDL_\tau \end{math} the mean cumulative LDL-C for 
the specific UK Biobank participant at that given age (estimated in section~\ref{LDLtrajsection}).

Note how this is the primary way disease biology is incorporated into the model--
the model uses cumulative LDL-C, not instantaneous LDL-C, to estimate the incidence of MI. 

To visualise the process, again just two people are used -- one with a very low LDL-C, the other very high
-- and just the high-intensity statin arm is displayed.

\color{Blue4}
***/

texdoc stlog, cmdlog do
use inferno, clear
local viri60 = var6[6]
local viri61 = var6[5]
local viri62 = var6[4]
local viri63 = var6[3]
local viri64 = var6[2]
use LDLtraj/LDL_trajectories_1, clear
keep if inrange(_n,345478,346579)
gen nfMIadj = nfMIrate*(0.48^(ldlave-aveldl))
gen fMIadj = fMIrate*(0.48^(ldlave-aveldl))
forval i = 1/4 {
forval ii = 30(10)60 {
gen nfMIadj_`i'_`ii' = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii' = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
}
}
twoway ///
(line nfMIadj age if inrange(_n,1,551), col("`viri60'") lpattern(dash)) ///
(line nfMIadj_2_60 age if inrange(_n,1,551), col("`viri61'") lpattern(dash)) ///
(line nfMIadj_2_50 age if inrange(_n,1,551), col("`viri62'") lpattern(dash)) ///
(line nfMIadj_2_40 age if inrange(_n,1,551), col("`viri63'") lpattern(dash)) ///
(line nfMIadj_2_30 age if inrange(_n,1,551), col("`viri64'") lpattern(dash)) ///
(line nfMIadj age if inrange(_n,552,1102), col("`viri60'")) ///
(line nfMIadj_2_60 age if inrange(_n,552,1102), col("`viri61'")) ///
(line nfMIadj_2_50 age if inrange(_n,552,1102), col("`viri62'")) ///
(line nfMIadj_2_40 age if inrange(_n,552,1102), col("`viri63'")) ///
(line nfMIadj_2_30 age if inrange(_n,552,1102), col("`viri64'")) ///
, legend(order(1 "Control" ///
2 "50% LDL-C reduction from age 60" ///
3 "50% LDL-C reduction from age 50" ///
4 "50% LDL-C reduction from age 40" ///
5 "50% LDL-C reduction from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Incidence of non-fatal MI (per person year)) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(nfMIincLDL1) fontface("Liberation Sans") caption(Incidence of non-fatal MI for 2 individuals by age of intervention)
twoway ///
(line fMIadj age if inrange(_n,1,551), col("`viri60'") lpattern(dash)) ///
(line fMIadj_2_60 age if inrange(_n,1,551), col("`viri61'") lpattern(dash)) ///
(line fMIadj_2_50 age if inrange(_n,1,551), col("`viri62'") lpattern(dash)) ///
(line fMIadj_2_40 age if inrange(_n,1,551), col("`viri63'") lpattern(dash)) ///
(line fMIadj_2_30 age if inrange(_n,1,551), col("`viri64'") lpattern(dash)) ///
(line fMIadj age if inrange(_n,552,1102), col("`viri60'")) ///
(line fMIadj_2_60 age if inrange(_n,552,1102), col("`viri61'")) ///
(line fMIadj_2_50 age if inrange(_n,552,1102), col("`viri62'")) ///
(line fMIadj_2_40 age if inrange(_n,552,1102), col("`viri63'")) ///
(line fMIadj_2_30 age if inrange(_n,552,1102), col("`viri64'")) ///
, legend(order(1 "Control" ///
2 "50% LDL-C reduction from age 60" ///
3 "50% LDL-C reduction from age 50" ///
4 "50% LDL-C reduction from age 40" ///
5 "50% LDL-C reduction from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Incidence of fatal MI (per person year)) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(fMIincLDL1) fontface("Liberation Sans") caption(Incidence of fatal MI for 2 individuals by age of intervention)
texdoc stlog close

/***
\color{black}
A couple of things to note. First, LDL-C influences risk of MI (hardly groundbreaking science); 
second, the benefit of LDL-C reduction depends heavily on timing of the intervention and baseline LDL-C. 
What about the difference between interventions? For this, let's just use the person with high LDL-C and
look at Low/moderate intensity vs. high-intensity statins.
\color{Blue4}
***/

texdoc stlog, cmdlog do
twoway ///
(line nfMIadj age if inrange(_n,552,1102), col("`viri60'")) ///
(line nfMIadj_2_60 age if inrange(_n,552,1102), col("`viri61'")) ///
(line nfMIadj_2_50 age if inrange(_n,552,1102), col("`viri62'")) ///
(line nfMIadj_2_40 age if inrange(_n,552,1102), col("`viri63'")) ///
(line nfMIadj_2_30 age if inrange(_n,552,1102), col("`viri64'")) ///
(line nfMIadj_1_60 age if inrange(_n,552,1102), col("`viri61'") lpattern(dash)) ///
(line nfMIadj_1_50 age if inrange(_n,552,1102), col("`viri62'") lpattern(dash)) ///
(line nfMIadj_1_40 age if inrange(_n,552,1102), col("`viri63'") lpattern(dash)) ///
(line nfMIadj_1_30 age if inrange(_n,552,1102), col("`viri64'") lpattern(dash)) ///
, legend(order(1 "Control" ///
6 "40% LDL-C reduction from age 60" ///
2 "50% LDL-C reduction from age 60" ///
7 "40% LDL-C reduction from age 50" ///
3 "50% LDL-C reduction from age 50" ///
8 "40% LDL-C reduction from age 40" ///
4 "50% LDL-C reduction from age 40" ///
9 "40% LDL-C reduction from age 30" ///
5 "50% LDL-C reduction from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Incidence of non-fatal MI (per person year)) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(nfMIincLDL2) fontface("Liberation Sans") caption(Incidence of non-fatal MI for 1 individual by intervention)
twoway ///
(line fMIadj age if inrange(_n,552,1102), col("`viri60'")) ///
(line fMIadj_2_60 age if inrange(_n,552,1102), col("`viri61'")) ///
(line fMIadj_2_50 age if inrange(_n,552,1102), col("`viri62'")) ///
(line fMIadj_2_40 age if inrange(_n,552,1102), col("`viri63'")) ///
(line fMIadj_2_30 age if inrange(_n,552,1102), col("`viri64'")) ///
(line fMIadj_1_60 age if inrange(_n,552,1102), col("`viri61'") lpattern(dash)) ///
(line fMIadj_1_50 age if inrange(_n,552,1102), col("`viri62'") lpattern(dash)) ///
(line fMIadj_1_40 age if inrange(_n,552,1102), col("`viri63'") lpattern(dash)) ///
(line fMIadj_1_30 age if inrange(_n,552,1102), col("`viri64'") lpattern(dash)) ///
, legend(order(1 "Control" ///
6 "40% LDL-C reduction from age 60" ///
2 "50% LDL-C reduction from age 60" ///
7 "40% LDL-C reduction from age 50" ///
3 "50% LDL-C reduction from age 50" ///
8 "40% LDL-C reduction from age 40" ///
4 "50% LDL-C reduction from age 40" ///
9 "40% LDL-C reduction from age 30" ///
5 "50% LDL-C reduction from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Incidence of fatal MI (per person year)) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(fMIincLDL2) fontface("Liberation Sans") caption(Incidence of fatal MI for 1 individual by intervention)
texdoc stlog close

/***
\color{black}
Repeat the process for everyone: 
\color{Blue4}
***/

texdoc stlog, cmdlog nodo
forval a = 1(1000)458001 {
use LDLtraj/LDL_trajectories_`a', clear
gen nfMIadj = nfMIrate*(0.48^(ldlave-aveldl))
gen fMIadj = fMIrate*(0.48^(ldlave-aveldl))
forval i = 1/4 {
forval ii = 30(10)60 {
gen nfMIadj_`i'_`ii' = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii' = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
}
}
keep eid sex age nfMIrate-fMIadj_4_60
forval i = 30(0.1)84.9 {
preserve
local ii = `i'-0.05
local iii = `i'+0.05
local iiii = round(`i'*10,1)
keep if inrange(age,`ii',`iii')
save MIrisk/MIrisk_`a'_`iiii', replace
restore
}
}
forval i = 30(0.1)84.99 {
clear
local ii = `i'-0.05
local iii = `i'+0.05
local iiii = round(`i'*10,1)
forval a = 1(1000)458001 {
append using MIrisk/MIrisk_`a'_`iiii'
}
save MIrisk/MIrisk_com_`iiii', replace
}
forval a = 1001(1000)458001 {
erase LDLtraj/LDL_trajectories_`a'.dta
}
forval a = 1(1000)458001 {
forval i = 30(0.1)84.99 {
local iiii = round(`i'*10,1)
erase MIrisk/MIrisk_`a'_`iiii'.dta
}
}
texdoc stlog close

/***
\color{black}

\clearpage
\pagebreak
\section{Microsimulation model}

At this point, everything required to construct the model has been estimated.

Recall the model structure (figure~\ref{Schematic1}).

\begin{figure}
    \centering
    \includegraphics[width=0.8\textwidth]{Model schematic.pdf}
    \caption{Model structure. Dashed lines are transition probabilities influenced by mean cumulative LDL-C; solid lines are transition probabilities not influenced by LDL-C.}
    \label{Schematic1}
\end{figure}

So far, the following have been estimated:
\begin{itemize}
\item Age- and sex-specific incidence of MI (fatal and non-fatal), 
adjusted for an individual's LDL-C trajectory over their lifetime
under different scenarios.
\item Age- and sex- non-CHD mortality for people without MI. 
\item Age-, sex-, and time-since-MI-specific mortality for people with MI. 
\end{itemize}

These can be used to simulate the UK Biobank cohort 
over their lifetime in a microsimulation model. 
The model starts at age 30 and runs to age 85, ageing in 0.1-year increments. 
All individuals start free of MI, and in each cycle are at risk for non-fatal MI, 
fatal MI/CHD death, and non-CHD death. Once a non-fatal MI has occurred, individuals are at risk for death. 
\emph{Repeat events are not tracked.}
For health economic analyses, the costs of repeat events will be assumed to be 
captured in the ongoing cost of managing MI. 

\subsection{First cycle in detail}

So, here I will first build the overall structure of the model.
Health economic outcomes will be added later on. 
The first cycle is explained in detail:

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
use MIrisk/MIrisk_com_300, clear
replace age = age*10
save MIrisk/MIrisk_com10_300, replace
texdoc stlog close
texdoc stlog, cmdlog
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
keep eid sex
gen age = 30
gen MI = 0
gen durn = 0
gen Death = 0
gen rand = 0
save Microsim_30o, replace
texdoc stlog close
texdoc stlog
list sex-rand in 1/10 , separator(0)
texdoc stlog close

/***
\color{black}

This is the starting structure of the model. (Note 
the \emph{eid} hasn't been listed for privacy reasons, but it is there,
and will be used for individual LDL-C trajectories/MI risk). Next
transition probabilities are merged in (well, rates are, then converted to 
transition probabilities):

\color{Blue4}
***/

texdoc stlog, cmdlog
merge 1:1 eid age using MIrisk/MIrisk_com_300
drop if _merge == 2
rename (nfMIadj fMIadj) (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates
drop if _merge == 2
rename rate NCd
drop errr-_merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
drop ratesum tpsum
sort eid
texdoc stlog close
texdoc stlog
list sex age nfMI fMI NCd in 1/10 , separator(0)
texdoc stlog close

/***
\color{black}

Note how the rate of MI is different for each person, 
but the non-CHD mortality is the same by sex.
Next, people are transitioned between states:

\color{Blue4}
***/

texdoc stlog
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
texdoc stlog close

/***
\color{black}

As expected, for people aged 30 the probability of 
an event or death is extremely low, so we don't see 
many transitions here. Just to show the mechanics of the model, the 
transition probabilities can be made higher:

\color{Blue4}
***/

texdoc stlog
preserve
replace nfMI = 0.3
replace fMI = 0.5
replace NCd = 0.5
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0 & MI == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
list sex-Death in 1/10 , separator(0)
restore
texdoc stlog close

/***
\color{black}

Also note the variable \emph{MI} is used to track
both non-fatal MI and coronary death. 
After events occur, the cohort is aged one cycle:

\color{Blue4}
***/

texdoc stlog, cmdlog
replace age = round(age+0.1,0.1) if Death == 0
replace durn = round(durn+0.1,0.1) if MI == 1 & Death == 0
drop nfMI-NCd
texdoc stlog close
texdoc stlog
list sex-Death in 1/10 , separator(0)
texdoc stlog close

/***
\color{black}

This can be repeated to age 85.
The only difference between these and the first cycle 
is that the population with MI is also aged,
but the principles are the same.
The populations are also saved at ages 40, 50, and 60 years
for use in the interventions later. 

\subsection{Full model}

Notice how seeds are set, this ensures the conditions for each simulation are 
exactly the same and thus, people serve directly as their own control for each intervention. 

Additionally, merging on numeric variables with decimals is not a good idea, because
they cannot be represented in binary, and so aren't always stored the same across datasets. 
Thus, I will first convert all ages/durations into integers to run the model.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
forval i = 300/849 {
use MIrisk/MIrisk_com_`i', clear
replace age = age*10
save MIrisk/MIrisk_com10_`i', replace
}
forval i = 301/849 {
erase MIrisk/MIrisk_com_`i'.dta
}
use NCdrates, clear
replace age = age*10
save NCdrates10, replace
use PMId, clear
replace age = age*10
replace durn = durn*10
save PMId10, replace
use Microsim_30o, clear
replace age = age*10
save Microsim_30, replace
quietly {
use Microsim_30, clear
set seed 6746
forval i = 300/849 {
merge 1:1 eid age using MIrisk/MIrisk_com10_`i'
drop if _merge == 2
rename (nfMIadj fMIadj) (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
drop nfMI-PMId
if `i' == 399 {
save Microsim_40, replace
set seed 2791
}
if `i' == 499 {
save Microsim_50, replace
set seed 9261
}
if `i' == 599 {
save Microsim_60, replace
set seed 1467
}
}
replace age = age/10
replace durn = durn/10
save trial_control, replace
}
texdoc stlog close
texdoc stlog, cmdlog
use trial_control, clear
sort eid
texdoc stlog close
texdoc stlog 
list sex-Death in 1/11 , separator(0)
texdoc stlog close

/***
\color{black}

Once run, it is also seen that all the information required
is saved at the end of the run (so events don't need to be tracked throughout)
-- because the model stops cycling people at death, the final dataset indicates 
the age people died, when and if they had an MI, and at what age. 
I.e., all the things necessary to track utilities and costs. 

\subsection{LDL-C adjustment check}

Before going further, it would be prudent to check that the method of adjusting 
CHD risk via LDL-C has not biased our results dramatically. This can be done
by comparing the results of the control simulation to one using the original
MI rates (i.e., those unadjusted for LDL-C):

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
use Microsim_30, clear
set seed 6746
forval i = 300/849 {
merge 1:1 eid age using MIrisk/MIrisk_com10_`i'
drop if _merge == 2
rename (nfMIrate fMIrate) (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
drop nfMI-PMId
if `i' == 399 {
set seed 2791
}
if `i' == 499 {
set seed 9261
}
if `i' == 599 {
set seed 1467
}
}
replace age = age/10
replace durn = durn/10
save trial_control_check, replace
}
texdoc stlog close
texdoc stlog
use trial_control, clear
ta MI
ta Death
ta MI Death
ta MI if sex == 0
ta MI if sex == 1
use trial_control_check, clear
ta MI
ta Death
ta MI Death
ta MI if sex == 0
ta MI if sex == 1
texdoc stlog close
texdoc stlog, cmdlog
use trial_control, clear
gen ageMI = round(age-durn,0.1) if MI == 1
hist ageMI, bin(1000) color(gs0) frequency graphregion(color(white)) ///
xtitle("Age of first MI or coronary death") ylabel(0(100)600) ///
title("Adjusted rates", placement(west) size(medium) color(gs0))
graph save "Graph" GPH/ageMI_00, replace
use trial_control_check, clear
gen ageMI = round(age-durn,0.1) if MI == 1
hist ageMI, bin(1000) color(gs0) frequency graphregion(color(white)) ///
xtitle("Age of first MI or coronary death") ylabel(0(100)600) ///
title("Original rates", placement(west) size(medium) color(gs0))
graph save "Graph" GPH/ageMI_01, replace
graph combine GPH/ageMI_00.gph GPH/ageMI_01.gph, altshrink cols(1) xsize(3) graphregion(color(white))
texdoc graph, label(ageMIcheck) fontface("Liberation Sans") caption(Age of MI or coronary death by method of estimating rates)
quietly {
use trial_control, clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_0 = (.,.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_0 = (A_0\0`i',100*r(N)/`N')
}
use trial_control_check, clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_1 = (.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_1 = (A_1\100*r(N)/`N')
}
}
use inferno, clear
local col1 = var3[3]
local col2 = var3[2]
clear
svmat double A_0
svmat double A_1
rename A_01 age
twoway ///
(line A_02 age, col("`col1'")) ///
(line A_11 age, col("`col2'")) ///
, legend(order(1 "Adjusted rates" ///
2 "Original rates") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI (%)) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(cumMIcheck) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death by method of estimating rates)
texdoc stlog close

/***
\color{black}

So the adjustment makes little difference, 
which means there is reassurance that the method
of adjusting rates is not \emph{very} wrong. 
It's also worth pointing out at this point that the lifetime risk 
of MI/coronary death under the control scenario is 
relatively consistent with the available literature,
although estimates of lifetime risk vary considerably depending on definitions 
(many were all CHD, not just MI and coronary death)
and country, but the estimate in the present study is higher than some 
\cite{RapsomanikiLancet2014,TurinCirc2010}
considerably lower than others \cite{BerryNEJM2012,LeeningBMJ2014},
and similar to one \cite{StenlingAth2020}. This is a bit surprising given
that UK Biobank is known to have an important "health volunteer" bias \cite{FryAJE2017}.
Thus, it is reassuring to know that the lifetime risk of MI 
does not appear to be massively under or over-estimated.  

\subsection{Interventions}

Now to simulate the interventions:

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
forval i = 1/4 {
forval ii = 30(10)60 {
if `ii' == 30 {
local a = 300
set seed 6746
}
if `ii' == 40 {
local a = 400
set seed 2791
}
if `ii' == 50 {
local a = 500
set seed 9261
}
if `ii' == 60 {
local a = 600
set seed 1467
}
use Microsim_`ii', clear
forval iii = `a'/849 {
merge 1:1 eid age using MIrisk/MIrisk_com10_`iii'
drop if _merge == 2
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii') (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
drop nfMI-PMId
}
replace age = age/10
replace durn = durn/10
save trial_`i'_`ii', replace
}
}
}
forval iii = 300/849 {
erase MIrisk/MIrisk_com10_`iii'.dta
}
texdoc stlog close

/***
\color{black}

\subsection{Lifetime risk of MI}

And to plot the lifetime risk of MI under all conditions:

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
use trial_control, clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_0 = (.,.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_0 = (A_0\0`i',100*r(N)/`N')
}
forval a = 1/4 {
forval b = 30(10)60 {
use trial_`a'_`b', clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_`a'_`b' = (.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_`a'_`b' = (A_`a'_`b'\100*r(N)/`N')
}
}
}
}
clear
svmat double A_0
svmat double A_1_30
svmat double A_1_40
svmat double A_1_50
svmat double A_1_60
svmat double A_2_30
svmat double A_2_40
svmat double A_2_50
svmat double A_2_60
svmat double A_3_30
svmat double A_3_40
svmat double A_3_50
svmat double A_3_60
svmat double A_4_30
svmat double A_4_40
svmat double A_4_50
svmat double A_4_60
rename A_01 age
save CumMIfig_overall, replace
texdoc stlog close
texdoc stlog, cmdlog
use viridis, clear
local viri60 = var6[6]
local viri61 = var6[5]
local viri62 = var6[4]
local viri63 = var6[3]
local viri64 = var6[2]
forval a = 1/4 {
if `a' == 1 {
local aa = "Low/moderate intensity statins"
}
if `a' == 2 {
local aa = "High intensity statins"
}
if `a' == 3 {
local aa = "Low/moderate intensity statins and ezetimibe"
}
if `a' == 4 {
local aa = "Inclisiran"
}
use CumMIfig_overall, clear
preserve
tostring _all, force format(%9.1f) replace
local p0 = A_02[552]
local p1 = A_`a'_301[552]
local p2 = A_`a'_401[552]
local p3 = A_`a'_501[552]
local p4 = A_`a'_601[552]
restore
twoway ///
(line A_02 age, col("`viri60'")) ///
(line A_`a'_601 age, col("`viri61'")) ///
(line A_`a'_501 age, col("`viri62'")) ///
(line A_`a'_401 age, col("`viri63'")) ///
(line A_`a'_301 age, col("`viri64'")) ///
, legend(order(1 "Control" ///
2 "Intervention from age 60" ///
3 "Intervention from age 50" ///
4 "Intervention from age 40" ///
5 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(,angle(0)) xscale(range(30 90)) ///
text(`p0' 86 "`p0'", color(black) placement(east)) ///
text(`p1' 86 "`p1'", color(black) placement(east)) ///
text(`p2' 86 "`p2'", color(black) placement(east)) ///
text(`p3' 86 "`p3'", color(black) placement(east)) ///
text(`p4' 86 "`p4'", color(black) placement(east)) ///
title("`aa'", placement(west) col(black) size(medium))
graph save "Graph" GPH/cumMIfigoverall_`a', replace
}
graph combine ///
GPH/cumMIfigoverall_1.gph ///
GPH/cumMIfigoverall_2.gph ///
GPH/cumMIfigoverall_3.gph ///
GPH/cumMIfigoverall_4.gph ///
, altshrink graphregion(color(white)) cols(2)
texdoc graph, label(cumMIint) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death by intervention)
texdoc stlog close

/***
\color{black}

It can be seen from figure~\ref{cumMIint} that earlier and more aggressive lowering of LDL-C is
clearly a better strategy for the prevention of MI and coronary death. 

\subsection{Utilities and costs}

The question now is whether the extra decades of treatment are justified
from a cost-effectiveness perspective. To assess this, the
incremental cost-effectiveness ratio (ICER; from the UK healthcare perspective) will be calculated, 
which requires calculating the incremental quality-adjusted life years (QALYs)
and incremental healthcare costs. To do this, the following inputs are used:

\begin{itemize}
\item Utility values for people without MI in the UK, set using the following equation: 
\begin{math} 0.9454933 + 0.0256466*male - 0.0002213*age - 0.0000294*age^2 \end{math}
, derived from Ara and Brazier \cite{ARAVIH2010}, 
which appears to be a standard for health economic analyses in the UK. 
\item Utility values for people with MI, set at 0.79 (95\%CI 0.73, 0.85), 
derived from a systematic review of utility values in CVD \cite{BettsHQLO2020}. 
People with MI also incurred an acute disutility associated with the initial MI, which was set at 0.12 \cite{LewisJACCHF2014}
and applied for 3 months, for a final acute disutility of 0.03 per year in the year the event occured in. 
\item Cost of acute MI in the UK, set at \textsterling 2047.31. This is derived directly from the National Health
Service Cost Schedule for 2020/21 (\cite{NHSCOST202021}). 
See Table~\ref{ACUTEMICOST} for details. 
\item Excess chronic costs of managing MI (including subsequent events) in the UK. This is set at 
\textsterling 4705.45 (Standard error (SE): 112.71) for the first 6 months, and \textsterling 1015.21 
(SE: 171.23) per year thereafter (values adjusted from 2014 \textsterling to 2021 \textsterling using the NHS cost inflation index 
(from: \cite{NHSinflation2021}, which was a mean of 1.38\% from 2014-2021; 
thus the conversion formula was \begin{math} cost_{2014} \times 1.0138^7 \end{math}). 
These values were derived from a cohort study using
the Clinical Practice Research Datalink in the UK \cite{DaneseeBMJO2016} 
(the original unadjusted values: 4275.41 (SE: 102.41) and \textsterling 922.43 (SE: 155.58)). 
\item The average annual cost of statins in the UK, for the control arm. This is set at \textsterling 19.00, derived directly from 
the NHS Drug Tariff data \cite{NHSDrugTariff}, with the distribution of statin use derived from the English Prescribing Dataset in
June 2021 \cite{NHSEPD} (see below for details on how this was calculated).
\item The cost of low/moderate intensity statins. As above, the most common in this class was Atorvastatin 20mg, which also
happens to be the most expensive in the NHS drug tariff (out of Atorvastatin 10mg and 20mg, and Simvastatin 20mg and 40mg),
and is thus the most conservative, at a price of \textsterling 1.41 per 28 tablets, which leads to an annual cost of 
\begin{math} \frac{1.41}{28} \times 365.25 = \end{math} \textsterling 18.39
\item The cost of high intensity statins. As above, the most common in this class was Atorvastatin 40mg, but
to be conservative, it's best to use the price of Atorvastatin 80mg, which has a packet cost of \textsterling 2.10, leading
to an annual cost of \begin{math} \frac{2.10}{28} \times 365.25 = \end{math} \textsterling 27.39
\item The cost of low/moderate intensity statins and ezetimibe. The cost of a packet of 28 ezetimibe (10mg) tablets
is \textsterling 2.37, leading to an annual cost of 
\begin{math} \frac{2.37}{28} \times 365.25 = \end{math} \textsterling 30.92, which we can add to the annual cost of
low-moderate intensity statins used above for an annual cost of 
\begin{math} 18.39+30.92 = \end{math} \textsterling 49.31
\item The cost of Inclisiran. This wasn't available on the drug tariff in June 2021, but is available under a special agreement 
at a price of \textsterling 1987.36 per injection \cite{NHSDMDInclisiran2022}, leading to an annual cost of 
\begin{math} 1987.36 \times 2 = \end{math}  \textsterling 3,974.72.
This is very high, probably because Inclisiran is currently
only indicated for very high-risk people. Thus, the price at which it is cost-effective for primary prevention is probably going
to be considerably lower than in these high-risk populations. As such, later on, I will run threshold analyses later to determine
the maximum cost at which Inclisiran is cost-effective in the primary prevention setting (with considerable confidence in my
assumption that it won't be cost-effective at this price). 
\end{itemize}

The ICERs calculated here will be compared to the The U.K. National Institute for Health and Care Excellence (NICE) 
willingness-to-pay threshold, which is a range -- \textsterling 20,000 to  \textsterling 30,000
per QALY \cite{NICEHTA2013}. 

These cost-effectiveness analyses will also require the following assumptions:
\begin{itemize}
\item 18\% of all fatal MI's occur in hospital (and therefore accrue 18\% of the cost
of a non-fatal MI; see below for details).
\item The interventions continue after an MI, and add to the ongoing costs of management.
\item Similarly, statin use is initiated after an MI for everyone in the control arm, adding to the ongoing cost of management. 
\item Discounting starts from the age of intervention (meaning the control scenario
QALYs and costs will vary depending on the intervention). The discounting rate in the primary analysis
will be 3.5\%, as recommended by NICE \cite{NICEHTA2013}.
\end{itemize}

\begin{table}[h!]
  \begin{center}
    \caption{Calculation of acute MI costs}
    \label{ACUTEMICOST}
     \fontsize{7pt}{9pt}\selectfont\pgfplotstabletypeset[
      col sep=comma,
      header=false,
      string type,
      display columns/0/.style={column name=Code, column type={l}, text indicator="},
      display columns/1/.style={column name=Description, column type={l}},
      display columns/2/.style={column name=Number, column type={r}},
      display columns/3/.style={column name=Unit cost (\textsterling), column type={r}},
	  display columns/4/.style={column name=Weighted mean (\textsterling),
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{5}{*}{##1}}}},
      every head row/.style={
        before row={\toprule},
        after row={\midrule}
            },
        every last row/.style={after row=\bottomrule},
    ]{ACUTEMICOST.csv}
  \end{center}
\end{table}

How annual statin cost was arrived at (the source of the 18\% follows this):

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
forval i = 1(1000000)18000000 {
append using statins2021/st_`i'
}
texdoc stlog close
texdoc stlog
preserve
collapse (sum) item, by(AA)
list
ta AA [aweight=item]
restore
collapse (sum) items, by(bnf_description)
ta bnf_description [weight=items]
texdoc stlog close
texdoc stlog, cmdlog
egen A = sum(items)
gen prop = items/A
matrix B = ( ///
30, 1380 \ ///
28, 101 \ ///
0, 0 \ ///
30, 2640 \ ///
28, 141 \ ///
0, 0 \ ///
0, 0 \ ///
28, 2451 \ ///
28, 150 \ ///
28, 2801 \ ///
28, 210 \ ///
28, 418 \ ///
28, 512 \ ///
28, 1920 \ ///
28, 124 \ ///
28, 146 \ ///
28, 184 \ ///
0, 0 \ ///
0, 0 \ ///
28, 169 \ ///
28, 202 \ ///
28, 253 \ ///
28, 145 \ ///
28, 115 \ ///
28, 3342 \ ///
28, 113 \ ///
0, 0 \ ///
28, 3898 \ ///
28, 130 \ ///
0, 0 \ ///
28, 4121 \ ///
28, 174)
svmat B
gen dcost = (B2/100)/B1
gen cost = prop*dcost
texdoc stlog close
texdoc stlog
list, separator(0)
su(cost)
di r(sum)
di r(sum)*365.25
texdoc stlog close

/***
\color{black}

The source of the 18\%:

\color{Blue4}
***/

texdoc stlog, cmdlog
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
gen faildate = td(30,9,2021) if ubc == "England"
replace faildate = td(31,7,2021) if ubc == "Scotland"
replace faildate = td(28,2,2018) if ubc == "Wales"
replace faildate = min(dod,mid,faildate)
gen MIfail = 1 if dod==faildate & mid == dod
replace MIfail = 1 if mid==faildate & inrange(dod-mid,0,14)
replace MIfail = 1 if chd==1 & dod==faildate
count if MIfail == 1 & (mis == "11" | mis == "21")
local A = r(N)
count if MIfail == 1
local B = r(N)
texdoc stlog close
texdoc stlog
di 100*`A'/`B'
texdoc stlog close

/***
\color{black}

With all this, the matrices/datasets for utilities and costs can be created:

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen YLLn_`i'=0.1*DC_`i'
replace YLLn_`i' = YLLn_`i'/2 if age == `i'
sort age
gen double YLL_`i' = sum(YLLn_`i')
}
keep age YLL_30 YLL_40 YLL_50 YLL_60
tostring age, replace force format(%9.1f)
destring age, replace
save YLL_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
age == 30 | ///
age == 40 | ///
age == 50 | ///
age == 60 | ///
age == 70 | ///
age == 80 | ///
age == 85 ///
, separator(0)
texdoc stlog close

/***
\color{black}

This is a matrix that has cumulative YLL a a given age, 
depending on the age the intervention is started,
ready to merge into the microsimulation model results. 
It can already be seen how impactful discounting will be
on our results -- someone only accrues 24.7 YLL
if they survive from 30 to 85. 

Let's include utilities to make these QALYs:

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
twoway ///
(line UT MIage if sex == 0, color(red)) ///
(line UT MIage if sex == 1, color(blue)) ///
, legend(order(2 "Male" ///
1 "Female") ///
cols(1) ring(0) position(1) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Utility) xtitle(Age) ///
ylabel(,angle(0))
texdoc graph, label(AgeUT) fontface("Liberation Sans") caption(Age and sex-specific utility for people without MI)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen QAL_`i'=0.1*UT*DC_`i'
replace QAL_`i' = QAL_`i'/2 if MIage == `i'
bysort sex (MIage) : gen double QALY_nMI_`i' = sum(QAL_`i')
}
keep MIage sex QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save QALY_nMI_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
MIage == 30 | ///
MIage == 40 | ///
MIage == 50 | ///
MIage == 60 | ///
MIage == 70 | ///
MIage == 80 | ///
MIage == 85 ///
, separator(0)
texdoc stlog close

/***
\color{black}

This is a matrix that has cumulative QALYs for 
any given age before development of MI (i.e., cumulative QALYs
for the alive without MI health state). The same is done for time spent with MI
, assuming no effect of MI duration on utilities, just age:

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
gen UT = 0.9454933+0.0256466*sex-0.0002213*age - 0.0000294*(age^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen QAL_`i'=0.1*UT*DC_`i'*0.79
replace QAL_`i' = QAL_`i' - 0.01 if durn <0.301
replace QAL_`i' = 0 if QAL_`i' < 0
bysort sex MIage (age) : gen double QALY_MI_`i' = sum(QAL_`i')
}
keep age MIage sex QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save QALY_MI_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
(MIage== 30 & age == 30) | ///
(MIage== 30 & age == 40) | ///
(MIage== 30 & age == 50) | ///
(MIage== 30 & age == 60) | ///
(MIage== 30 & age == 70) | ///
(MIage== 30 & age == 80) | ///
(MIage== 30 & age == 85) ///
, separator(0)
texdoc stlog close

/***
\color{black}

Next is a cost matrix for acute MI, with the only variation in 
cost coming from discounting reflecting the age at MI (and thus time since 
intervention). 

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen MIage = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen double ACMIcost_`i' = 2047.31*DC_`i'
}
keep MIage ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save ACcost_Matrix, replace
texdoc stlog close
list if ///
MIage == 30 | ///
MIage == 40 | ///
MIage == 50 | ///
MIage == 60 | ///
MIage == 70 | ///
MIage == 80 | ///
MIage == 85 ///
, separator(0)
texdoc stlog close

/***
\color{black}

And also chronic costs of MI:

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*4705.45/5 if durn <=0.5
replace cost_`i' = DC_`i'*1015.21/10 if cost_`i'==.
bysort sex MIage (age) : gen double CHMIcost_`i' = sum(cost_`i')
}
keep age MIage sex CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save CHcost_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
(MIage== 30 & age == 40) | ///
(MIage== 30 & age == 50) | ///
(MIage== 40 & age == 45) | ///
(MIage== 50 & age == 65) | ///
(MIage== 50 & age == 80) ///
, separator(0)
texdoc stlog close


/***
\color{black}

And finally, annual drug costs. 
This is straightforward for the interventions, but is trickier for the control, 
as everyone starts therapy at a different time (for primary prevention), and then 
everyone initiates LLT following an MI. 
The way to do this is have two matrices; one for primary prevention statin costs 
(that can be recoded to 0 for people without LLT later on) and post-MI statin costs 
(applied to everyone with MI in the control arm). 

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 551
gen agellt = round((_n+299)/10,0.1)
expand 551
bysort age : gen MIage = round(age+((_n-1)/10),0.1)
drop if MIage > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen cost = DC_`i'*1.9
bysort agellt (MIage) : gen double STcost_`i' = sum(cost) if MIage >= `i'
drop cost
}
keep agellt MIage STcost_30 STcost_40 STcost_50 STcost_60
tostring agellt MIage, replace force format(%9.1f)
destring agellt MIage, replace
save STcost_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
(MIage== 50 & agellt == 40) | ///
(MIage== 50 & agellt == 50) | ///
(MIage== 60 & agellt == 45) | ///
(MIage== 70 & agellt == 65) | ///
(MIage== 80 & agellt == 80) ///
, separator(0)
texdoc stlog close
texdoc stlog, cmdlog
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*19/10
bysort sex MIage (age) : gen double CHSTcost_`i' = sum(cost_`i')
}
keep age MIage sex CHSTcost_30 CHSTcost_40 CHSTcost_50 CHSTcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save CHSTcost_Matrix, replace
texdoc stlog close
texdoc stlog
list if ///
(MIage== 30 & age == 40) | ///
(MIage== 30 & age == 50) | ///
(MIage== 40 & age == 45) | ///
(MIage== 50 & age == 65) | ///
(MIage== 50 & age == 80) ///
, separator(0)
texdoc stlog close
texdoc stlog, cmdlog
forval a = 1/4 {
if `a' == 1 {
local aa = 18.39
}
if `a' == 2 {
local aa = 27.39
}
if `a' == 3 {
local aa = 49.31
}
if `a' == 4 {
local aa = 3974.72
}
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen cost = DC_`i'*`aa'/10
gen double MDcost_`i' = sum(cost)
drop cost
}
keep age MDcost_30 MDcost_40 MDcost_50 MDcost_60
tostring age, replace force format(%9.1f)
destring age, replace
save INTcost_Matrix_`a', replace
}
texdoc stlog close
texdoc stlog
forval a = 1/4 {
use INTcost_Matrix_`a', clear
list age MDcost_30 MDcost_40 MDcost_50 MDcost_60 if ///
(age == 30) | ///
(age == 40) | ///
(age == 50) | ///
(age == 60) | ///
(age == 70) | ///
(age == 80) ///
, separator(0)
}
texdoc stlog close


/***
\color{black}

\subsection{Health economic analysis}

With all the utility and cost matrices, all the relevant results from each simulation
can be calculated. Note that values are only counted from intervention start, despite the simulations
all starting from age 30.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
use trial_control, clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using agellt_control
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
use trial_`ii'_`i', clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save reshof0, replace
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*D1/A3
gen P2 = 100*D2/A3
gen P3 = 100*D3/A3
gen P4 = 100*D4/A3
tostring A3-D4, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
replace D1 = D1 + " (" + P1 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D2 = D2 + " (" + P2 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D3 = D3 + " (" + P3 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D4 = D4 + " (" + P4 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D1 = D1 + " (" + p1 + "\%)" if A2 == 4 | A2 == 5
replace D2 = D2 + " (" + p2 + "\%)" if A2 == 4 | A2 == 5
replace D3 = D3 + " (" + p3 + "\%)" if A2 == 4 | A2 == 5
replace D4 = D4 + " (" + p4 + "\%)" if A2 == 4 | A2 == 5
save reshof, replace
preserve
keep A00 A0 A3 A4 D1
export delimited using CSV/Res_HOF_1.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A5 D2
export delimited using CSV/Res_HOF_2.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A6 D3
export delimited using CSV/Res_HOF_3.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A7 D4
export delimited using CSV/Res_HOF_4.csv, delimiter(":") novarnames replace
restore
use reshof, clear
replace A00 = A00[_n-1] if A2 == 2
keep if A2 == 2 | A2 == 5 | A2 == 9 | A2 == 10
drop A1-A7 P1-p4
export delimited using CSV/Res_HOF.csv, delimiter(":") novarnames replace
texdoc stlog close

/***
\color{black}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins}
    \label{Microsim1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins}
    \label{Microsim2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe}
    \label{Microsim3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran}
    \label{Microsim4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4.csv}
  \end{center}
\end{table}

\clearpage

Or, a simpler table to summarise the results: 

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Summary of all interventions. All results shown are the difference between the intervention and control.}
    \label{Microsim5}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= \specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}},
      display columns/3/.style={column name=High intensity statins, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}},
      display columns/5/.style={column name=Inclisiran, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF.csv}
  \end{center}
\end{table}

\clearpage

So, it appears that all statin/ezetimibe interventions are cost-effective, but
Inclisiran is not even close at current prices. 
Nevertheless, all interventions come at a major cost -- even if statins are very cheap, 
giving them to the entire population across most of their lifespan makes this a very
expensive public health intervention. Moreover, 
it's likely that the cost-effectiveness will be significnatly
different among different population groups (most notably by sex and LDL-C). 
Therefore, it's probably wise to target this intervention to people most 
likely to benefit -- from here, I will stratify the results by sex 
and LDL-C ($\geq$3.0, $\geq$4.0, and $\geq$5.0 mmol/L).

\subsection{Stratified by sex and LDL-C}

First, I'll present the mean and median (IQR) values of LDL-C in these groups by 
sex to match the more common way of presenting model populations 
(Table~\ref{mldltab}). 



\begin{table}[h!]
  \begin{center}
    \caption{Mean; median (IQR) LDL-C by stratification group.}
    \label{mldltab}
     \selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Sex,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=LDL-C (mmol/L), column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= Mean; median (IQR), column type={r}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/mldl.csv}
  \end{center}
\end{table}


\color{Blue4}
***/

texdoc stlog, cmdlog nodo
use UKB_working, clear
keep eid ldl
save UKBldl, replace
use trial_control, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
matrix A = (.,.,.,.,.,.)
forval s = 0/1 {
foreach l in 0 3 4 5 {
su ldl if ldl >= `l' & sex == `s', detail
mat A = (A\0`s',`l',r(mean), r(p50),r(p25),r(p75))
}
}
clear
svmat A
drop if _n == 1
tostring A3-A6, replace force format(%9.2f)
gen A = A3 + "; " + A4 + " (" + A5 + ", " + A6 + ")"
tostring A1 A2, replace force format(%9.1f)
bysort A1 (A2) : replace A1 ="" if _n!=1
replace A2 = "$\geq$" + A2
replace A2 = "Overall" if A2 == "$\geq$0.0"
replace A1 = "Females" if A1 == "0.0"
replace A1 = "Males" if A1 == "1.0"
keep A1 A2 A
export delimited using CSV/mldl.csv, delimiter(":") novarnames replace
quietly {
forval s = 0/1 {
foreach l in 0 3 4 5 {
use trial_control, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_0 = (.,.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_0 = (A_0\0`i',100*r(N)/`N')
}
forval a = 1/4 {
forval b = 30(10)60 {
use trial_`a'_`b', clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_`a'_`b' = (.)
forval i = 30(0.1)85 {
count if ageMI < `i'+0.05
matrix A_`a'_`b' = (A_`a'_`b'\100*r(N)/`N')
}
}
}
clear
svmat double A_0
svmat double A_1_30
svmat double A_1_40
svmat double A_1_50
svmat double A_1_60
svmat double A_2_30
svmat double A_2_40
svmat double A_2_50
svmat double A_2_60
svmat double A_3_30
svmat double A_3_40
svmat double A_3_50
svmat double A_3_60
svmat double A_4_30
svmat double A_4_40
svmat double A_4_50
svmat double A_4_60
rename A_01 age
save CumMIfig_sex_`s'_LDL`l', replace
}
}
}
quietly {
forval s = 0/1 {
if `s' == 0 {
local sex = "Females"
use inferno, clear
local col1 = var6[6]
local col2 = var6[5]
local col3 = var6[4]
local col4 = var6[3]
local col5 = var6[2]
}
else {
local sex = "Males"
use viridis, clear
local col1 = var6[6]
local col2 = var6[5]
local col3 = var6[4]
local col4 = var6[3]
local col5 = var6[2]
}
foreach l in 0 3 4 5 {
if `l' > 1 {
local ldl = ", LDL-C ≥ `l'.0 mmol/L"
}
else {
local ldl = ""
}
use CumMIfig_sex_`s'_LDL`l', clear
forval a = 1/4 {
preserve
tostring _all, force format(%9.1f) replace
local p0 = A_02[552]
local p1 = A_`a'_301[552]

restore
twoway ///
(line A_02 age, col("`col1'")) ///
(line A_`a'_601 age, col("`col2'")) ///
(line A_`a'_501 age, col("`col3'")) ///
(line A_`a'_401 age, col("`col4'")) ///
(line A_`a'_301 age, col("`col5'")) ///
, legend(order(1 "Control" ///
2 "Intervention from age 60" ///
3 "Intervention from age 50" ///
4 "Intervention from age 40" ///
5 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(0(10)50, angle(0)) yscale(range(0 50)) xscale(range(30 90)) ///
text(`p0' 86 "`p0'", color(black) placement(east)) ///
text(`p1' 86 "`p1'", color(black) placement(east)) ///
title("`sex'`ldl'", placement(west) color(black) size(medium))
graph save "Graph" GPH/cumMI_`a'_sex_`s'_LDL_`l', replace
}
}
}
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/cumMI_1_sex_0_LDL_0.gph ///
GPH/cumMI_1_sex_1_LDL_0.gph ///
GPH/cumMI_1_sex_0_LDL_3.gph ///
GPH/cumMI_1_sex_1_LDL_3.gph ///
GPH/cumMI_1_sex_0_LDL_4.gph ///
GPH/cumMI_1_sex_1_LDL_4.gph ///
GPH/cumMI_1_sex_0_LDL_5.gph ///
GPH/cumMI_1_sex_1_LDL_5.gph ///
, altshrink cols(2) graphregion(color(white)) xsize(3.5)
texdoc graph, label(cumMIint00) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death ///
by age of intervention, sex, and LDL-C -- low/moderate intensity statins)
graph combine ///
GPH/cumMI_2_sex_0_LDL_0.gph ///
GPH/cumMI_2_sex_1_LDL_0.gph ///
GPH/cumMI_2_sex_0_LDL_3.gph ///
GPH/cumMI_2_sex_1_LDL_3.gph ///
GPH/cumMI_2_sex_0_LDL_4.gph ///
GPH/cumMI_2_sex_1_LDL_4.gph ///
GPH/cumMI_2_sex_0_LDL_5.gph ///
GPH/cumMI_2_sex_1_LDL_5.gph ///
, altshrink cols(2) graphregion(color(white)) xsize(3.5)
texdoc graph, label(cumMIint00) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death ///
by age of intervention sex, and LDL-C -- high intensity statins)
graph combine ///
GPH/cumMI_3_sex_0_LDL_0.gph ///
GPH/cumMI_3_sex_1_LDL_0.gph ///
GPH/cumMI_3_sex_0_LDL_3.gph ///
GPH/cumMI_3_sex_1_LDL_3.gph ///
GPH/cumMI_3_sex_0_LDL_4.gph ///
GPH/cumMI_3_sex_1_LDL_4.gph ///
GPH/cumMI_3_sex_0_LDL_5.gph ///
GPH/cumMI_3_sex_1_LDL_5.gph ///
, altshrink cols(2) graphregion(color(white)) xsize(3.5)
texdoc graph, label(cumMIint00) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death ///
by age of intervention, sex, and LDL-C -- low/moderate intensity statins and ezetimibe)
graph combine ///
GPH/cumMI_4_sex_0_LDL_0.gph ///
GPH/cumMI_4_sex_1_LDL_0.gph ///
GPH/cumMI_4_sex_0_LDL_3.gph ///
GPH/cumMI_4_sex_1_LDL_3.gph ///
GPH/cumMI_4_sex_0_LDL_4.gph ///
GPH/cumMI_4_sex_1_LDL_4.gph ///
GPH/cumMI_4_sex_0_LDL_5.gph ///
GPH/cumMI_4_sex_1_LDL_5.gph ///
, altshrink cols(2) graphregion(color(white)) xsize(3.5)
texdoc graph, label(cumMIint00) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death ///
by age of intervention, sex, and LDL-C -- inclisiran)
texdoc stlog close

/***
\color{black}

\clearpage

Indeed, stratification was a good idea - the relative risk reductions are pretty much identical
for each group, but the absolute risk reductions are higher in males and increase with increasing
LDL-C (\emph{``and with greater absolute risk reduction comes greater cost-effectiveness'' -- Uncle Ben, probably}). 
Let's also generate the full results table by sex and LDL-C: 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
forval s = 0/1 {
foreach l in 0 3 4 5 {
use trial_control, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if sex == `s'
keep if ldl >= `l'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using agellt_control
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
use trial_`ii'_`i', clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if sex == `s'
keep if ldl >= `l'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save reshof0_sex_`s'_ldl_`l', replace
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*D1/A3
gen P2 = 100*D2/A3
gen P3 = 100*D3/A3
gen P4 = 100*D4/A3
tostring A3-D4, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
replace D1 = D1 + " (" + P1 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D2 = D2 + " (" + P2 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D3 = D3 + " (" + P3 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D4 = D4 + " (" + P4 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D1 = D1 + " (" + p1 + "\%)" if A2 == 4 | A2 == 5
replace D2 = D2 + " (" + p2 + "\%)" if A2 == 4 | A2 == 5
replace D3 = D3 + " (" + p3 + "\%)" if A2 == 4 | A2 == 5
replace D4 = D4 + " (" + p4 + "\%)" if A2 == 4 | A2 == 5
save reshof_sex_`s'_ldl_`l', replace
preserve
keep A00 A0 A3 A4 D1
export delimited using CSV/Res_HOF_1_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A5 D2
export delimited using CSV/Res_HOF_2_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A6 D3
export delimited using CSV/Res_HOF_3_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A7 D4
export delimited using CSV/Res_HOF_4_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
use reshof_sex_`s'_ldl_`l', clear
replace A00 = A00[_n-1] if A2 == 2
keep if A2 == 2 | A2 == 5 | A2 == 9 | A2 == 10
drop A1-A7 P1-p4
rename (D1-D4) (D1_`l' D2_`l' D3_`l' D4_`l')
save Res_HOF_sex_`s'_ldl_`l', replace
}
}
use Res_HOF_sex_1_ldl_0, clear
merge 1:1 _n using Res_HOF_sex_1_ldl_3
drop _merge
merge 1:1 _n using Res_HOF_sex_1_ldl_4
drop _merge
merge 1:1 _n using Res_HOF_sex_1_ldl_5
drop _merge
save Res_HOF_sex_1, replace
use Res_HOF_sex_0_ldl_0, clear
merge 1:1 _n using Res_HOF_sex_0_ldl_3
drop _merge
merge 1:1 _n using Res_HOF_sex_0_ldl_4
drop _merge
merge 1:1 _n using Res_HOF_sex_0_ldl_5
drop _merge
append using Res_HOF_sex_1
gen A000 = "Females" if _n == 1
replace A000 = "Males" if _n == 17
order A000
save Res_HOF_sexldl, replace
forval a = 1/4 {
use Res_HOF_sexldl, clear
keep A000 A00 A0 D`a'_0 D`a'_3 D`a'_4 D`a'_5
export delimited using CSV/Res_HOF_sexldl_`a'.csv, delimiter(":") novarnames replace
}
}
texdoc stlog close

/***
\color{black}

So, definitely too many results, but I will display them anyway for completeness. 
Go to the last 4 tables for a summary (table~\ref{Microsimintsum1} - ~\ref{Microsimintsum4}).

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Females.}
    \label{Microsimsex0int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Males.}
    \label{Microsimsex1int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Females with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex0ldl3int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Males with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex1ldl3int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Females with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex0ldl4int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Males with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex1ldl4int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Females with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex0ldl5int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Males with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex1ldl5int1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_sex_1_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Females.}
    \label{Microsimsex0int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Males.}
    \label{Microsimsex1int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Females with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex0ldl3int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Males with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex1ldl3int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Females with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex0ldl4int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Males with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex1ldl4int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Females with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex0ldl5int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Males with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex1ldl5int2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_sex_1_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Females.}
    \label{Microsimsex0int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Males.}
    \label{Microsimsex1int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Females with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex0ldl3int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Males with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex1ldl3int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Females with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex0ldl4int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Males with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex1ldl4int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Females with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex0ldl5int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Males with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex1ldl5int3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_sex_1_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Females.}
    \label{Microsimsex0int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Males.}
    \label{Microsimsex1int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Females with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex0ldl3int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Males with an LDL-C $\geq$3.0 mmol/L.}
    \label{Microsimsex1ldl3int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Females with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex0ldl4int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Males with an LDL-C $\geq$4.0 mmol/L.}
    \label{Microsimsex1ldl4int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Females with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex0ldl5int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Males with an LDL-C $\geq$5.0 mmol/L.}
    \label{Microsimsex1ldl5int4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_sex_1_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Summary.}
    \label{Microsimintsum1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{16}{*}{##1}}}},
	  display columns/1/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/2/.style={column name=, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=Overall, column type={r}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Sex} & \multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\cmidrule{2-7}},
        every nth row={16}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_sexldl_1.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Summary.}
    \label{Microsimintsum2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{16}{*}{##1}}}},
	  display columns/1/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/2/.style={column name=, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=Overall, column type={r}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Sex} & \multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\cmidrule{2-7}},
        every nth row={16}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_sexldl_2.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Summary.}
    \label{Microsimintsum3}
    \hspace*{-1.25cm}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{16}{*}{##1}}}},
	  display columns/1/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/2/.style={column name=, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=Overall, column type={r}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Sex} & \multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\cmidrule{2-7}},
        every nth row={16}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_sexldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Summary.}
    \label{Microsimintsum4}
    \hspace*{-2.00cm}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{16}{*}{##1}}}},
	  display columns/1/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/2/.style={column name=, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=Overall, column type={r}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Sex} & \multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\cmidrule{2-7}},
        every nth row={16}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_sexldl_4.csv}
  \end{center}
\end{table}

\clearpage




\pagebreak
\section{One-way sensitivity analyses}

To get any sort of confidence in the results just obtained, they need to subjected to sensitivity analyses. 
Table~\ref{inputtable} contains all inputs to the model, and thus all inputs that need to be varied for 
sensitivity analyses.

\begin{table}[]
    \caption{Model inputs}
    \label{inputtable}
\hspace*{-2cm}
\fontsize{6pt}{10pt}\selectfont\begin{tabular}{lllll}
\hline \\
Input & Value & Distribution & Source & \\
\hline \\
Incidence of non-fatal MI & Age and sex-specific & \specialcell{\noindent Log-normal \\ See Figure~\ref{MIinc}} & UK Biobank & \\
Incidence of fatal MI & Age and sex-specific & \specialcell{\noindent Log-normal \\ See Figure~\ref{NOCVDmort}} & UK Biobank & \\
\specialcell{\noindent Non-CHD mortality rate \\ for people without MI} & Age and sex-specific & \specialcell{\noindent Log-normal 
\\ See Figure~\ref{NOCVDmort}} & UK Biobank & \\
\specialcell{\noindent All-cause mortality rate \\ for people with MI} & \specialcell{\noindent Age-, sex-, and \\ 
time-since-MI-specific} & \specialcell{\noindent Log-normal \\ See Figure~\ref{PMImort}} & UK Biobank & \\
\specialcell{Effect of statins on LDL-C \\ (control arm only)} & 45\% (44, 46) reduction & Normal & \cite{AdamsCDSR2015} & \\
Effect of interventions on LDL-C & \specialcellll{Low/moderate intensity statins: 40\% (39, 41) reduction \\ 
High intensity statins: 50\% (49, 51) reduction \\ Low/moderate intensity statins and ezetimibe: 55\% (54, 56) reduction \\ 
Inclisiran: 51.5\% (49.0, 53.9) reduction} & Normal & \specialcellll{\cite{AdamsCDSR2015} \\ \cite{AdamsCDSR2015} \\ 
\cite{AmbeAth2014} \\ \cite{KausikNEJM2020}} & \\
\specialcell{\noindent Effect of cumulative LDL-C \\ on the incidence of MI} & RR: 0.48 (0.45, 0.50) & Log-normal & 
\cite{FerenceJAMA2019} & \\
Utility for people without MI & Age and sex-specific ($\pm$ 5\%) & \specialcell{\noindent Modified normal \\ 
See Figure~\ref{PSAFig4}} & \cite{ARAVIH2010} &  \\
Chronic utility for people with MI & 0.79 (0.73, 0.85) & Beta & \cite{BettsHQLO2020} & \\
Acute disutility for MI & -0.03 ($\pm$ 50\%) & Normal & \cite{LewisJACCHF2014} & \\
Cost of acute MI & \textsterling 2047.31 ($\pm$ 15\%) & Gamma  & \specialcell{\noindent National Health Service Cost \\ 
Schedule; See Table~\ref{ACUTEMICOST}} &  \\
\specialcell{\noindent Excess healthcare costs \\ for people with MI} & \specialcell{\noindent 
\textsterling 4705.45 (SE: 112.71) for the first 6 months \\ \textsterling 1015.21 (SE: 171.23) per year thereafter} & 
Gamma & \cite{DaneseeBMJO2016} &  \\ 
\specialcell{Annual cost of statins \\ (control arm only)} & \textsterling 19.00 & Fixed & \cite{NHSDrugTariff,NHSEPD} & \\
Annual cost of interventions & \specialcellll{Low/moderate intensity statins: \textsterling 18.39  \\ High intensity statins: 
\textsterling 27.39 \\ low/moderate intensity statins and ezetimibe: \textsterling 49.31 \\ Inclisiran: \textsterling 3974.72} & 
Fixed & \specialcellll{\cite{NHSDrugTariff} \\ \cite{NHSDrugTariff} \\ \cite{NHSDrugTariff} \\ \cite{NHSDMDInclisiran2022}} & \\
\hline
\end{tabular}
\end{table}

There are two kinds of sensitivity analyses that will be used in this study:
one-way and probabilistic sensitivity analyses. One-way sensitivity analyses 
are shown in this section, probabilistic in the next. For the one-way sensitivity
analyses, the primary outcome will be the ICER.
There are six inputs that must be varied for the microsimulation, 
and five that we vary after the fact. The first six:

\begin{enumerate}
\item Incidence of non-fatal MI
\item Incidence of fatal MI
\item Non-CHD mortality rate for people without MI
\item All-cause mortality rate for people with MI
\item Effect of therapies on LDL-C
\item Effect of LDL-C on MI risk
\end{enumerate}

And the following five:

\begin{enumerate}
\setcounter{enumi}{6}
\item Utility for people without MI
\item Chronic utility for people with MI
\item Acute disutility for MI
\item Cost of acute MI
\item Cost of chronic MI
\end{enumerate}

\subsection{Code}

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*0.55 if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*0.55 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
keep eid sex ldl age njm ldl_0_30-ldl_0_60
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
gen ldl_`ii'_`i'_51 = ldl_0_`i'
gen ldl_`ii'_`i'_52 = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*0.6 if age >= `i'
replace ldl_1_`i'_51 = ldl_0_`i'*0.61 if age >= `i'
replace ldl_1_`i'_52 = ldl_0_`i'*0.59 if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*0.5 if age >= `i'
replace ldl_2_`i'_51 = ldl_0_`i'*0.51 if age >= `i'
replace ldl_2_`i'_52 = ldl_0_`i'*0.49 if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*0.45 if age >= `i'
replace ldl_3_`i'_51 = ldl_0_`i'*0.46 if age >= `i'
replace ldl_3_`i'_52 = ldl_0_`i'*0.44 if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*0.485 if age >= `i'
replace ldl_4_`i'_51 = ldl_0_`i'*0.510 if age >= `i'
replace ldl_4_`i'_52 = ldl_0_`i'*0.461 if age >= `i'
}
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')/10
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
bysort eid (age) : gen cumldl_`i'_`ii'_51 = sum(ldl_`i'_`ii'_51)/10
gen aveldl_`i'_`ii'_51 = cumldl_`i'_`ii'_51/age
bysort eid (age) : gen cumldl_`i'_`ii'_52 = sum(ldl_`i'_`ii'_52)/10
gen aveldl_`i'_`ii'_52 = cumldl_`i'_`ii'_52/age
}
}
keep eid sex age aveldl ///
aveldl_1_30 aveldl_1_40 aveldl_1_50 aveldl_1_60 ///
aveldl_2_30 aveldl_2_40 aveldl_2_50 aveldl_2_60 ///
aveldl_3_30 aveldl_3_40 aveldl_3_50 aveldl_3_60 ///
aveldl_4_30 aveldl_4_40 aveldl_4_50 aveldl_4_60 ///
aveldl_1_30_51 aveldl_1_40_51 aveldl_1_50_51 aveldl_1_60_51 ///
aveldl_2_30_51 aveldl_2_40_51 aveldl_2_50_51 aveldl_2_60_51 ///
aveldl_3_30_51 aveldl_3_40_51 aveldl_3_50_51 aveldl_3_60_51 ///
aveldl_4_30_51 aveldl_4_40_51 aveldl_4_50_51 aveldl_4_60_51 ///
aveldl_1_30_52 aveldl_1_40_52 aveldl_1_50_52 aveldl_1_60_52 ///
aveldl_2_30_52 aveldl_2_40_52 aveldl_2_50_52 aveldl_2_60_52 ///
aveldl_3_30_52 aveldl_3_40_52 aveldl_3_50_52 aveldl_3_60_52 ///
aveldl_4_30_52 aveldl_4_40_52 aveldl_4_50_52 aveldl_4_60_52
keep if age >= 30
tostring age, replace force format(%9.1f)
destring age, replace
merge m:1 sex age using ldlave_reg
drop if _merge == 2
drop _merge
merge m:1 sex age using MI_inc
drop if _merge == 2
drop _merge
rename rate nfMIrate
rename errr nfMIerrr
merge m:1 sex age using MIdrates
drop if _merge == 2
drop _merge MI
rename rate fMIrate
rename errr fMIerrr
sort eid age
save OSA/LDL_trajectories_`a'_OSA, replace
}
forval z = 300/849 {
forval a = 1(1000)458001 {
use OSA/LDL_trajectories_`a'_OSA, clear
replace age = age*10
keep if age == `z'
gen nfMIrate_lb = exp(ln(nfMIrate)-1.96*nfMIerrr)
gen nfMIrate_ub = exp(ln(nfMIrate)+1.96*nfMIerrr)
gen fMIrate_lb = exp(ln(fMIrate)-1.96*fMIerrr)
gen fMIrate_ub = exp(ln(fMIrate)+1.96*fMIerrr)
gen nfMIadj = nfMIrate*(0.48^(ldlave-aveldl))
gen fMIadj = fMIrate*(0.48^(ldlave-aveldl))
gen nfMIadj_11 = nfMIrate_lb*(0.48^(ldlave-aveldl))
gen nfMIadj_12 = nfMIrate_ub*(0.48^(ldlave-aveldl))
gen fMIadj_21 = fMIrate_lb*(0.48^(ldlave-aveldl))
gen fMIadj_22 = fMIrate_ub*(0.48^(ldlave-aveldl))
gen nfMIadj_61 = nfMIrate*(0.45^(ldlave-aveldl))
gen fMIadj_61 = fMIrate*(0.45^(ldlave-aveldl))
gen nfMIadj_62 = nfMIrate*(0.5^(ldlave-aveldl))
gen fMIadj_62 = fMIrate*(0.5^(ldlave-aveldl))
forval i = 1/4 {
forval ii = 30(10)60 {
gen nfMIadj_`i'_`ii' = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii' = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
gen nfMIadj_`i'_`ii'_11 = nfMIrate_lb*(0.48^(ldlave-aveldl_`i'_`ii'))
gen nfMIadj_`i'_`ii'_12 = nfMIrate_ub*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii'_21 = fMIrate_lb*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii'_22 = fMIrate_ub*(0.48^(ldlave-aveldl_`i'_`ii'))
gen nfMIadj_`i'_`ii'_51 = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'_51))
gen fMIadj_`i'_`ii'_51 = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'_51))
gen nfMIadj_`i'_`ii'_52 = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'_52))
gen fMIadj_`i'_`ii'_52 = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'_52))
gen nfMIadj_`i'_`ii'_61 = nfMIrate*(0.45^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii'_61 = fMIrate*(0.45^(ldlave-aveldl_`i'_`ii'))
gen nfMIadj_`i'_`ii'_62 = nfMIrate*(0.5^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii'_62 = fMIrate*(0.5^(ldlave-aveldl_`i'_`ii'))
}
}
keep eid sex age nfMIrate-fMIadj_4_60_62
save OSA/MIrisk_`a'_`z'_OSA, replace
}
clear
forval a = 1(1000)458001 {
append using OSA/MIrisk_`a'_`z'_OSA
}
save OSA/MIrisk_com_`z'_OSA, replace
forval a = 1(1000)458001 {
erase OSA/MIrisk_`a'_`z'_OSA.dta
}
}
forval a = 1(1000)458001 {
erase OSA/LDL_trajectories_`a'_OSA.dta
}
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 {
use Microsim_30, clear
save OSA/Microsim_30_`q', replace
set seed 6746
forval i = 300/849 {
merge 1:1 eid age using OSA/MIrisk_com_`i'_OSA
drop if _merge == 2
if `q' == 11 {
rename (nfMIadj_11 fMIadj) (nfMI fMI)
}
else if `q' == 12 {
rename (nfMIadj_12 fMIadj) (nfMI fMI)
}
else if `q' == 21 {
rename (nfMIadj fMIadj_21) (nfMI fMI)
}
else if `q' == 22 {
rename (nfMIadj fMIadj_22) (nfMI fMI)
}
else if `q' == 61 {
rename (nfMIadj_61 fMIadj_61) (nfMI fMI)
}
else if `q' == 62 {
rename (nfMIadj_62 fMIadj_62) (nfMI fMI)
}
else {
rename (nfMIadj fMIadj) (nfMI fMI)
}
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
if `q' == 31 {
replace rate = exp(ln(rate)-1.96*errr)
}
if `q' == 32 {
replace rate = exp(ln(rate)+1.96*errr)
}
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
if `q' == 41 {
replace rate = exp(ln(rate)-1.96*errr)
}
if `q' == 42 {
replace rate = exp(ln(rate)+1.96*errr)
}
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
keep eid-rand
if `i' == 399 {
save OSA/Microsim_40_`q', replace
set seed 2791
}
if `i' == 499 {
save OSA/Microsim_50_`q', replace
set seed 9261
}
if `i' == 599 {
save OSA/Microsim_60_`q', replace
set seed 1467
}
}
replace age = age/10
replace durn = durn/10
save OSA/trial_control_`q', replace
forval i = 1/4 {
forval ii = 30(10)60 {
if `ii' == 30 {
local a = 300
set seed 6746
}
if `ii' == 40 {
local a = 400
set seed 2791
}
if `ii' == 50 {
local a = 500
set seed 9261
}
if `ii' == 60 {
local a = 600
set seed 1467
}
use OSA/Microsim_`ii'_`q', clear
forval iii = `a'/849 {
merge 1:1 eid age using OSA/MIrisk_com_`iii'_OSA
drop if _merge == 2
if `q' == 11 {
rename (nfMIadj_`i'_`ii'_11 fMIadj_`i'_`ii') (nfMI fMI)
}
else if `q' == 12 {
rename (nfMIadj_`i'_`ii'_12 fMIadj_`i'_`ii') (nfMI fMI)
}
else if `q' == 21 {
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii'_21) (nfMI fMI)
}
else if `q' == 22 {
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii'_22) (nfMI fMI)
}
else if `q' == 51 {
rename (nfMIadj_`i'_`ii'_51 fMIadj_`i'_`ii'_51) (nfMI fMI)
}
else if `q' == 52 {
rename (nfMIadj_`i'_`ii'_52 fMIadj_`i'_`ii'_52) (nfMI fMI)
}
else if `q' == 61 {
rename (nfMIadj_`i'_`ii'_61 fMIadj_`i'_`ii'_61) (nfMI fMI)
}
else if `q' == 62 {
rename (nfMIadj_`i'_`ii'_62 fMIadj_`i'_`ii'_62) (nfMI fMI)
}
else {
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii') (nfMI fMI)
}
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
if `q' == 31 {
replace rate = exp(ln(rate)-1.96*errr)
}
if `q' == 32 {
replace rate = exp(ln(rate)+1.96*errr)
}
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
if `q' == 41 {
replace rate = exp(ln(rate)-1.96*errr)
}
if `q' == 42 {
replace rate = exp(ln(rate)+1.96*errr)
}
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
keep eid-rand
}
replace age = age/10
replace durn = durn/10
save OSA/trial_`i'_`ii'_`q', replace
}
}
}
forval iii = 300/849 {
erase OSA/MIrisk_com_`iii'_OSA.dta
}
}
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
gen UTlb = UT*0.95
gen UTub = UT*1.05
replace UTlb = 0 if UTlb < 0
replace UTub = 1 if UTub > 1
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen QAL_lb_`i' = 0.1*UTlb*DC_`i'
gen QAL_ub_`i' = 0.1*UTub*DC_`i'
replace QAL_lb_`i' = QAL_lb_`i'/2 if MIage == `i'
replace QAL_ub_`i' = QAL_ub_`i'/2 if MIage == `i'
bysort sex (MIage) : gen double QALY_nMI_lb_`i' = sum(QAL_lb_`i')
bysort sex (MIage) : gen double QALY_nMI_ub_`i' = sum(QAL_ub_`i')
}
keep MIage sex QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60 ///
QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save OSA/QALY_nMI_Matrix_OSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
gen UT = 0.9454933+0.0256466*sex-0.0002213*age - 0.0000294*(age^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen QAL_alb_`i'=0.1*UT*DC_`i'*0.79
gen QAL_aub_`i'=0.1*UT*DC_`i'*0.79
gen QAL_clb_`i'=0.1*UT*DC_`i'*0.73
gen QAL_cub_`i'=0.1*UT*DC_`i'*0.85
replace QAL_clb_`i' = QAL_clb_`i' - 0.01 if durn <0.301
replace QAL_clb_`i' = 0 if QAL_clb_`i' < 0
replace QAL_cub_`i' = QAL_cub_`i' - 0.01 if durn <0.301
replace QAL_cub_`i' = 0 if QAL_cub_`i' < 0
replace QAL_alb_`i' = QAL_alb_`i' - 0.015 if durn <0.301
replace QAL_alb_`i' = 0 if QAL_alb_`i' < 0
replace QAL_aub_`i' = QAL_aub_`i' - 0.005 if durn <0.301
replace QAL_aub_`i' = 0 if QAL_aub_`i' < 0
bysort sex MIage (age) : gen double QALY_MI_clb_`i' = sum(QAL_clb_`i')
bysort sex MIage (age) : gen double QALY_MI_cub_`i' = sum(QAL_cub_`i')
bysort sex MIage (age) : gen double QALY_MI_alb_`i' = sum(QAL_alb_`i')
bysort sex MIage (age) : gen double QALY_MI_aub_`i' = sum(QAL_aub_`i')
}
keep age MIage sex ///
QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save OSA/QALY_MI_Matrix_OSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen double ACMIcost_lb_`i' = 2047.31*DC_`i'*0.85
gen double ACMIcost_ub_`i' = 2047.31*DC_`i'*1.15
}
keep MIage ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60 ///
ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save OSA/ACcost_Matrix_OSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen cost_lb_`i' = DC_`i'*(4705.45-(1.96*112.71))/5 if durn <=0.5
replace cost_lb_`i' = DC_`i'*(1015.21-(1.96*171.23))/10 if cost_lb_`i'==.
bysort sex MIage (age) : gen double CHMIcost_lb_`i' = sum(cost_lb_`i')
gen cost_ub_`i' = DC_`i'*(4705.45+(1.96*112.71))/5 if durn <=0.5
replace cost_ub_`i' = DC_`i'*(1015.21+(1.96*171.23))/10 if cost_ub_`i'==.
bysort sex MIage (age) : gen double CHMIcost_ub_`i' = sum(cost_ub_`i')
}
keep age MIage sex CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60 ///
CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save OSA/CHcost_Matrix_OSA, replace
quietly {
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
if `q' < 70 {
use OSA/trial_control_`q', clear
}
else {
use trial_control, clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using agellt_control
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
if `q' == 71 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60
rename (QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else if `q' == 72 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60
rename (QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else {
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 81 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 82 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 91 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 92 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60
rename (QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else {
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 101 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60
rename (ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else if `q' == 102 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60
rename (ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else {
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 111 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60
rename (CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else if `q' == 112 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60
rename (CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else {
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
}
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
if `q' < 70 {
use OSA/trial_`ii'_`i'_`q', clear
}
else {
use trial_`ii'_`i', clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
if `q' == 71 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60
rename (QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else if `q' == 72 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60
rename (QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else {
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 81 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 82 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 91 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 92 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60
rename (QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else {
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 101 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60
rename (ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else if `q' == 102 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60
rename (ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else {
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 111 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60
rename (CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else if `q' == 112 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60
rename (CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else {
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
}
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save OSA/OSA_`q'_ICERs, replace
}
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
forval s = 0/1 {
foreach l in 0 3 4 5 {
if `q' < 70 {
use OSA/trial_control_`q', clear
}
else {
use trial_control, clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if sex == `s'
keep if ldl >= `l'
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using agellt_control
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
if `q' == 71 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60
rename (QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else if `q' == 72 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60
rename (QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else {
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 81 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 82 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 91 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 92 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60
rename (QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else {
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 101 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60
rename (ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else if `q' == 102 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60
rename (ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else {
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 111 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60
rename (CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else if `q' == 112 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60
rename (CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else {
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
}
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
if `q' < 70 {
use OSA/trial_`ii'_`i'_`q', clear
}
else {
use trial_`ii'_`i', clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if sex == `s'
keep if ldl >= `l'
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
if `q' == 71 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60
rename (QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else if `q' == 72 {
merge m:1 MIage sex using OSA/QALY_nMI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_nMI_lb_30 QALY_nMI_lb_40 QALY_nMI_lb_50 QALY_nMI_lb_60
rename (QALY_nMI_ub_30 QALY_nMI_ub_40 QALY_nMI_ub_50 QALY_nMI_ub_60) ///
(QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60)
}
else {
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 81 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 82 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 91 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60
rename (QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else if `q' == 92 {
merge m:1 age MIage sex using OSA/QALY_MI_Matrix_OSA
drop if _merge == 2
drop _merge
drop QALY_MI_clb_30 QALY_MI_clb_40 QALY_MI_clb_50 QALY_MI_clb_60 ///
QALY_MI_cub_30 QALY_MI_cub_40 QALY_MI_cub_50 QALY_MI_cub_60 ///
QALY_MI_alb_30 QALY_MI_alb_40 QALY_MI_alb_50 QALY_MI_alb_60
rename (QALY_MI_aub_30 QALY_MI_aub_40 QALY_MI_aub_50 QALY_MI_aub_60) ///
(QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60)
}
else {
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 101 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60
rename (ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else if `q' == 102 {
merge m:1 MIage using OSA/ACcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop ACMIcost_lb_30 ACMIcost_lb_40 ACMIcost_lb_50 ACMIcost_lb_60
rename (ACMIcost_ub_30 ACMIcost_ub_40 ACMIcost_ub_50 ACMIcost_ub_60) ///
(ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60)
}
else {
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
}
if `q' == 111 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60
rename (CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else if `q' == 112 {
merge m:1 age MIage sex using OSA/CHcost_Matrix_OSA
drop if _merge == 2
drop _merge
drop CHMIcost_lb_30 CHMIcost_lb_40 CHMIcost_lb_50 CHMIcost_lb_60
rename (CHMIcost_ub_30 CHMIcost_ub_40 CHMIcost_ub_50 CHMIcost_ub_60) ///
(CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60)
}
else {
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
}
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save OSA/OSA_`q'_ICERs_sex_`s'_ldl_`l', replace
}
}
}
}
texdoc stlog close

/***
\color{black}

\subsection{Checks}

Before plotting these, it would be prudent to check there aren't any simulations 
with negative incremental QALYs.

\color{Blue4}
***/

texdoc stlog
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
use OSA/OSA_`q'_ICERs, clear
forval j = 1/4 {
quietly count if A2 == 5 & D`j' < 0
if r(N) != 0 {
di "Oh, bother"
}
}
forval s = 0/1 {
foreach l in 0 3 4 5 {
use OSA/OSA_`q'_ICERs_sex_`s'_ldl_`l', clear
forval j = 1/4 {
quietly count if A2 == 5 & D`j' < 0
if r(N) != 0 {
di "Oh, bother"
}
}
}
}
}
texdoc stlog close

/***
\color{black}

And also to check that the simulations have done what they're meant to have done:

\color{Blue4}
***/

texdoc stlog
quietly {
use reshof0, clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs" if A2 == 6
replace A0 = "Acute MI costs" if A2 == 7
replace A0 = "Chronic MI costs" if A2 == 8
replace A0 = "Total healthcare costs" if A2 == 9
order A0
rename (A3 A4 A5 A6 A7) (Control LMStatin HIStatin LMStEze Inclisiran)
noisily di "Base-case"
noisily list A0 Control LMStatin HIStatin LMStEze Inclisiran in 1/9 , separator(0)
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
use OSA/OSA_`q'_ICERs, clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs" if A2 == 6
replace A0 = "Acute MI costs" if A2 == 7
replace A0 = "Chronic MI costs" if A2 == 8
replace A0 = "Total healthcare costs" if A2 == 9
order A0
rename (A3 A4 A5 A6 A7) (Control LMStatin HIStatin LMStEze Inclisiran)
noisily di `q'
noisily list A0 Control LMStatin HIStatin LMStEze Inclisiran in 1/9 , separator(0)
}
}
texdoc stlog close

/***
\color{black}

\subsection{Tornado diagrams}

With that all okay, the Tornado diagrams can be presented:

\color{Blue4}
***/

texdoc stlog, cmdlog
use reshof0, clear
keep if A2 == 10
keep A1 A2 D1-D4
gen A = 0
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
append using OSA/OSA_`q'_ICERs
keep if A2 == 10
keep A1 A2 D1-D4 A
recode A .=`q'
}
sort A A1
tostring A, gen(AA)
sort A A1
forval j = 1/4 {
gen D`j'ub = D`j'[_n+4] if substr(AA,-1,1)=="1"
rename D`j' D`j'lb
}
drop if substr(AA,-1,1)=="2"
replace AA = "Incidence of non-fatal MI" if AA == "11"
replace AA = "Incidence of fatal MI" if AA == "21"
replace AA = "Non-CHD mortality rate" if AA == "31"
replace AA = "Post-MI mortality rate" if AA == "41"
replace AA = "Effect of intervention on LDL-C" if AA == "51"
replace AA = "Effect of LDL-C on MI" if AA == "61"
replace AA = "Utility without MI" if AA == "71"
replace AA = "Chronic utility with MI" if AA == "81"
replace AA = "Acute disutility for MI" if AA == "91"
replace AA = "Acute MI cost" if AA == "101"
replace AA = "Chronic MI cost" if AA == "111"
forval j = 1/4 {
label variable D`j'lb "Lower limit"
label variable D`j'ub "Upper limit"
}
texdoc stlog close
texdoc stlog
list D1lb if A1 == 30 & A == 0
list D1lb if A1 == 30 & A == 111
list D1ub if A1 == 30 & A == 111
texdoc stlog close
texdoc stlog, cmdlog nodo
preserve
use inferno, clear
local col1 = var9[9]
local col2 = var9[6]
restore
forval i = 30(10)60 {
forval ii = 1/4 {
if `ii' == 1 {
local a = "Low/moderate intensity statins"
}
if `ii' == 2 {
local a = "High intensity statins"
}
if `ii' == 3 {
local a = "Low/moderate intensity statins and ezetimibe"
}
if `ii' == 4 {
local a = "Inclisiran"
}
preserve
keep if A1 == `i'
keep AA D`ii'lb D`ii'ub 
gen shb = (D`ii'ub-D`ii'lb)^2
sort shb 
gen njm = _n
local 1 = AA[1]
local 2 = AA[2]
local 3 = AA[3]
local 4 = AA[4]
local 5 = AA[5]
local 6 = AA[6]
local 7 = AA[7]
local 8 = AA[8]
local 9 = AA[9]
local 10 = AA[10]
local 11 = AA[11]
local ref = D`ii'lb[12]
twoway ///
(bar D`ii'lb njm, horizontal base(`ref') color("`col1'")) ///
(bar D`ii'ub njm, horizontal base(`ref') color("`col2'")) ///
, ylabel( ///
1 "`1'" ///
2 "`2'" ///
3 "`3'" ///
4 "`4'" ///
5 "`5'" ///
6 "`6'" ///
7 "`7'" ///
8 "`8'" ///
9 "`9'" ///
10 "`10'" ///
11 "`11'" ///
, angle(0) nogrid) ///
legend(position(12) ring(0) region(lcolor(white)) cols(2)) ///
ytitle("") graphregion(color(white)) xlabel(, format(%9.0fc)) ///
xtitle("ICER (Δ£/ΔQALY)", margin(medium)) ///
title("`a' from age `i'", color(gs0) size(medium) placement(west))
graph save GPH/OSAtorn_`i'_`ii', replace
restore
}
}
forval s = 0/1 {
foreach l in 0 3 4 5 {
use reshof0_sex_`s'_ldl_`l', clear
keep if A2 == 10
keep A1 A2 D1-D4
gen A = 0
foreach q in 11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 {
append using OSA/OSA_`q'_ICERs_sex_`s'_ldl_`l'
keep if A2 == 10
keep A1 A2 D1-D4 A
recode A .=`q'
}
sort A A1
tostring A, gen(AA)
sort A A1
forval j = 1/4 {
gen D`j'ub = D`j'[_n+4] if substr(AA,-1,1)=="1"
rename D`j' D`j'lb
}
drop if substr(AA,-1,1)=="2"
replace AA = "Incidence of non-fatal MI" if AA == "11"
replace AA = "Incidence of fatal MI" if AA == "21"
replace AA = "Non-CHD mortality rate" if AA == "31"
replace AA = "Post-MI mortality rate" if AA == "41"
replace AA = "Effect of intervention on LDL-C" if AA == "51"
replace AA = "Effect of LDL-C on MI" if AA == "61"
replace AA = "Utility without MI" if AA == "71"
replace AA = "Chronic utility with MI" if AA == "81"
replace AA = "Acute disutility for MI" if AA == "91"
replace AA = "Acute MI cost" if AA == "101"
replace AA = "Chronic MI cost" if AA == "111"
forval j = 1/4 {
label variable D`j'lb "Lower limit"
label variable D`j'ub "Upper limit"
}
preserve
if `s' == 0 {
use inferno, clear
local col1 = var9[9]
local col2 = var9[6]
}
else {
use viridis, clear
local col1 = var9[9]
local col2 = var9[5]
}
restore
forval i = 30(10)60 {
forval ii = 1/4 {
if `ii' == 1 {
local a = "Low/moderate intensity statins"
}
if `ii' == 2 {
local a = "High intensity statins"
}
if `ii' == 3 {
local a = "Low/moderate intensity statins and ezetimibe"
}
if `ii' == 4 {
local a = "Inclisiran"
}
preserve
keep if A1 == `i'
keep AA D`ii'lb D`ii'ub 
gen shb = (D`ii'ub-D`ii'lb)^2
sort shb 
gen njm = _n
local 1 = AA[1]
local 2 = AA[2]
local 3 = AA[3]
local 4 = AA[4]
local 5 = AA[5]
local 6 = AA[6]
local 7 = AA[7]
local 8 = AA[8]
local 9 = AA[9]
local 10 = AA[10]
local 11 = AA[11]
local ref = D`ii'lb[12]
twoway ///
(bar D`ii'lb njm, horizontal base(`ref') color("`col1'")) ///
(bar D`ii'ub njm, horizontal base(`ref') color("`col2'")) ///
, ylabel( ///
1 "`1'" ///
2 "`2'" ///
3 "`3'" ///
4 "`4'" ///
5 "`5'" ///
6 "`6'" ///
7 "`7'" ///
8 "`8'" ///
9 "`9'" ///
10 "`10'" ///
11 "`11'" ///
, angle(0) nogrid) ///
legend(position(12) ring(0) region(lcolor(white)) cols(2)) ///
ytitle("") graphregion(color(white)) xlabel(, format(%9.0fc)) ///
xtitle("ICER (Δ£/ΔQALY)", margin(medium)) ///
title("`a' from age `i'", color(gs0) size(medium) placement(west))
graph save GPH/OSAtorn_`i'_`ii'_`s'_`l', replace
restore
}
}
}
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/OSAtorn_30_1.gph ///
GPH/OSAtorn_30_2.gph ///
GPH/OSAtorn_30_3.gph ///
GPH/OSAtorn_30_4.gph ///
GPH/OSAtorn_40_1.gph ///
GPH/OSAtorn_40_2.gph ///
GPH/OSAtorn_40_3.gph ///
GPH/OSAtorn_40_4.gph ///
GPH/OSAtorn_50_1.gph ///
GPH/OSAtorn_50_2.gph ///
GPH/OSAtorn_50_3.gph ///
GPH/OSAtorn_50_4.gph ///
GPH/OSAtorn_60_1.gph ///
GPH/OSAtorn_60_2.gph ///
GPH/OSAtorn_60_3.gph ///
GPH/OSAtorn_60_4.gph ///
, altshrink cols(4) xsize(6) graphregion(color(white))
texdoc graph, label(Tornado0) fontface("Liberation Sans") caption(Tornado diagrams for each intervention strategy - Overall)
forval s = 0/1 {
foreach l in 0 3 4 5 {
if `s' == 0 {
local a = "Females"
}
else {
local a = "Males"
}
if `l' == 0 {
local b = ""
}
if `l' == 3 {
local b = " with LDL-C $\geq$3.0 mmol/L"
}
if `l' == 4 {
local b = " with LDL-C $\geq$4.0 mmol/L"
}
if `l' == 5 {
local b = " with LDL-C $\geq$5.0 mmol/L"
}
graph combine ///
GPH/OSAtorn_30_1_`s'_`l'.gph ///
GPH/OSAtorn_30_2_`s'_`l'.gph ///
GPH/OSAtorn_30_3_`s'_`l'.gph ///
GPH/OSAtorn_30_4_`s'_`l'.gph ///
GPH/OSAtorn_40_1_`s'_`l'.gph ///
GPH/OSAtorn_40_2_`s'_`l'.gph ///
GPH/OSAtorn_40_3_`s'_`l'.gph ///
GPH/OSAtorn_40_4_`s'_`l'.gph ///
GPH/OSAtorn_50_1_`s'_`l'.gph ///
GPH/OSAtorn_50_2_`s'_`l'.gph ///
GPH/OSAtorn_50_3_`s'_`l'.gph ///
GPH/OSAtorn_50_4_`s'_`l'.gph ///
GPH/OSAtorn_60_1_`s'_`l'.gph ///
GPH/OSAtorn_60_2_`s'_`l'.gph ///
GPH/OSAtorn_60_3_`s'_`l'.gph ///
GPH/OSAtorn_60_4_`s'_`l'.gph ///
, altshrink cols(4) xsize(6) graphregion(color(white))
texdoc graph, label(Tornado`s'`l') fontface("Liberation Sans") caption(Tornado diagrams for each intervention strategy - `a' `b')
}
}
texdoc stlog close

/***
\color{black}

\clearpage
\pagebreak
\section{Probabilistic sensitivity analysis}

\subsection{Distributions}

The final sensitivity analysis is the probabilistic sensitivity analysis (PSA). 
First, the distributions for each of the model inputs must be derived. 
This is simple for: the incidence of MI and mortality rates, as they are just log-normally
distributed around the central value; the effect of the the interventions on LDL-C, which are normally distributed; 
and the effect of LDL-C on MI risk, which is log-normally distributed. 

The formula for the log-normal distributions is as follows (used above for the one-way sensitivity analyses): 

\begin{quote}
\begin{math}
a_{adj} = e^{\ln(a_\mu)+N(0,1) \sigma}
\end{math}
\end{quote}

The standard error for the rates are just derived from the regression models in section~\ref{TPs}.
The standard errors for the effect of the interventions on LDL-C: 

\begin{quote}
All interventions excluding Inclisiran:
\begin{math}
\sigma = \frac{0.02}{3.92} = 0.0051
\end{math}
\end{quote}

\begin{quote}
Inclisiran:
\begin{math}
\sigma = \frac{0.51-0.461}{3.92} = 0.0125
\end{math}
\end{quote}

And the standard error for the effect of LDL-C on MI risk: 

\begin{quote}
\begin{math}
\sigma = \frac{0.5-0.45}{3.92} = 0.0128
\end{math}
\end{quote}

As always, it's good to check these make sense (figures~\ref{PSAhist11} - ~\ref{PSAhist16}).

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 100000
gen A=.
replace A = rnormal(0.55,0.0051)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Effect size") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist11) fontface("Liberation Sans") caption(Histogram of effect of statins (control arm) on LDL-C)
clear
set obs 100000
gen A=.
replace A = rnormal(0.6,0.0051)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Effect size") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist12) fontface("Liberation Sans") caption(Histogram of effect of low/moderate intensity statins on LDL-C)
clear
set obs 100000
gen A=.
replace A = rnormal(0.5,0.0051)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Effect size") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist13) fontface("Liberation Sans") caption(Histogram of effect of high intensity statins on LDL-C)
clear
set obs 100000
gen A=.
replace A = rnormal(0.45,0.0051)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Effect size") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist14) fontface("Liberation Sans") caption(Histogram of effect of low/moderate intensity statins and ezetimibe on LDL-C)
clear
set obs 100000
gen A=.
replace A = rnormal(0.485,0.0125)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Effect size") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist15) fontface("Liberation Sans") caption(Histogram of effect of Inclisiran on LDL-C)
clear
set obs 100000
gen A=.
replace A = exp(ln(0.48)+rnormal()*0.012755)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Relative risk") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist16) fontface("Liberation Sans") caption(Histogram of relative risk of mean cumulative LDL-C on MI risk)
texdoc stlog close

/***
\color{black}

Now, for the utility value for people without MI (which is already characterised by a function), it would not be efficient to generate
a unique beta distribution for each age and sex; instead, a modified normal distribution can be assumed for this (modified only in the 
sense that if the value falls outside the 0-1 range, it is constrained back to this range). 
Thus, it ends up looking like this (figure~\ref{PSAFig4}:

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
clear
set obs 55
gen MIage = (_n+29)
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
expand 100000
replace UT = UT*(1+(rnormal()*0.05))
replace UT = 1 if UT > 1
replace UT = 0 if UT < 0
matrix A = (.,.,.,.,.)
forval i = 0/1 {
forval ii = 30/84 {
preserve
keep if sex == `i' & MIage == `ii'
centile UT, centile(50 2.5 97.5)
matrix A = (A\0`i',0`ii',r(c_1),r(c_2),r(c_3))
restore
}
}
clear
svmat A
save UTPSA, replace
texdoc stlog close
texdoc stlog, cmdlog
use UTPSA, clear
twoway ///
(rarea A5 A4 A2 if A1 == 0, col(red%30) fintensity(inten80) lwidth(none)) ///
(line A3 A2 if A1 == 0, color(red)) ///
(rarea A5 A4 A2 if A1 == 1, col(blue%30) fintensity(inten80) lwidth(none)) ///
(line A3 A2 if A1 == 1, color(blue)) ///
, legend(order(4 "Male" ///
2 "Female") ///
cols(1) ring(0) position(1) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Utility) xtitle(Age) ///
ylabel(,angle(0) format(%9.2f))
texdoc graph, label(PSAFig4) fontface("Liberation Sans") caption(Distribution of utility values for people without MI in PSA)
texdoc stlog close

/***
\color{black}

Now for the chronic utility value for people with MI (0.79 (0.73-0.85)), which has a beta distribution. 
The mean (\begin{math} \mu \end{math}) and variance (\begin{math} \sigma^2 \end{math})
of a beta distribution are given by:

\begin{quote}
\begin{math} 
\mu = \frac{\alpha}{\alpha + \beta}
\end{math}
\end{quote}

and

\begin{quote}
\begin{math} 
\sigma^2 = \frac{\alpha \beta}{(\alpha + \beta)^2 (\alpha + \beta + 1)}
\end{math}
\end{quote}

So, if solving for \begin{math} \alpha \end{math} and \begin{math} \beta \end{math}, it can be derived that:

\begin{quote}
\begin{math} 
\alpha = \mu^2 (\frac{1-\mu}{\sigma^2}-\frac{1}{\mu})
\end{math}
\end{quote}

and

\begin{quote}
\begin{math} 
\beta = \alpha (\frac{1}{\mu}-1)
\end{math}
\end{quote}

So for utility of people with MI, the variance is calculated as: 

\begin{quote}
\begin{math} 
\sigma^2 = (\frac{0.85-0.73}{3.92})^2 = 0.00094
\end{math}
\end{quote}

And this is used to derive alpha and beta values of 139.1, and 36.97, respectively (figure~\ref{PSAhist5}).

For the acute disutility, the standard error is as for a normal distribution:

\begin{quote}
\begin{math}
\sigma = \frac{0.015-0.045}{3.92} = 0.007653
\end{math}
\end{quote}

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 100000
gen A=.
replace A = rbeta(139.1,36.97)
hist A, bin(100) color(gs0) frequency graphregion(color(white)) xtitle("Chronic MI Utility")
texdoc graph, label(PSAhist5) fontface("Liberation Sans") caption(Histogram of chronic utility value for people with MI)
clear
set obs 100000
gen A=.
replace A = rnormal(0.03,0.007653)
hist A, bin(100) color(gs0) frequency ///
graphregion(color(white)) xtitle("Aucte MI disutility") ///
xlabel(,format(%9.2f))
texdoc graph, label(PSAhist15) fontface("Liberation Sans") caption(Histogram of acute disutility value for MI)
texdoc stlog close

/***
\color{black}

Now for costs, which follow a gamma distribution. The mean (\begin{math} \mu \end{math}) 
and variance (\begin{math} \sigma^2 \end{math}) of a gamma distribution are given by:

\begin{quote}
\begin{math} 
\mu = k \theta
\end{math}
\end{quote}

and

\begin{quote}
\begin{math} 
\sigma^2 = k \theta^2
\end{math}
\end{quote}

It's easier to solve for \begin{math} k \end{math} and \begin{math} \theta \end{math} this time: 

\begin{quote}
\begin{math} 
k = \frac{\mu^2}{\sigma^2}
\end{math} \\
\\
\begin{math} 
\theta = \frac{\sigma^2}{\mu}
\end{math}
\end{quote}

So for the three costs, \begin{math} k \end{math} and \begin{math} \theta \end{math} values derived are:

\begin{quote}
Acute cost of MI (\textsterling 2047.31 (SE: 307.10)): 
\begin{math} 
k = 44.44 
\end{math}
and 
\begin{math} 
\theta = 46.06
\end{math} 
\\
Chronic cost of MI, first 6 months (\textsterling 4705.45 (SE: 112.71)): 
\begin{math} 
k = 1742.89
\end{math}
and 
\begin{math} 
\theta = 2.70
\end{math} 
\\
Chronic cost of MI, thereafter (\textsterling 1015.21 (SE: 171.23)): 
\begin{math} 
k = 35.15 
\end{math}
and 
\begin{math} 
\theta = 28.88
\end{math} 


\end{quote}

And again, check these make sense:

\color{Blue4}
***/

texdoc stlog, cmdlog
clear
set obs 10000
gen A=.
replace A = rgamma(44.44,46.06)
hist A, bin(100) color(gs0) frequency graphregion(color(white)) xtitle("Acute MI cost")
texdoc graph, label(PSAhist6) fontface("Liberation Sans") caption(Histogram of Acute MI cost)
clear
set obs 10000
gen A=.
replace A = rgamma(1742.89,2.70)
hist A, bin(100) color(gs0) frequency graphregion(color(white)) xtitle("Chronic MI cost")
texdoc graph, label(PSAhist7) fontface("Liberation Sans") caption(Histogram of Chronic MI cost, first 6 months)
clear
set obs 10000
gen A=.
replace A = rgamma(35.15,28.88)
hist A, bin(100) color(gs0) frequency graphregion(color(white)) xtitle("Chronic MI cost")
texdoc graph, label(PSAhist8) fontface("Liberation Sans") caption(Histogram of Chronic MI cost, after 6 months)
texdoc stlog close

/***
\color{black}

\subsection{Code}

So now the PSA can be set up. In the interest of time, the PSA will be run in single year intervals.
(Note it's not good to re-set the seed so many times if you don't have to, but it's good to 
be able to stop and re-start it at points. Or even better, run simultaneously across multiple
cores.)

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
forval psa = 1/1000 {
noisily di `psa'
if `psa' == 1 {
set seed 23673683
}
if `psa' == 101 {
set seed 41567801
}
if `psa' == 201 {
set seed 84653254
}
if `psa' == 301 {
set seed 19867883
}
if `psa' == 401 {
set seed 46583781
}
if `psa' == 501 {
set seed 56748291
}
if `psa' == 601 {
set seed 09728101
}
if `psa' == 701 {
set seed 45662282
}
if `psa' == 801 {
set seed 98753122
}
if `psa' == 901 {
set seed 78495613
}
local sid30 = runiformint(0,1000000000)
local sid40 = runiformint(0,1000000000)
local sid50 = runiformint(0,1000000000)
local sid60 = runiformint(0,1000000000)
local psa1 = rnormal()
local psa2 = rnormal()
local psa3 = rnormal()
local psa4 = rnormal()
local psa50 = rnormal(0.55,0.0051)
local psa51 = rnormal(0.6,0.0051)
local psa52 = rnormal(0.5,0.0051)
local psa53 = rnormal(0.45,0.0051)
local psa54 = rnormal(0.485,0.0125)
local psa6 = exp(ln(0.48)+rnormal()*0.012755)
local psa7 = rnormal()
local psa8 = rbeta(139.1,36.97)
local psa9 = rnormal(0.03,0.007653)
local psa10 = rgamma(44.44,46.06)
local psa111 = rgamma(1742.89,2.70)
local psa112 = rgamma(35.15,28.88)
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 50
bysort eid : gen age = _n/10
expand 81 if age == 5
bysort eid age : replace age = age+_n-1 if age == 5
ta age
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*`psa50' if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.001 if inrange(age,39.99,49.99)
replace lltpr = 0.015 if inrange(age,49.999,59.99)
replace lltpr = 0.035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*`psa50' if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[85]-ldl[50])/35 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
preserve
bysort eid (age) : keep if _n == 1
gen agellt2 = min(agellt,agellt1)
keep eid agellt2
rename agellt2 agellt
replace agellt = round(agellt,1)
tostring agellt, force format(%9.0f) replace
destring agellt, replace
save PSA/agellt_control_`a'_PSA, replace
restore
keep eid sex ldl age njm ldl_0_30-ldl_0_60
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*`psa51' if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*`psa52' if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*`psa53' if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*`psa54' if age >= `i'
}
replace ldl = ldl*0.1 if age <= 5
bysort eid (age) : gen cumldl = sum(ldl) if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
replace ldl_`i'_`ii' = ldl_`i'_`ii'*0.1 if age <= 5
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
}
}
keep eid sex age aveldl ///
aveldl_1_30 aveldl_1_40 aveldl_1_50 aveldl_1_60 ///
aveldl_2_30 aveldl_2_40 aveldl_2_50 aveldl_2_60 ///
aveldl_3_30 aveldl_3_40 aveldl_3_50 aveldl_3_60 ///
aveldl_4_30 aveldl_4_40 aveldl_4_50 aveldl_4_60
keep if age >= 30
tostring age, replace force format(%9.1f)
destring age, replace
merge m:1 sex age using ldlave_reg
drop if _merge == 2
drop _merge
merge m:1 sex age using MI_inc
drop if _merge == 2
drop _merge
rename rate nfMIrate
rename errr nfMIerrr
merge m:1 sex age using MIdrates
drop if _merge == 2
drop _merge MI
rename rate fMIrate
rename errr fMIerrr
sort eid age
save PSA/LDL_trajectories_`a'_PSA, replace
}
clear
forval a = 1(1000)458001 {
append using PSA/agellt_control_`a'_PSA
}
save PSA/agellt_control_PSA, replace
forval a = 1(1000)458001 {
erase PSA/agellt_control_`a'_PSA.dta
}
forval a = 1(1000)458001 {
use PSA/LDL_trajectories_`a'_PSA, clear
replace nfMIrate = exp(ln(nfMIrate)+`psa1'*nfMIerrr)
replace fMIrate = exp(ln(fMIrate)+`psa2'*fMIerrr)
gen nfMIadj = nfMIrate*(`psa6'^(ldlave-aveldl))
gen fMIadj = fMIrate*(`psa6'^(ldlave-aveldl))
forval i = 1/4 {
forval ii = 30(10)60 {
gen nfMIadj_`i'_`ii' = nfMIrate*(`psa6'^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii' = fMIrate*(`psa6'^(ldlave-aveldl_`i'_`ii'))
}
}
keep eid sex age nfMIrate-fMIadj_4_60
forval i = 30/84 {
preserve
local ii = `i'-0.5
local iii = `i'+0.5
local iiii = `i'*10
keep if inrange(age,`ii',`iii')
save PSA/MIrisk_`a'_`iiii'_PSA, replace
restore
}
}
forval i = 30/84 {
clear
local iiii = `i'*10
forval a = 1(1000)458001 {
append using PSA/MIrisk_`a'_`iiii'_PSA
}
replace age = age*10
save PSA/MIrisk_com_`iiii'_PSA, replace
}
forval a = 1(1000)458001 {
erase PSA/LDL_trajectories_`a'_PSA.dta
}
forval a = 1(1000)458001 {
forval i = 30/84 {
local iiii = round(`i'*10,1)
erase PSA/MIrisk_`a'_`iiii'_PSA.dta
}
}
use Microsim_30, clear
save PSA/Microsim_30_PSA, replace
set seed `sid30'
forval i = 300(10)840 {
merge 1:1 eid age using PSA/MIrisk_com_`i'_PSA
drop if _merge == 2
rename (nfMIadj fMIadj) (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
replace rate = exp(ln(rate)+`psa3'*errr)
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
replace rate = exp(ln(rate)+`psa4'*errr)
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+10 if Death == 0
replace durn = durn+10 if MI == 1 & Death == 0
drop nfMI-PMId
if `i' == 390 {
save PSA/Microsim_40_PSA, replace
set seed `sid40'
}
if `i' == 490 {
save PSA/Microsim_50_PSA, replace
set seed `sid50'
}
if `i' == 590 {
save PSA/Microsim_60_PSA, replace
set seed `sid60'
}
}
replace age = age/10
replace durn = durn/10
save PSA/trial_control_PSA, replace
forval i = 1/4 {
forval ii = 30(10)60 {
if `ii' == 30 {
local a = 300
set seed `sid30'
}
if `ii' == 40 {
local a = 400
set seed `sid40'
}
if `ii' == 50 {
local a = 500
set seed `sid50'
}
if `ii' == 60 {
local a = 600
set seed `sid60'
}
use PSA/Microsim_`ii'_PSA, clear
forval iii = `a'(10)840 {
merge 1:1 eid age using PSA/MIrisk_com_`iii'_PSA
drop if _merge == 2
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii') (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
replace rate = exp(ln(rate)+`psa3'*errr)
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
replace rate = exp(ln(rate)+`psa4'*errr)
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+10 if Death == 0
replace durn = durn+10 if MI == 1 & Death == 0
drop nfMI-PMId
}
replace age = age/10
replace durn = durn/10
save PSA/trial_`i'_`ii'_PSA, replace
}
}
forval iii = 300(10)849 {
erase PSA/MIrisk_com_`iii'_PSA.dta
}
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
replace UT = UT*(1+(`psa7'*0.05))
replace UT = 1 if UT > 1
replace UT = 0 if UT < 0
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen QAL_`i'=0.1*UT*DC_`i'
replace QAL_`i' = QAL_`i'/2 if MIage == `i'
bysort sex (MIage) : gen double QALY_nMI_`i' = sum(QAL_`i')
}
keep MIage sex QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save PSA/QALY_nMI_Matrix_PSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
gen UT = 0.9454933+0.0256466*sex-0.0002213*age - 0.0000294*(age^2)
replace UT = UT*(1+(`psa7'*0.05))
replace UT = 1 if UT > 1
replace UT = 0 if UT < 0
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen QAL_`i'=0.1*UT*DC_`i'*`psa8'
replace QAL_`i' = QAL_`i' - (`psa9'/3) if durn <0.301
replace QAL_`i' = 0 if QAL_`i' < 0
bysort sex MIage (age) : gen double QALY_MI_`i' = sum(QAL_`i')
}
keep age MIage sex QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save PSA/QALY_MI_Matrix_PSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((MIage-`i'))) if MIage >= `i'
gen double ACMIcost_`i' = `psa10'*DC_`i'
}
keep MIage ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save PSA/ACcost_Matrix_PSA, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*`psa111'/5 if durn <=0.5
replace cost_`i' = DC_`i'*`psa112'/10 if cost_`i'==.
bysort sex MIage (age) : gen double CHMIcost_`i' = sum(cost_`i')
}
keep age MIage sex CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save PSA/CHcost_Matrix_PSA, replace
use PSA/trial_control_PSA, clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_0 = (.,.)
forval i = 30/85 {
count if ageMI < `i'+0.05
matrix A_0 = (A_0\0`i',100*r(N)/`N')
}
forval a = 1/4 {
forval b = 30(10)60 {
use PSA/trial_`a'_`b'_PSA, clear
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_`a'_`b' = (.)
forval i = 30/85 {
count if ageMI < `i'+0.05
matrix A_`a'_`b' = (A_`a'_`b'\100*r(N)/`N')
}
}
}
clear
svmat double A_0
svmat double A_1_30
svmat double A_1_40
svmat double A_1_50
svmat double A_1_60
svmat double A_2_30
svmat double A_2_40
svmat double A_2_50
svmat double A_2_60
svmat double A_3_30
svmat double A_3_40
svmat double A_3_50
svmat double A_3_60
svmat double A_4_30
svmat double A_4_40
svmat double A_4_50
svmat double A_4_60
rename A_01 age
save PSA/CumMIfig_overall_PSA_`psa', replace
forval s = 0/1 {
foreach l in 0 3 4 5 {
use PSA/trial_control_PSA, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_0 = (.,.)
forval i = 30/85 {
count if ageMI < `i'+0.05
matrix A_0 = (A_0\0`i',100*r(N)/`N')
}
forval a = 1/4 {
forval b = 30(10)60 {
use PSA/trial_`a'_`b'_PSA, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen ageMI = round(age-durn,0.1) if MI == 1
count
local N = r(N)
matrix A_`a'_`b' = (.)
forval i = 30/85 {
count if ageMI < `i'+0.05
matrix A_`a'_`b' = (A_`a'_`b'\100*r(N)/`N')
}
}
}
clear
svmat double A_0
svmat double A_1_30
svmat double A_1_40
svmat double A_1_50
svmat double A_1_60
svmat double A_2_30
svmat double A_2_40
svmat double A_2_50
svmat double A_2_60
svmat double A_3_30
svmat double A_3_40
svmat double A_3_50
svmat double A_3_60
svmat double A_4_30
svmat double A_4_40
svmat double A_4_50
svmat double A_4_60
rename A_01 age
save PSA/CumMIfig_sex_`s'_LDL`l'_PSA_`psa', replace
}
}
use PSA/trial_control_PSA, clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using PSA/agellt_control_PSA
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using PSA/QALY_nMI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/QALY_MI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 MIage using PSA/ACcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/CHcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
use PSA/trial_`ii'_`i'_PSA, clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using PSA/QALY_nMI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/QALY_MI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 MIage using PSA/ACcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/CHcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save PSA/PSA_overall_PSA_`psa', replace
forval s = 0/1 {
foreach l in 0 3 4 5 {
use PSA/trial_control_PSA, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using PSA/agellt_control_PSA
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using PSA/QALY_nMI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/QALY_MI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 MIage using PSA/ACcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/CHcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
use PSA/trial_`ii'_`i'_PSA, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using PSA/QALY_nMI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/QALY_MI_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 MIage using PSA/ACcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using PSA/CHcost_Matrix_PSA
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
save PSA/PSA_sex_`s'_ldl_`l'_PSA_`psa', replace
}
}
}
}
texdoc stlog close

/***
\color{black}

\subsection{Checks}

Like the OSAs, before doing anything it's good to check there aren't any detectable issues with the PSA. 
First, check for negative incremental QALYs: 

\color{Blue4}
***/

texdoc stlog
forval psa = 1/1000 {
use PSA/PSA_overall_PSA_`psa', clear
quietly count if A2 == 5 & (D1 < 0 | D2 < 0 | D3 < 0 | D4 < 0)
if r(N) != 0 {
di "Oh, bother"
} 
forval s = 0/1 {
foreach l in 0 3 4 5 {
use PSA/PSA_sex_`s'_ldl_`l'_PSA_`psa', clear
quietly count if A2 == 5 & (D1 < 0 | D2 < 0 | D3 < 0 | D4 < 0)
if r(N) != 0 {
di "Oh, bother"
} 
}
}
}
texdoc stlog close


/***
\color{black}

Just one, which is okay and won't impact the 95\% CIs. 
Also, check a few at random to make sure the results are reasonable:

\color{Blue4}
***/

texdoc stlog
quietly {
use reshof0, clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs" if A2 == 6
replace A0 = "Acute MI costs" if A2 == 7
replace A0 = "Chronic MI costs" if A2 == 8
replace A0 = "Total healthcare costs" if A2 == 9
order A0
rename (A3 A4 A5 A6 A7) (Control LMS HIS LSE INC)
}
di "Base-case"
list A0 Control LMS HIS LSE INC in 1/9, separator(0)
forval i = 1/10 {
local psa = runiformint(1,1000)
quietly { 
use PSA/PSA_overall_PSA_`psa', clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs" if A2 == 6
replace A0 = "Acute MI costs" if A2 == 7
replace A0 = "Chronic MI costs" if A2 == 8
replace A0 = "Total healthcare costs" if A2 == 9
order A0
rename (A3 A4 A5 A6 A7) (Control LMS HIS LSE INC)
}
di "`psa'"
list A0 Control LMS HIS LSE INC in 1/9, separator(0)
}
texdoc stlog close

/***
\color{black}

With those checks, there's some confidence there isn't a huge mistake with the PSA.
From here, results can be presented. There are a couple of results that would be enhanced
by the inclusion of PSA results -- the cumulative MI figures and the base-case results
tables -- as well as plotting the results of the PSAs across a common cost-effectiveness
plane. 

\subsection{Results: Cumulative incidence of MI}

Let's start with the figures.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
clear
forval i = 1/1000 {
append using PSA/CumMIfig_overall_PSA_`i'
}
matrix A = (.,.,.,.)
forval iii = 30/84 {
centile A_02 if age == `iii', centile(50 2.5 97.5)
matrix A = (A\0`iii',r(c_1),r(c_2),r(c_3))
}
matrix A_control = A
forval i = 1/4 {
forval ii = 30(10)60 {
matrix A = (.,.,.)
forval iii = 30/84 {
centile A_`i'_`ii' if age == `iii', centile(50 2.5 97.5)
matrix A = (A\r(c_1),r(c_2),r(c_3)) 
}
matrix A_`i'_`ii' = A
}
}
clear
svmat double A_control
forval i = 1/4 {
forval ii = 30(10)60 {
svmat double A_`i'_`ii'
}
}
rename A_control1 age
replace age = round(age,1)
save FigCI_overall, replace
use inferno, clear
local viri60 = var6[6]
local viri61 = var6[5]
local viri62 = var6[4]
local viri63 = var6[3]
local viri64 = var6[2]
forval i = 1/4 {
if `i' == 1 {
local ii = "Low/moderate intensity statins"
}
if `i' == 2 {
local ii = "High intensity statins"
}
if `i' == 3 {
local ii = "Low/moderate intensity statins and ezetimibe"
}
if `i' == 4 {
local ii = "Inclisiran"
}
use FigCI_overall, clear
replace age = round(age,0.1)
drop if age > 84
twoway ///
(rarea A_control3 A_control4 age, color("`viri60'%30") fintensity(inten80) lwidth(none)) ///
(line A_control2 age, col("`viri60'")) ///
(rarea A_`i'_602 A_`i'_603 age, color("`viri61'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_601 age, col("`viri61'")) ///
(rarea A_`i'_502 A_`i'_503 age, color("`viri62'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_501 age, col("`viri62'")) ///
(rarea A_`i'_402 A_`i'_403 age, color("`viri63'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_401 age, col("`viri63'")) ///
(rarea A_`i'_302 A_`i'_303 age, color("`viri64'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_301 age, col("`viri64'")) ///
, legend(order(2 "Control" ///
4 "Intervention from age 60" ///
6 "Intervention from age 50" ///
8 "Intervention from age 40" ///
10 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(0(5)20,angle(0)) ///
title("`ii'", placement(west) color(black) size(medium))
graph save "Graph" GPH/PSAfig1_`i', replace
}
forval s = 0/1 {
foreach l in 0 3 4 5 {
clear
forval i = 1/1000 {
append using PSA/CumMIfig_sex_`s'_LDL`l'_PSA_`i'
}
matrix A = (.,.,.,.)
forval iii = 30/84 {
centile A_02 if age == `iii', centile(50 2.5 97.5)
matrix A = (A\0`iii',r(c_1),r(c_2),r(c_3))
}
matrix A_control = A
forval i = 1/4 {
forval ii = 30(10)60 {
matrix A = (.,.,.)
forval iii = 30/84 {
centile A_`i'_`ii' if age == `iii', centile(50 2.5 97.5)
matrix A = (A\r(c_1),r(c_2),r(c_3)) 
}
matrix A_`i'_`ii' = A
}
}
clear
svmat double A_control
forval i = 1/4 {
forval ii = 30(10)60 {
svmat double A_`i'_`ii'
}
}
rename A_control1 age
replace age = round(age,1)
save FigCI_overall_sex_`s'_ldl_`l', replace
if `s' == 0 {
use inferno, clear
local ss = "females"
local sss = "Females"
}
else {
use viridis, clear
local ss = "males"
local sss = "Males"
}
local viri60 = var6[6]
local viri61 = var6[5]
local viri62 = var6[4]
local viri63 = var6[3]
local viri64 = var6[2]
forval i = 1/4 {
if `i' == 1 {
local ii = "Low/moderate intensity statins"
}
if `i' == 2 {
local ii = "High intensity statins"
}
if `i' == 3 {
local ii = "Low/moderate intensity statins and ezetimibe"
}
if `i' == 4 {
local ii = "Inclisiran"
}
use FigCI_overall_sex_`s'_ldl_`l', clear
replace age = round(age,0.1)
drop if age > 84
if `l' == 0 {
twoway ///
(rarea A_control3 A_control4 age, color("`viri60'%30") fintensity(inten80) lwidth(none)) ///
(line A_control2 age, col("`viri60'")) ///
(rarea A_`i'_602 A_`i'_603 age, color("`viri61'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_601 age, col("`viri61'")) ///
(rarea A_`i'_502 A_`i'_503 age, color("`viri62'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_501 age, col("`viri62'")) ///
(rarea A_`i'_402 A_`i'_403 age, color("`viri63'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_401 age, col("`viri63'")) ///
(rarea A_`i'_302 A_`i'_303 age, color("`viri64'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_301 age, col("`viri64'")) ///
, legend(order(2 "Control" ///
4 "Intervention from age 60" ///
6 "Intervention from age 50" ///
8 "Intervention from age 40" ///
10 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(0(5)25,angle(0)) ///
title("`ii', `ss'", placement(west) color(black) size(medium))
graph save "Graph" GPH/PSAfig1_`i'_sex_`s'_ldl_`l', replace
twoway ///
(rarea A_control3 A_control4 age, color("`viri60'%30") fintensity(inten80) lwidth(none)) ///
(line A_control2 age, col("`viri60'")) ///
(rarea A_`i'_602 A_`i'_603 age, color("`viri61'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_601 age, col("`viri61'")) ///
(rarea A_`i'_502 A_`i'_503 age, color("`viri62'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_501 age, col("`viri62'")) ///
(rarea A_`i'_402 A_`i'_403 age, color("`viri63'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_401 age, col("`viri63'")) ///
(rarea A_`i'_302 A_`i'_303 age, color("`viri64'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_301 age, col("`viri64'")) ///
, legend(order(2 "Control" ///
4 "Intervention from age 60" ///
6 "Intervention from age 50" ///
8 "Intervention from age 40" ///
10 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(0(10)50,angle(0)) ///
title("All `ss'", placement(west) color(black) size(medium))
graph save "Graph" GPH/PSAfig1_`i'_sex_`s'_ldl_`l'_1, replace
}
else {
twoway ///
(rarea A_control3 A_control4 age, color("`viri60'%30") fintensity(inten80) lwidth(none)) ///
(line A_control2 age, col("`viri60'")) ///
(rarea A_`i'_602 A_`i'_603 age, color("`viri61'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_601 age, col("`viri61'")) ///
(rarea A_`i'_502 A_`i'_503 age, color("`viri62'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_501 age, col("`viri62'")) ///
(rarea A_`i'_402 A_`i'_403 age, color("`viri63'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_401 age, col("`viri63'")) ///
(rarea A_`i'_302 A_`i'_303 age, color("`viri64'%30") fintensity(inten80) lwidth(none)) ///
(line A_`i'_301 age, col("`viri64'")) ///
, legend(order(2 "Control" ///
4 "Intervention from age 60" ///
6 "Intervention from age 50" ///
8 "Intervention from age 40" ///
10 "Intervention from age 30") ///
cols(1) ring(0) position(11) region(lcolor(white) color(none))) ///
graphregion(color(white)) ///
ytitle(Cumulative incidence of MI or coronary death (%)) xtitle(Age) ///
ylabel(0(10)50,angle(0)) ///
title("`sss' with LDL-C ≥`l'.0 mmol/L", placement(west) color(black) size(medium))
graph save "Graph" GPH/PSAfig1_`i'_sex_`s'_ldl_`l', replace
}
}
}
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/PSAfig1_1.gph ///
GPH/PSAfig1_2.gph ///
GPH/PSAfig1_3.gph ///
GPH/PSAfig1_4.gph ///
, altshrink cols(2) xsize(5) graphregion(color(white))
texdoc graph, label(PSArfig1) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by intervention)
graph combine ///
GPH/PSAfig1_1_sex_0_ldl_0.gph ///
GPH/PSAfig1_1_sex_1_ldl_0.gph ///
GPH/PSAfig1_2_sex_0_ldl_0.gph ///
GPH/PSAfig1_2_sex_1_ldl_0.gph ///
GPH/PSAfig1_3_sex_0_ldl_0.gph ///
GPH/PSAfig1_3_sex_1_ldl_0.gph ///
GPH/PSAfig1_4_sex_0_ldl_0.gph ///
GPH/PSAfig1_4_sex_1_ldl_0.gph ///
, altshrink cols(2) xsize(3) graphregion(color(white))
texdoc graph, label(PSArfig2) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by intervention and sex)
graph combine ///
GPH/PSAfig1_1_sex_0_ldl_0_1.gph ///
GPH/PSAfig1_1_sex_1_ldl_0_1.gph ///
GPH/PSAfig1_1_sex_0_ldl_3.gph ///
GPH/PSAfig1_1_sex_1_ldl_3.gph ///
GPH/PSAfig1_1_sex_0_ldl_4.gph ///
GPH/PSAfig1_1_sex_1_ldl_4.gph ///
GPH/PSAfig1_1_sex_0_ldl_5.gph ///
GPH/PSAfig1_1_sex_1_ldl_5.gph ///
, altshrink cols(2) xsize(3) graphregion(color(white))
texdoc graph, label(PSArfig3) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by sex, LDL-C, and age of intervention -- Low/moderate intensity statins)
graph combine ///
GPH/PSAfig1_2_sex_0_ldl_0_1.gph ///
GPH/PSAfig1_2_sex_1_ldl_0_1.gph ///
GPH/PSAfig1_2_sex_0_ldl_3.gph ///
GPH/PSAfig1_2_sex_1_ldl_3.gph ///
GPH/PSAfig1_2_sex_0_ldl_4.gph ///
GPH/PSAfig1_2_sex_1_ldl_4.gph ///
GPH/PSAfig1_2_sex_0_ldl_5.gph ///
GPH/PSAfig1_2_sex_1_ldl_5.gph ///
, altshrink cols(2) xsize(3) graphregion(color(white))
texdoc graph, label(PSArfig4) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by sex, LDL-C, and age of intervention -- High intensity statins)
graph combine ///
GPH/PSAfig1_3_sex_0_ldl_0_1.gph ///
GPH/PSAfig1_3_sex_1_ldl_0_1.gph ///
GPH/PSAfig1_3_sex_0_ldl_3.gph ///
GPH/PSAfig1_3_sex_1_ldl_3.gph ///
GPH/PSAfig1_3_sex_0_ldl_4.gph ///
GPH/PSAfig1_3_sex_1_ldl_4.gph ///
GPH/PSAfig1_3_sex_0_ldl_5.gph ///
GPH/PSAfig1_3_sex_1_ldl_5.gph ///
, altshrink cols(2) xsize(3) graphregion(color(white))
texdoc graph, label(PSArfig5) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by sex, LDL-C, and age of intervention -- Low/moderate intensity statins and ezetimibe)
graph combine ///
GPH/PSAfig1_4_sex_0_ldl_0_1.gph ///
GPH/PSAfig1_4_sex_1_ldl_0_1.gph ///
GPH/PSAfig1_4_sex_0_ldl_3.gph ///
GPH/PSAfig1_4_sex_1_ldl_3.gph ///
GPH/PSAfig1_4_sex_0_ldl_4.gph ///
GPH/PSAfig1_4_sex_1_ldl_4.gph ///
GPH/PSAfig1_4_sex_0_ldl_5.gph ///
GPH/PSAfig1_4_sex_1_ldl_5.gph ///
, altshrink cols(2) xsize(3) graphregion(color(white))
texdoc graph, label(PSArfig6) fontface("Liberation Sans") caption(Cumulative incidence of MI or coronary death, by sex, LDL-C, and age of intervention -- Inclisiran)
texdoc stlog close

/***
\color{black}

\subsection{Results: Tables}

It's also worth presenting the full results of the simulations
even if they will be very messy:

\color{Blue4}
***/


texdoc stlog, cmdlog nodo
clear
forval psa = 1/1000 {
append using PSA/PSA_overall_PSA_`psa'
}
foreach a of varlist A3-D4 {
forval i = 30(10)60 {
forval ii = 1/10 {
centile `a' if A1 == `i' & A2 == `ii', centile(50 2.5 97.5)
if `i' == 30 & `ii' == 1 {
matrix A`a' = (r(c_1),r(c_2),r(c_3))
}
else {
matrix A`a' = (A`a'\r(c_1),r(c_2),r(c_3))
}
}
}
}
keep A1 A2
keep if _n <= 40
svmat double AA3
svmat double AA4
svmat double AA5
svmat double AA6
svmat double AA7
svmat double AD1
svmat double AD2
svmat double AD3
svmat double AD4
save reshofpsa, replace
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling, millions)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling, millions)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling, millions)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling, millions)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*AD11/AA31
gen P2 = 100*AD21/AA31
gen P3 = 100*AD31/AA31
gen P4 = 100*AD41/AA31
tostring AA31-AD43, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
forval i = 3/7 {
local j = `i'-2
gen A`i' = AA`i'1 + " (" + AA`i'2 + ", " + AA`i'3 + ")" if A2 !=10
}
forval i = 1/4 {
gen D`i' = AD`i'1 + "; " + P`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D`i' = AD`i'1 + "; " + p`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 4 | A2 == 5
replace D`i' = AD`i'1 + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 1 | A2 == 10
}
preserve
keep A00 A0 A3 A4 D1
export delimited using CSV/Res_HOF_PSA_1.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A5 D2
export delimited using CSV/Res_HOF_PSA_2.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A6 D3
export delimited using CSV/Res_HOF_PSA_3.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A7 D4
export delimited using CSV/Res_HOF_PSA_4.csv, delimiter(":") novarnames replace
restore
use reshofpsa, clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling, millions)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling, millions)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling, millions)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling, millions)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*AD11/AA31
gen P2 = 100*AD21/AA31
gen P3 = 100*AD31/AA31
gen P4 = 100*AD41/AA31
foreach var of varlist AA31-AD43 {
replace `var' = `var'/1000000 if inrange(A2,6,9)
}
tostring AA31-AD43, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
forval i = 3/7 {
local j = `i'-2
gen A`i' = AA`i'1 + " (" + AA`i'2 + ", " + AA`i'3 + ")" if A2 !=10
}
forval i = 1/4 {
gen D`i' = AD`i'1 + "; " + P`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D`i' = AD`i'1 + "; " + p`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 4 | A2 == 5
replace D`i' = AD`i'1 + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 1 | A2 == 10
}
keep A00 A0 A3 D1 D2 D3 D4
export delimited using CSV/Res_HOF_PSA.csv, delimiter(":") novarnames replace
forval s = 0/1 {
foreach l in 0 3 4 5 {
clear
forval psa = 1/1000 {
append using PSA/PSA_sex_`s'_ldl_`l'_PSA_`psa'
}
foreach a of varlist A3-D4 {
forval i = 30(10)60 {
forval ii = 1/10 {
centile `a' if A1 == `i' & A2 == `ii', centile(50 2.5 97.5)
if `i' == 30 & `ii' == 1 {
matrix A`a' = (r(c_1),r(c_2),r(c_3))
}
else {
matrix A`a' = (A`a'\r(c_1),r(c_2),r(c_3))
}
}
}
}
keep A1 A2
keep if _n <= 40
svmat double AA3
svmat double AA4
svmat double AA5
svmat double AA6
svmat double AA7
svmat double AD1
svmat double AD2
svmat double AD3
svmat double AD4
save reshofpsa`s'`l', replace
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*AD11/AA31
gen P2 = 100*AD21/AA31
gen P3 = 100*AD31/AA31
gen P4 = 100*AD41/AA31
tostring AA31-AD43, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
forval i = 3/7 {
local j = `i'-2
gen A`i' = AA`i'1 + " (" + AA`i'2 + ", " + AA`i'3 + ")" if A2 !=10
}
forval i = 1/4 {
gen D`i' = AD`i'1 + "; " + P`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D`i' = AD`i'1 + "; " + p`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 4 | A2 == 5
replace D`i' = AD`i'1 + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 1 | A2 == 10
}
preserve
keep A00 A0 A3 A4 D1
export delimited using CSV/Res_HOF_PSA_1_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A5 D2
export delimited using CSV/Res_HOF_PSA_2_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A6 D3
export delimited using CSV/Res_HOF_PSA_3_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A7 D4
export delimited using CSV/Res_HOF_PSA_4_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
restore
use reshofpsa`s'`l', clear
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling, millions)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling, millions)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling, millions)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling, millions)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*AD11/AA31
gen P2 = 100*AD21/AA31
gen P3 = 100*AD31/AA31
gen P4 = 100*AD41/AA31
foreach var of varlist AA31-AD43 {
replace `var' = `var'/1000000 if inrange(A2,6,9)
}
tostring AA31-AD43, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
forval i = 3/7 {
local j = `i'-2
gen A`i' = AA`i'1 + " (" + AA`i'2 + ", " + AA`i'3 + ")" if A2 !=10
}
forval i = 1/4 {
gen D`i' = AD`i'1 + "; " + P`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D`i' = AD`i'1 + "; " + p`i' + "\%" + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 4 | A2 == 5
replace D`i' = AD`i'1 + " (" + AD`i'2 + ", " + AD`i'3 + ")" if A2 == 1 | A2 == 10
}
keep A00 A0 A3 D1 D2 D3 D4

if `l' == 0 {
save reshoftable1_`s', replace
}
export delimited using CSV/Res_HOF_PSA_sex_`s'_ldl_`l'.csv, delimiter(":") novarnames replace
}
}
texdoc stlog close

/***
\color{black}

This is extremely long/messy, so go to tables~\ref{Microsim5PSA} -- ~\ref{Microsim5PSA15} for the summaries. 

\begin{landscape}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins}
    \label{Microsim1PSA}
	\hspace*{-2.00cm}
     \fontsize{0.1pt}{0.15pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins}
    \label{Microsim2PSA}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe}
    \label{Microsim3PSA}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran}
    \label{Microsim4PSA}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- All females}
    \label{Microsim1PSA00}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- All females}
    \label{Microsim2PSA00}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_0_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- All females}
    \label{Microsim3PSA00}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- All females}
    \label{Microsim4PSA00}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_0_ldl_0.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Females with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim1PSA03}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Females with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim2PSA03}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_0_ldl_3.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Females with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim3PSA03}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Females with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim4PSA03}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_0_ldl_3.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Females with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim1PSA04}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Females with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim2PSA04}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_0_ldl_4.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Females with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim3PSA04}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Females with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim4PSA04}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_0_ldl_4.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Females with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim1PSA05}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Females with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim2PSA05}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_0_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Females with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim3PSA05}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_0_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Females with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim4PSA05}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_0_ldl_5.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- All males}
    \label{Microsim1PSA10}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_1_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- All males}
    \label{Microsim2PSA10}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- All males}
    \label{Microsim3PSA10}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_1_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- All males}
    \label{Microsim4PSA10}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_1_ldl_0.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Males with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim1PSA13}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Males with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim2PSA13}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_1_ldl_3.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Males with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim3PSA13}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Males with LDL-C $\geq$3.0 mmol/L}
    \label{Microsim4PSA13}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_1_ldl_3.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Males with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim1PSA14}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Males with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim2PSA14}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_1_ldl_4.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Males with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim3PSA14}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Males with LDL-C $\geq$4.0 mmol/L}
    \label{Microsim4PSA14}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_1_ldl_4.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins -- Males with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim1PSA15}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_1_sex_1_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- High intensity statins -- Males with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim2PSA15}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_2_sex_1_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Low/moderate intensity statins and ezetimibe -- Males with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim3PSA15}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_3_sex_1_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Inclisiran -- Males with LDL-C $\geq$5.0 mmol/L}
    \label{Microsim4PSA15}
	\hspace*{-2.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_4_sex_1_ldl_5.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions.}
    \label{Microsim5PSA}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- All females.}
    \label{Microsim5PSA00}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_0_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Females with LDL-C $\geq$3.0 mmol/L.}
    \label{Microsim5PSA03}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_0_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Females with LDL-C $\geq$4.0 mmol/L.}
    \label{Microsim5PSA04}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_0_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Females with LDL-C $\geq$5.0 mmol/L.}
    \label{Microsim5PSA05}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_0_ldl_5.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- All males.}
    \label{Microsim5PSA10}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_1_ldl_0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Males with LDL-C $\geq$3.0 mmol/L.}
    \label{Microsim5PSA13}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_1_ldl_3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Males with LDL-C $\geq$4.0 mmol/L.}
    \label{Microsim5PSA14}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_1_ldl_4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{PSA results -- Summary of all interventions -- Males with LDL-C $\geq$5.0 mmol/L.}
    \label{Microsim5PSA15}
	\hspace*{-3.00cm}
     \fontsize{1pt}{1.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name=Control, column type={r}, column type/.add={}{|}},
      display columns/3/.style={column name=\specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}, column type/.add={}{|}},
      display columns/4/.style={column name=High intensity statins, column type={r}, column type/.add={}{|}},
      display columns/5/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}, column type/.add={}{|}},
      display columns/6/.style={column name=Inclisiran, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & \multicolumn{1}{c}{Absolute value} & \multicolumn{4}{c}{Difference to control}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sex_1_ldl_5.csv}
  \end{center}
\end{table}

\end{landscape}


\clearpage

I think it would also be nice to have another concise summary tables to present in the main body
of the paper to demonstrate the changes in outcomes by sex and LDL-C. Thus, I will make a table containing
only the incremental QALYs and costs (per person), by intervention, sex, and LDL-C. 


\color{Blue4}
***/

texdoc stlog, cmdlog nodo
forval s = 0/1 {
foreach l in 0 3 4 5 {
clear
gen sim =.
forval psa = 1/1000 {
append using PSA/PSA_sex_`s'_ldl_`l'_PSA_`psa'
recode sim .=`psa'
}
keep if A2 == 1 | A2 == 5 | A2 == 9 | A2 == 10
bysort sim A1 (A2) : replace D1 = D1/A4[1] if A2 != 10
bysort sim A1 (A2) : replace D2 = D2/A4[1] if A2 != 10
bysort sim A1 (A2) : replace D3 = D3/A4[1] if A2 != 10
bysort sim A1 (A2) : replace D4 = D4/A4[1] if A2 != 10
foreach a of varlist D1-D4 {
forval i = 30(10)60 {
foreach ii in 5 9 10 {
centile `a' if A1 == `i' & A2 == `ii', centile(50 2.5 97.5)
if `i' == 30 & `ii' == 5 {
matrix A`a' = (r(c_1),r(c_2),r(c_3))
}
else {
matrix A`a' = (A`a'\r(c_1),r(c_2),r(c_3))
}
}
}
}
drop if sim !=1
drop if A2 == 1
keep A1 A2
svmat double AD1
svmat double AD2
svmat double AD3
svmat double AD4
gen sex = `s'
gen ldl = `l'
save sumtable_`s'_`l', replace
}
}
clear 
forval s = 0/1 {
foreach l in 0 3 4 5 {
append using sumtable_`s'_`l'
}
}
foreach i in 11 12 13 21 22 23 31 32 33 41 42 43 {
tostring AD`i', gen(AD`i'1) force format(%9.3f)
tostring AD`i', gen(AD`i'2) force format(%9.1fc)
tostring AD`i', gen(AD`i'3) force format(%9.0fc)
gen BD`i' = AD`i'1 if A2 == 5
replace BD`i' = AD`i'2 if A2 == 9
replace BD`i' = AD`i'3 if A2 == 10
drop AD`i'-AD`i'1
}
forval i = 1/4 {
gen C`i' = BD`i'1 + " (" + BD`i'2 + ", " + BD`i'3 + ")"
}
keep A1-ldl C1-C4
reshape long C, i(A1 A2 sex ldl) j(intn)
reshape wide C, i(sex intn A1 A2) j(ldl)

gen A0 = ""
replace A0 = "QALYs (per person)" if A2 == 5
replace A0 = "Total healthcare costs (\textsterling, per person)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 =""
bysort sex intn A1 (A2) : replace A00 = "30" if _n == 1 & A1 == 30
bysort sex intn A1 (A2) : replace A00 = "40" if _n == 1 & A1 == 40
bysort sex intn A1 (A2) : replace A00 = "50" if _n == 1 & A1 == 50
bysort sex intn A1 (A2) : replace A00 = "60" if _n == 1 & A1 == 60
gen A000 = ""
bysort sex intn (A1 A2) : replace A000 = "\specialcell{\noindent Low/moderate \\ intensity statins}" if intn == 1 & _n == 1
bysort sex intn (A1 A2) : replace A000 = "High intensity statins" if intn == 2 & _n == 1
bysort sex intn (A1 A2) : replace A000 = "\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}" if intn == 3 & _n == 1
bysort sex intn (A1 A2) : replace A000 = "Inclisiran" if intn == 4 & _n == 1
order A000 A00 A0 C0 C3 C4 C5
preserve
keep if sex == 0
keep A000-C5
export delimited using CSV/Res_HOF_PSA_sum0.csv, delimiter(":") novarnames replace
restore
keep if sex == 1
keep A000-C5
export delimited using CSV/Res_HOF_PSA_sum1.csv, delimiter(":") novarnames replace
texdoc stlog close

/***
\color{black}

\begin{landscape}

\begin{table}[h!]
  \begin{center}
    \caption{Summary of all interventions by LDL-C -- Females.}
    \label{PSAsum0}
	\hspace*{-2cm}
     \fontsize{5pt}{6.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{12}{*}{##1}}}},
	  display columns/1/.style={column name=\specialcell{Age of \\ intervention},
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{3}{*}{##1}}}},
      display columns/2/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=All, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					& & & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={12}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sum0.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Summary of all interventions by LDL-C -- Males.}
    \label{PSAsum1}
	\hspace*{-2cm}
     \fontsize{5pt}{6.5pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{12}{*}{##1}}}},
	  display columns/1/.style={column name=\specialcell{Age of \\ intervention},
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{3}{*}{##1}}}},
      display columns/2/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/3/.style={column name=All, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=$\geq$3.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/5/.style={column name=$\geq$4.0 mmol/L, column type={r}, column type/.add={}{}},
      display columns/6/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					& & & \multicolumn{4}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every nth row={12}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_PSA_sum1.csv}
  \end{center}
\end{table}

\end{landscape}


\subsection{Results: Simulations in a CE plane}

Finally, as the last result from the PSA, the results of the simulations can be presented in a common CE plane.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
clear
gen sim =.
forval psa = 1/1000 { 
append using PSA/PSA_overall_PSA_`psa'
recode sim .=`psa'
}
keep if A2 == 1 | A2 == 5 | A2 == 9
bysort sim A1 (A2) : replace D1 = D1/A4[1]
bysort sim A1 (A2) : replace D2 = D2/A4[1]
bysort sim A1 (A2) : replace D3 = D3/A4[1]
bysort sim A1 (A2) : replace D4 = D4/A4[1]
drop if A2 == 1
keep sim A1 A2 D1-D4
reshape wide D1-D4, i(A1 sim) j(A2)
save PSAscatter0, replace
use inferno, clear
local col1 = var5[5]
local col2 = var5[4]
local col3 = var5[3]
local col4 = var5[2]
use PSAscatter0, clear
forval i = 30(10)60 {
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(scatter D49 D45 if A1 == `i', msize(vsmall) col("`col4'")) ///
(function y = x*20000, ra(0 0.1) col(magenta)) ///
(function y = x*30000, ra(0 0.1) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe" ///
4 "Inclisiran") ///
cols(1) ring(0) position(9) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(,angle(0) format(%9.0fc)) xlabel(, format(%9.2f)) ///
title("Intervention from age `i'", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter0_`i', replace
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/PSAscatter0_30.gph ///
GPH/PSAscatter0_40.gph ///
GPH/PSAscatter0_50.gph ///
GPH/PSAscatter0_60.gph ///
, graphregion(color(white)) altshrink cols(1) xsize(1.5)
texdoc graph, label(Scatter0) fontface("Liberation Sans") optargs(width=0.5\textwidth) ///
caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention.)
texdoc stlog close

/***
\color{black}

Right, so I think it's worth repeating that figure (figure~\ref{Scatter0})
without Inclisiran, so the other interventions can be seen. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
use inferno, clear
local col1 = var5[5]
local col2 = var5[4]
local col3 = var5[3]
use PSAscatter0, clear
forval i = 30(10)60 {
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(function y = x*20000, ra(0 0.05) col(magenta)) ///
(function y = x*30000, ra(0 0.0333) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe") ///
cols(1) ring(0) position(10) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(0(200)1000, angle(0) format(%9.0fc)) xlabel(0(0.02)0.1, format(%9.2f)) ///
yscale(range(0 1300)) xscale(range(0 0.11)) ///
title("Intervention from age `i'", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter1_`i', replace
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/PSAscatter1_30.gph ///
GPH/PSAscatter1_40.gph ///
GPH/PSAscatter1_50.gph ///
GPH/PSAscatter1_60.gph ///
, graphregion(color(white)) altshrink cols(1) xsize(1.5)
texdoc graph, label(Scatter1) fontface("Liberation Sans") optargs(width=0.5\textwidth) ///
caption(PSA simulations presented in a common cost-effectiveness plane, ///
by age of intervention, excluding Inclisiran. Solid line: ///
\textsterling 20,000 per QALY willingness-to-pay threshold; dashed line: ///
\textsterling 30,000 per QALY willingness-to-pay threshold)
use PSAscatter0, clear
gen ICER1 = D19/D15
gen ICER2 = D29/D25
gen ICER3 = D39/D35
forval i = 30(10)60 {
forval ii = 1/3 {
count if ICER`ii' < 30000 & A1 == `i'
count if ICER`ii' < 20000 & A1 == `i'
count if ICER`ii' < 0 & A1 == `i'
}
}
texdoc stlog close

/***
\color{black}

Much better (figure~\ref{Scatter1}). 
These three interventions are cost-effective at both thresholds at all ages, with 
the exception of low/moderate intensity statins and ezetimibe at age 60, 
where 100\% of simulations are cost-effective at the \textsterling 30,000 
per QALY willingness-to-pay threshold, but only 50\% meet the \textsterling
20,000 threshold. Additionally, in the total population, none of the interventions
are cost-saving. Inclisiran is not cost-effective in any simulation. 

As usual, let's now stratify by sex.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
clear
gen sim =.
gen sex =.
forval s = 0/1 {
forval psa = 1/1000 { 
append using PSA/PSA_sex_`s'_ldl_0_PSA_`psa'
recode sim .=`psa'
}
recode sex .=`s'
}
keep if A2 == 1 | A2 == 5 | A2 == 9
bysort sex sim A1 (A2) : replace D1 = D1/A4[1]
bysort sex sim A1 (A2) : replace D2 = D2/A4[1]
bysort sex sim A1 (A2) : replace D3 = D3/A4[1]
bysort sex sim A1 (A2) : replace D4 = D4/A4[1]
drop if A2 == 1
keep sex sim A1 A2 D1-D4
reshape wide D1-D4, i(sex A1 sim) j(A2)
save PSAscattersex, replace
forval s = 0/1 {
if `s' == 0 {
use inferno, clear
local ss = "Females"
}
else {
use viridis, clear
local ss = "Males"
}
local col1 = var5[5]
local col2 = var5[4]
local col3 = var5[3]
local col4 = var5[2]
use PSAscattersex, clear
keep if sex == `s'
forval i = 30(10)60 {
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(scatter D49 D45 if A1 == `i', msize(vsmall) col("`col4'")) ///
(function y = x*20000, ra(0 0.15) col(magenta)) ///
(function y = x*30000, ra(0 0.15) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe" ///
4 "Inclisiran") ///
cols(1) ring(0) position(3) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(,angle(0) format(%9.0fc)) xlabel(0(0.02)0.14, format(%9.2f)) ///
yscale(range(0 50000)) ylabel(0(10000)50000, format(%9.0fc)) xscale(range(0 0.15)) ///
title("Intervention from age `i' - `ss'", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter0sex_`s'_`i', replace
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(function y = x*20000, ra(0 0.05) col(magenta)) ///
(function y = x*30000, ra(0 0.0333) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe") ///
cols(1) ring(0) position(10) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(0(200)1000, angle(0) format(%9.0fc)) xlabel(0(0.02)0.14, format(%9.2f)) ///
yscale(range(-100 1300)) yline(0, lcol(black)) xscale(range(0 0.15)) ///
title("Intervention from age `i' - `ss'", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter1sex_`s'_`i', replace
}
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/PSAscatter0sex_0_30.gph ///
GPH/PSAscatter0sex_1_30.gph ///
GPH/PSAscatter0sex_0_40.gph ///
GPH/PSAscatter0sex_1_40.gph ///
GPH/PSAscatter0sex_0_50.gph ///
GPH/PSAscatter0sex_1_50.gph ///
GPH/PSAscatter0sex_0_60.gph ///
GPH/PSAscatter0sex_1_60.gph ///
, graphregion(color(white)) altshrink cols(2) xsize(3.3)
texdoc graph, label(Scatter0sex) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and sex.)
graph combine ///
GPH/PSAscatter1sex_0_30.gph ///
GPH/PSAscatter1sex_1_30.gph ///
GPH/PSAscatter1sex_0_40.gph ///
GPH/PSAscatter1sex_1_40.gph ///
GPH/PSAscatter1sex_0_50.gph ///
GPH/PSAscatter1sex_1_50.gph ///
GPH/PSAscatter1sex_0_60.gph ///
GPH/PSAscatter1sex_1_60.gph ///
, graphregion(color(white)) altshrink cols(2) xsize(3.3)
texdoc graph, label(Scatter1sex) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and sex, excluding Inclisiran. Solid line: \textsterling 20,000 per QALY willingness-to-pay threshold; dashed line: \textsterling 30,000 per QALY willingness-to-pay threshold)
texdoc stlog close

/***
\color{black}

This is much more interesting (figure~\ref{Scatter1sex}) -- 
all simulations are cost-effective for the first three interventions in males at all ages,
whereas only the first have most simulations under both willingness-to-pay thresholds.
By LDL-C: 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
foreach l in 3 4 5 {
clear
gen sim =.
gen sex =.
forval s = 0/1 {
forval psa = 1/1000 { 
append using PSA/PSA_sex_`s'_ldl_`l'_PSA_`psa'
recode sim .=`psa'
}
recode sex .=`s'
}
keep if A2 == 1 | A2 == 5 | A2 == 9
bysort sex sim A1 (A2) : replace D1 = D1/A4[1]
bysort sex sim A1 (A2) : replace D2 = D2/A4[1]
bysort sex sim A1 (A2) : replace D3 = D3/A4[1]
bysort sex sim A1 (A2) : replace D4 = D4/A4[1]
drop if A2 == 1
keep sex sim A1 A2 D1-D4
reshape wide D1-D4, i(sex A1 sim) j(A2)
save PSAscattersex_ldl_`l', replace
forval s = 0/1 {
if `s' == 0 {
use inferno, clear
local ss = "Females"
}
else {
use viridis, clear
local ss = "Males"
}
local col1 = var5[5]
local col2 = var5[4]
local col3 = var5[3]
local col4 = var5[2]
use PSAscattersex_ldl_`l', clear
keep if sex == `s'
forval i = 30(10)60 {
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(scatter D49 D45 if A1 == `i', msize(vsmall) col("`col4'")) ///
(function y = x*20000, ra(0 0.4) col(magenta)) ///
(function y = x*30000, ra(0 0.4) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe" ///
4 "Inclisiran") ///
cols(1) ring(0) position(3) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(0(10000)50000,angle(0) format(%9.0fc)) xlabel(, format(%9.2f)) ///
yscale(range(0 50000)) ///
title("Intervention from age `i' - `ss' with LDL-C ≥`l'.0 mmol/L", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter0sexldl_`s'_`l'_`i', replace
twoway ///
(scatter D19 D15 if A1 == `i', msize(vsmall) col("`col1'")) ///
(scatter D29 D25 if A1 == `i', msize(vsmall) col("`col2'")) ///
(scatter D39 D35 if A1 == `i', msize(vsmall) col("`col3'")) ///
(function y = x*20000, ra(0 0.05) col(magenta)) ///
(function y = x*30000, ra(0 0.0333) col(magenta) lpattern(dash)) ///
, graphregion(color(white)) ///
legend(order(1 "Low/moderate intensity statins" ///
2 "High intensity statins" ///
3 "Low/moderate intensity statins and ezetimibe") ///
cols(1) ring(0) position(10) region(lcolor(white) color(none))) ///
ytitle("Incremental costs (£ per person)") xtitle("Incremental QALYs (per person)") ///
ylabel(-1000(200)1000, angle(0) format(%9.0fc)) xlabel(0(0.1)0.4, format(%9.2f)) ///
yscale(range(-1200 1600)) yline(0, lcol(black)) xscale(range(0 0.45)) ///
title("Intervention from age `i' - `ss' with LDL-C ≥`l'.0 mmol/L", col(black) size(medium) placement(west))
graph save "Graph" GPH/PSAscatter1sexldl_`s'_`l'_`i', replace
}
}
}
texdoc stlog close
texdoc stlog, cmdlog
graph combine ///
GPH/PSAscatter0sexldl_0_3_30.gph ///
GPH/PSAscatter0sexldl_0_4_30.gph ///
GPH/PSAscatter0sexldl_0_5_30.gph ///
GPH/PSAscatter0sexldl_0_3_40.gph ///
GPH/PSAscatter0sexldl_0_4_40.gph ///
GPH/PSAscatter0sexldl_0_5_40.gph ///
GPH/PSAscatter0sexldl_0_3_50.gph ///
GPH/PSAscatter0sexldl_0_4_50.gph ///
GPH/PSAscatter0sexldl_0_5_50.gph ///
GPH/PSAscatter0sexldl_0_3_60.gph ///
GPH/PSAscatter0sexldl_0_4_60.gph ///
GPH/PSAscatter0sexldl_0_5_60.gph ///
, graphregion(color(white)) altshrink cols(3) xsize(4)
texdoc graph, label(Scatter0sexldl0) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and LDL-C. Females.)
graph combine ///
GPH/PSAscatter0sexldl_1_3_30.gph ///
GPH/PSAscatter0sexldl_1_4_30.gph ///
GPH/PSAscatter0sexldl_1_5_30.gph ///
GPH/PSAscatter0sexldl_1_3_40.gph ///
GPH/PSAscatter0sexldl_1_4_40.gph ///
GPH/PSAscatter0sexldl_1_5_40.gph ///
GPH/PSAscatter0sexldl_1_3_50.gph ///
GPH/PSAscatter0sexldl_1_4_50.gph ///
GPH/PSAscatter0sexldl_1_5_50.gph ///
GPH/PSAscatter0sexldl_1_3_60.gph ///
GPH/PSAscatter0sexldl_1_4_60.gph ///
GPH/PSAscatter0sexldl_1_5_60.gph ///
, graphregion(color(white)) altshrink cols(3) xsize(4)
texdoc graph, label(Scatter0sexldl1) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and LDL-C. Males.)
graph combine ///
GPH/PSAscatter1sexldl_0_3_30.gph ///
GPH/PSAscatter1sexldl_0_4_30.gph ///
GPH/PSAscatter1sexldl_0_5_30.gph ///
GPH/PSAscatter1sexldl_0_3_40.gph ///
GPH/PSAscatter1sexldl_0_4_40.gph ///
GPH/PSAscatter1sexldl_0_5_40.gph ///
GPH/PSAscatter1sexldl_0_3_50.gph ///
GPH/PSAscatter1sexldl_0_4_50.gph ///
GPH/PSAscatter1sexldl_0_5_50.gph ///
GPH/PSAscatter1sexldl_0_3_60.gph ///
GPH/PSAscatter1sexldl_0_4_60.gph ///
GPH/PSAscatter1sexldl_0_5_60.gph ///
, graphregion(color(white)) altshrink cols(3) xsize(4)
texdoc graph, label(Scatter0sexldl0) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and LDL-C, excluding Inclisiran. Females. Solid line: \textsterling 20,000 per QALY willingness-to-pay threshold; dashed line: \textsterling 30,000 per QALY willingness-to-pay threshold)
graph combine ///
GPH/PSAscatter1sexldl_1_3_30.gph ///
GPH/PSAscatter1sexldl_1_4_30.gph ///
GPH/PSAscatter1sexldl_1_5_30.gph ///
GPH/PSAscatter1sexldl_1_3_40.gph ///
GPH/PSAscatter1sexldl_1_4_40.gph ///
GPH/PSAscatter1sexldl_1_5_40.gph ///
GPH/PSAscatter1sexldl_1_3_50.gph ///
GPH/PSAscatter1sexldl_1_4_50.gph ///
GPH/PSAscatter1sexldl_1_5_50.gph ///
GPH/PSAscatter1sexldl_1_3_60.gph ///
GPH/PSAscatter1sexldl_1_4_60.gph ///
GPH/PSAscatter1sexldl_1_5_60.gph ///
, graphregion(color(white)) altshrink cols(3) xsize(4)
texdoc graph, label(Scatter0sexldl1) fontface("Liberation Sans") caption(PSA simulations presented in a common cost-effectiveness plane, by age of intervention and LDL-C, excluding Inclisiran. Males. Solid line: \textsterling 20,000 per QALY willingness-to-pay threshold; dashed line: \textsterling 30,000 per QALY willingness-to-pay threshold)
texdoc stlog close

/***
\color{black}

\clearpage
\pagebreak
\section{Scenario analyses}
\label{Sceansec}

It's also of interest to check some scenarios for this analysis. 
The discounting rate is particularly interesting in this analysis, 
as the analysis timespan is different from different ages, and a
steep discounting rate could have major implications across 
such a dramatic age span. Additionally, statins notoriously have poor
adherence, so it's worth looking at what happens when adherence to statins
drops in two scenarios. The first scenario will assume the worst case -- people still get their
prescriptions (and so incur a cost) but the benefit fades. Inclisiran
doesn't suffer from the same issue -- if people aren't adherent, 
it's because they didn't show up to the doctor's appointment, not because they
got Inclisiran dispensed and didn't take it, so both effect and cost would be
removed from the analysis, making little/no difference to the ICER. 
However, Inclisiran is a new drug, and the long-term efficacy on lowering LDL-C
is unclear, so this first scenario could also shed some light on the expected benefits/costs
of Inclisiran if its' efficacy decreases over time. Second, the more likely
non-adherence case: people stop taking their prescription, but don't get it dispensed, 
so do not accrue benefit or cost. 

Thus, the following scenario analyses will be conducted:

\begin{itemize}
\item Discounting at 0\%
\item Discounting at 1.5\%
\item The interventions decrease in effectiveness on LDL-C by 1\% per year, 
and for statin-based interventions only,
a random sample of 20\% stop taking them immediately (but still incur costs). 
\item 40\% of people are immediately non-adherent to therapy, and do not incur costs. 
\end{itemize}

The first two only need changes to the utility and cost matrices, 
but the third and fourth require re-simulation.

\subsection{code}

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
gen YLLn_`i'=0.1*DC_`i'
replace YLLn_`i' = YLLn_`i'/2 if age == `i'
sort age
gen double YLL_`i' = sum(YLLn_`i')
}
keep age YLL_30 YLL_40 YLL_50 YLL_60
tostring age, replace force format(%9.1f)
destring age, replace
save SCE/YLL_Matrix_DC0, replace
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((age-`i'))) if age >= `i'
gen YLLn_`i'=0.1*DC_`i'
replace YLLn_`i' = YLLn_`i'/2 if age == `i'
sort age
gen double YLL_`i' = sum(YLLn_`i')
}
keep age YLL_30 YLL_40 YLL_50 YLL_60
tostring age, replace force format(%9.1f)
destring age, replace
save SCE/YLL_Matrix_DC1, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((MIage-`i'))) if MIage >= `i'
gen QAL_`i'=0.1*UT*DC_`i'
replace QAL_`i' = QAL_`i'/2 if MIage == `i'
bysort sex (MIage) : gen double QALY_nMI_`i' = sum(QAL_`i')
}
keep MIage sex QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save SCE/QALY_nMI_Matrix_DC0, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
gen UT = 0.9454933+0.0256466*sex-0.0002213*MIage - 0.0000294*(MIage^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((MIage-`i'))) if MIage >= `i'
gen QAL_`i'=0.1*UT*DC_`i'
replace QAL_`i' = QAL_`i'/2 if MIage == `i'
bysort sex (MIage) : gen double QALY_nMI_`i' = sum(QAL_`i')
}
keep MIage sex QALY_nMI_30 QALY_nMI_40 QALY_nMI_50 QALY_nMI_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save SCE/QALY_nMI_Matrix_DC1, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
gen UT = 0.9454933+0.0256466*sex-0.0002213*age - 0.0000294*(age^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
gen QAL_`i'=0.1*UT*DC_`i'*0.79
replace QAL_`i' = QAL_`i' - 0.01 if durn <0.301
replace QAL_`i' = 0 if QAL_`i' < 0
bysort sex MIage (age) : gen double QALY_MI_`i' = sum(QAL_`i')
}
keep age MIage sex QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/QALY_MI_Matrix_DC0, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
gen UT = 0.9454933+0.0256466*sex-0.0002213*age - 0.0000294*(age^2)
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((age-`i'))) if age >= `i'
gen QAL_`i'=0.1*UT*DC_`i'*0.79
replace QAL_`i' = QAL_`i' - 0.01 if durn <0.301
replace QAL_`i' = 0 if QAL_`i' < 0
bysort sex MIage (age) : gen double QALY_MI_`i' = sum(QAL_`i')
}
keep age MIage sex QALY_MI_30 QALY_MI_40 QALY_MI_50 QALY_MI_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/QALY_MI_Matrix_DC1, replace
clear
set obs 551
gen MIage = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((MIage-`i'))) if MIage >= `i'
gen double ACMIcost_`i' = 2047.31*DC_`i'
}
keep MIage ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save SCE/ACcost_Matrix_DC0, replace
clear
set obs 551
gen MIage = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((MIage-`i'))) if MIage >= `i'
gen double ACMIcost_`i' = 2047.31*DC_`i'
}
keep MIage ACMIcost_30 ACMIcost_40 ACMIcost_50 ACMIcost_60
tostring MIage, replace force format(%9.1f)
destring MIage, replace
save SCE/ACcost_Matrix_DC1, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*4705.45/5 if durn <=0.5
replace cost_`i' = DC_`i'*1015.21/10 if cost_`i'==.
bysort sex MIage (age) : gen double CHMIcost_`i' = sum(cost_`i')
}
keep age MIage sex CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/CHcost_Matrix_DC0, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*4705.45/5 if durn <=0.5
replace cost_`i' = DC_`i'*1015.21/10 if cost_`i'==.
bysort sex MIage (age) : gen double CHMIcost_`i' = sum(cost_`i')
}
keep age MIage sex CHMIcost_30 CHMIcost_40 CHMIcost_50 CHMIcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/CHcost_Matrix_DC1, replace
clear
set obs 551
gen agellt = round((_n+299)/10,0.1)
expand 551
bysort age : gen MIage = round(age+((_n-1)/10),0.1)
drop if MIage > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((MIage-`i'))) if MIage >= `i'
gen cost = DC_`i'*1.9
bysort agellt (MIage) : gen double STcost_`i' = sum(cost) if MIage >= `i'
drop cost
}
keep agellt MIage STcost_30 STcost_40 STcost_50 STcost_60
tostring agellt MIage, replace force format(%9.1f)
destring agellt MIage, replace
save SCE/STcost_Matrix_DC0, replace
clear
set obs 551
gen agellt = round((_n+299)/10,0.1)
expand 551
bysort age : gen MIage = round(age+((_n-1)/10),0.1)
drop if MIage > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((MIage-`i'))) if MIage >= `i'
gen cost = DC_`i'*1.9
bysort agellt (MIage) : gen double STcost_`i' = sum(cost) if MIage >= `i'
drop cost
}
keep agellt MIage STcost_30 STcost_40 STcost_50 STcost_60
tostring agellt MIage, replace force format(%9.1f)
destring agellt MIage, replace
save SCE/STcost_Matrix_DC1, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*19/10
bysort sex MIage (age) : gen double CHSTcost_`i' = sum(cost_`i')
}
keep age MIage sex CHSTcost_30 CHSTcost_40 CHSTcost_50 CHSTcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/CHSTcost_Matrix_DC0, replace
clear
set obs 551
gen MIage = (_n+299)/10
expand 2
bysort MIage : gen sex = _n-1
expand 550
bysort MIage sex : gen durn = _n/10
gen age = round(MIage+durn,0.1)
drop if age > 85
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((age-`i'))) if age >= `i'
gen cost_`i' = DC_`i'*19/10
bysort sex MIage (age) : gen double CHSTcost_`i' = sum(cost_`i')
}
keep age MIage sex CHSTcost_30 CHSTcost_40 CHSTcost_50 CHSTcost_60
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
save SCE/CHSTcost_Matrix_DC1, replace
forval a = 1/4 {
if `a' == 1 {
local aa = 18.39
}
if `a' == 2 {
local aa = 27.39
}
if `a' == 3 {
local aa = 49.31
}
if `a' == 4 {
local aa = 3974.72
}
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
gen cost = DC_`i'*`aa'/10
gen double MDcost_`i' = sum(cost)
drop cost
}
keep age MDcost_30 MDcost_40 MDcost_50 MDcost_60
tostring age, replace force format(%9.1f)
destring age, replace
save SCE/INTcost_Matrix_`a'_DC0, replace
}
forval a = 1/4 {
if `a' == 1 {
local aa = 18.39
}
if `a' == 2 {
local aa = 27.39
}
if `a' == 3 {
local aa = 49.31
}
if `a' == 4 {
local aa = 3974.72
}
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.015)^((age-`i'))) if age >= `i'
gen cost = DC_`i'*`aa'/10
gen double MDcost_`i' = sum(cost)
drop cost
}
keep age MDcost_30 MDcost_40 MDcost_50 MDcost_60
tostring age, replace force format(%9.1f)
destring age, replace
save SCE/INTcost_Matrix_`a'_DC1, replace
}
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*0.55 if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid (age) : gen rn2 = prllt[5]
replace lltinit = 2 if rn2 < 0.2 & lltinit==1
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*0.55 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
preserve
bysort eid lltinit age : gen agellt3 = age if lltinit==2 & _n == 1
bysort eid (age) : egen agellt4 = min(agellt3) if llt1 == 2
bysort eid (age) : keep if _n == 1
gen agellt2 = min(agellt,agellt1,agellt4)
keep eid agellt2
rename agellt2 agellt
replace agellt = round(agellt,0.1)
tostring agellt, force format(%9.1f) replace
destring agellt, replace
save SCE/agellt_control_`a'_SCE3, replace
restore
keep eid sex ldl age njm ldl_0_30-ldl_0_60 prllt
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*(1-(0.4*(0.99^(age-`i')))) if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*(1-(0.5*(0.99^(age-`i')))) if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*(1-(0.55*(0.99^(age-`i')))) if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*(1-(0.515*(0.99^(age-`i')))) if age >= `i'
}
bysort eid (age) : gen rand = prllt[1]
forval i = 30(10)60 {
replace ldl_1_`i' = ldl_0_`i' if rand <= 0.2
replace ldl_2_`i' = ldl_0_`i' if rand <= 0.2
replace ldl_3_`i' = ldl_0_`i' if rand <= 0.2
}
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')/10
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
}
}
keep eid sex age aveldl ///
aveldl_1_30 aveldl_1_40 aveldl_1_50 aveldl_1_60 ///
aveldl_2_30 aveldl_2_40 aveldl_2_50 aveldl_2_60 ///
aveldl_3_30 aveldl_3_40 aveldl_3_50 aveldl_3_60 ///
aveldl_4_30 aveldl_4_40 aveldl_4_50 aveldl_4_60
keep if age >= 30
tostring age, replace force format(%9.1f)
destring age, replace
merge m:1 sex age using ldlave_reg
drop if _merge == 2
drop _merge
merge m:1 sex age using MI_inc
drop if _merge == 2
drop _merge
rename rate nfMIrate
rename errr nfMIerrr
merge m:1 sex age using MIdrates
drop if _merge == 2
drop _merge MI
rename rate fMIrate
rename errr fMIerrr
sort eid age
save SCE/LDL_trajectories_`a'_SCE3, replace
}
clear
forval a = 1(1000)458001 {
append using SCE/agellt_control_`a'_SCE3
}
save SCE/agellt_control_SCE3, replace
forval a = 1(1000)458001 {
erase SCE/agellt_control_`a'_SCE3.dta
}
set seed 28371057
forval a = 1(1000)458001 {
use UKB_working, clear
drop if dob==.
drop if mid <= dofa
keep if ldl!=.
gen ldl1 = ldl
replace ldl1 = ldl*(1/0.7) if llt==1
su(ldl1)
gen ldldist = (ldl1-r(mean))/r(sd)
replace ldldist = -3 if ldldist < -3
gen njm = _n
local aa = `a'+999
keep if inrange(njm, `a',`aa')
gen agellt = ((dofa-(365.25*5))-dob)/365.25  if llt==1
expand 850
bysort eid : gen age = _n/10
gen ldlorig = ldl
replace ldl = ldl*(1/0.7) if age < agellt & agellt!=.
replace ldl = ldl*(1/0.7)*0.55 if age >= agellt & agellt!=.
gen lltpr = 0
replace lltpr = 0.0001 if inrange(age,39.99,49.99)
replace lltpr = 0.0015 if inrange(age,49.999,59.99)
replace lltpr = 0.0035 if age >= 59.999
gen agedofa = (dofa-dob)/365.25
replace lltpr = 0 if age < agedofa
replace lltpr = lltpr*(0.95) if sex == 0
replace lltpr = lltpr*(1.05) if sex == 1
replace lltpr = lltpr*(3^ldldist)
replace lltpr = 1-exp(-lltpr)
gen prllt = runiform()
gen lltinit = 1 if lltpr >= prllt & llt==0
bysort eid (age) : gen rn2 = prllt[5]
replace lltinit = . if rn2 < 0.4 & lltinit==1
bysort eid lltinit age : gen agellt0 = age if lltinit ==1 & _n == 1
bysort eid (age) : egen llt1 = min(lltinit)
bysort eid (age) : egen agellt1 = min(agellt0) if llt1 == 1
ta agellt1
replace ldl = ldl*0.55 if age >= agellt1 & llt1 == 1
sort eid age
replace ldl = 0.75+(0.1875*ldldist) if inrange(age,0.09,0.11)
replace ldl = 2+(0.5*ldldist)  if inrange(age,4.99,5.01)
bysort eid (age) : replace ldl = (ldl[50]-ldl[1])/49 if inrange(age,0.11,4.99)
bysort eid (age) : replace ldl = (ldl[400]-ldl[50])/350 if inrange(age,5.01,39.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,0.09,4.99)
bysort eid (age) : replace ldl = sum(ldl) if inrange(age,4.99,39.99)
gen ldl_0_30 = ldl if age < 40
replace ldl_0_30 = ldl1 if age >= 40
gen ldl_0_40 = ldl_0_30
gen ldl_0_50 = ldl if age < 50
replace ldl_0_50 = ldl1 if age >= 50
gen ldl_0_60 = ldl if age < 60
replace ldl_0_60 = ldl1 if age >= 60
sort eid age
preserve
bysort eid (age) : keep if _n == 1
gen agellt2 = min(agellt,agellt1)
keep eid agellt2
rename agellt2 agellt
replace agellt = round(agellt,0.1)
tostring agellt, force format(%9.1f) replace
destring agellt, replace
save SCE/agellt_control_`a'_SCE4, replace
restore
keep eid sex ldl age njm ldl_0_30-ldl_0_60 prllt
forval i = 30(10)60 {
forval ii = 1/4 {
gen ldl_`ii'_`i' = ldl_0_`i'
}
replace ldl_1_`i' = ldl_0_`i'*(1-(0.4*(0.99^(age-`i')))) if age >= `i'
replace ldl_2_`i' = ldl_0_`i'*(1-(0.5*(0.99^(age-`i')))) if age >= `i'
replace ldl_3_`i' = ldl_0_`i'*(1-(0.55*(0.99^(age-`i')))) if age >= `i'
replace ldl_4_`i' = ldl_0_`i'*(1-(0.515*(0.99^(age-`i')))) if age >= `i'
}
bysort eid (age) : gen rand = prllt[1]
forval i = 30(10)60 {
replace ldl_1_`i' = ldl_0_`i' if rand <= 0.4
replace ldl_2_`i' = ldl_0_`i' if rand <= 0.4
replace ldl_3_`i' = ldl_0_`i' if rand <= 0.4
replace ldl_4_`i' = ldl_0_`i' if rand <= 0.4
}
bysort eid (age) : gen cumldl = sum(ldl)/10 if ldl!=.
gen aveldl = cumldl/age
forval i = 1/4 {
forval ii = 30(10)60 {
bysort eid (age) : gen cumldl_`i'_`ii' = sum(ldl_`i'_`ii')/10
gen aveldl_`i'_`ii' = cumldl_`i'_`ii'/age
}
}
preserve 
bysort eid (age) : keep if _n == 1
keep eid rand
gen nointcost = 1 if rand <= 0.4
save SCE/nointcost_`a'_SCE4, replace
restore
keep eid sex age aveldl ///
aveldl_1_30 aveldl_1_40 aveldl_1_50 aveldl_1_60 ///
aveldl_2_30 aveldl_2_40 aveldl_2_50 aveldl_2_60 ///
aveldl_3_30 aveldl_3_40 aveldl_3_50 aveldl_3_60 ///
aveldl_4_30 aveldl_4_40 aveldl_4_50 aveldl_4_60
keep if age >= 30
tostring age, replace force format(%9.1f)
destring age, replace
merge m:1 sex age using ldlave_reg
drop if _merge == 2
drop _merge
merge m:1 sex age using MI_inc
drop if _merge == 2
drop _merge
rename rate nfMIrate
rename errr nfMIerrr
merge m:1 sex age using MIdrates
drop if _merge == 2
drop _merge MI
rename rate fMIrate
rename errr fMIerrr
sort eid age
save SCE/LDL_trajectories_`a'_SCE4, replace
}
clear
forval a = 1(1000)458001 {
append using SCE/agellt_control_`a'_SCE4
}
save SCE/agellt_control_SCE4, replace
clear
forval a = 1(1000)458001 {
append using SCE/nointcost_`a'_SCE4
}
save SCE/nointcost_SCE4, replace
forval a = 1(1000)458001 {
erase SCE/agellt_control_`a'_SCE4.dta
erase SCE/nointcost_`a'_SCE4.dta
}
forval t = 3/4 {
forval a = 1(1000)458001 {
use SCE/LDL_trajectories_`a'_SCE`t', clear
gen nfMIadj = nfMIrate*(0.48^(ldlave-aveldl))
gen fMIadj = fMIrate*(0.48^(ldlave-aveldl))
forval i = 1/4 {
forval ii = 30(10)60 {
gen nfMIadj_`i'_`ii' = nfMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
gen fMIadj_`i'_`ii' = fMIrate*(0.48^(ldlave-aveldl_`i'_`ii'))
}
}
keep eid sex age nfMIrate-fMIadj_4_60
forval i = 30(0.1)84.9 {
preserve
local ii = `i'-0.05
local iii = `i'+0.05
local iiii = round(`i'*10,1)
keep if inrange(age,`ii',`iii')
save SCE/MIrisk_`a'_`iiii'_SCE`t', replace
restore
}
}
forval i = 30(0.1)84.99 {
clear
local ii = `i'-0.05
local iii = `i'+0.05
local iiii = round(`i'*10,1)
forval a = 1(1000)458001 {
append using SCE/MIrisk_`a'_`iiii'_SCE`t'
}
replace age = age*10
save SCE/MIrisk_com_`iiii'_SCE`t', replace
}
forval a = 1001(1000)458001 {
erase SCE/LDL_trajectories_`a'_SCE`t'.dta
}
forval a = 1(1000)458001 {
forval i = 30(0.1)84.99 {
local iiii = round(`i'*10,1)
erase SCE/MIrisk_`a'_`iiii'_SCE`t'.dta
}
}
use Microsim_30, clear
save SCE/Microsim_30_SCE`t', replace
set seed 6746
forval i = 300/849 {
merge 1:1 eid age using SCE/MIrisk_com_`i'_SCE`t'
drop if _merge == 2
rename (nfMIadj fMIadj) (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
drop nfMI-PMId
if `i' == 399 {
save SCE/Microsim_40_SCE`t', replace
set seed 2791
}
if `i' == 499 {
save SCE/Microsim_50_SCE`t', replace
set seed 9261
}
if `i' == 599 {
save SCE/Microsim_60_SCE`t', replace
set seed 1467
}
}
replace age = age/10
replace durn = durn/10
save SCE/trial_control_SCE`t', replace
forval i = 1/4 {
forval ii = 30(10)60 {
if `ii' == 30 {
local a = 300
set seed 6746
}
if `ii' == 40 {
local a = 400
set seed 2791
}
if `ii' == 50 {
local a = 500
set seed 9261
}
if `ii' == 60 {
local a = 600
set seed 1467
}
use SCE/Microsim_`ii'_SCE`t', clear
forval iii = `a'/849 {
merge 1:1 eid age using SCE/MIrisk_com_`iii'_SCE`t'
drop if _merge == 2
rename (nfMIadj_`i'_`ii' fMIadj_`i'_`ii') (nfMI fMI)
keep eid-rand nfMI fMI
merge m:1 age sex using NCdrates10
drop if _merge == 2
rename rate NCd
drop errr-_merge
merge m:1 age sex durn MI using PMId10
drop if _merge == 2
rename rate PMId
drop adx errr _merge
gen ratesum = nfMI+fMI+NCd
gen tpsum = 1-exp(-ratesum*0.1)
replace nfMI = tpsum*nfMI/ratesum
replace fMI = tpsum*fMI/ratesum
replace NCd = tpsum*NCd/ratesum
replace PMId = 1-exp(-PMId*0.1)
drop ratesum tpsum
sort eid
replace rand = runiform()
recode MI 0=1 if (nfMI > rand) & Death == 0
replace rand = runiform()
recode MI 0=1 if (fMI > rand) & Death == 0
recode Death 0=1 if (fMI > rand) & durn == 0
replace rand = runiform()
recode Death 0=1 if (NCd > rand) & MI == 0
replace rand = runiform()
recode Death 0=1 if (PMId > rand) & MI == 1 & durn!=0
replace age = age+1 if Death == 0
replace durn = durn+1 if MI == 1 & Death == 0
drop nfMI-PMId
}
replace age = age/10
replace durn = durn/10
save SCE/trial_`i'_`ii'_SCE`t', replace
}
}
forval iii = 300/849 {
erase SCE/MIrisk_com_`iii'_SCE`t'.dta
}
}
forval t = 1/4 {
if `t' >= 3 {
use SCE/trial_control_SCE`t', clear
}
else {
use trial_control, clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
if `t' >= 3 {
merge 1:1 eid using SCE/agellt_control_SCE`t'
}
else {
merge 1:1 eid using agellt_control
}
drop if _merge == 2
drop _merge
if `t' == 1 {
merge m:1 age using SCE/YLL_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage sex using SCE/QALY_nMI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/QALY_MI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage using SCE/ACcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using SCE/STcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHSTcost_Matrix_DC0
drop if _merge == 2
drop _merge
}
else if `t' == 2 {
merge m:1 age using SCE/YLL_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 MIage sex using SCE/QALY_nMI_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/QALY_MI_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 MIage using SCE/ACcost_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHcost_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using SCE/STcost_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHSTcost_Matrix_DC1
drop if _merge == 2
drop _merge
}
else {
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix
drop if _merge == 2
drop _merge
}
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
if `t' >= 3 {
use SCE/trial_`ii'_`i'_SCE`t', clear
}
else {
use trial_`ii'_`i', clear
}
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
if `t' == 1 {
merge m:1 age using SCE/YLL_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage sex using SCE/QALY_nMI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/QALY_MI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage using SCE/ACcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age using SCE/INTcost_Matrix_`ii'_DC0
drop if _merge == 2
drop _merge
}
else if `t' == 2 {
merge m:1 age using SCE/YLL_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 MIage sex using SCE/QALY_nMI_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/QALY_MI_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 MIage using SCE/ACcost_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using SCE/CHcost_Matrix_DC1
drop if _merge == 2
drop _merge
merge m:1 age using SCE/INTcost_Matrix_`ii'_DC1
drop if _merge == 2
drop _merge
}
else {
merge m:1 age using YLL_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'
drop if _merge == 2
drop _merge
}
if `t' == 4 {
merge 1:1 eid using SCE/nointcost_SCE4
drop if _merge == 2
drop _merge
replace MDcost_`i' = 0 if nointcost==1
}
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
if `t' == 1 {
save reshof0_SCE1, replace
}
bysort A1 (A2) : replace D1 = D1[9]/D1[5] if A2 == 10
bysort A1 (A2) : replace D2 = D2[9]/D2[5] if A2 == 10
bysort A1 (A2) : replace D3 = D3[9]/D3[5] if A2 == 10
bysort A1 (A2) : replace D4 = D4[9]/D4[5] if A2 == 10
gen A0 = ""
replace A0 = "N" if A2 == 1
replace A0 = "Incident MIs" if A2 == 2
replace A0 = "Deaths" if A2 == 3
replace A0 = "YLL" if A2 == 4
replace A0 = "QALYs" if A2 == 5
replace A0 = "Medication costs (\textsterling)" if A2 == 6
replace A0 = "Acute MI costs (\textsterling)" if A2 == 7
replace A0 = "Chronic MI costs (\textsterling)" if A2 == 8
replace A0 = "Total healthcare costs (\textsterling)" if A2 == 9
replace A0 = "ICER ($\Delta$ \textsterling / $\Delta$ QALY)" if A2 == 10
gen A00 = "30" if _n == 1
replace A00 = "40" if _n == 11
replace A00 = "50" if _n == 21
replace A00 = "60" if _n == 31
order A00 A0
gen P1 = 100*D1/A3
gen P2 = 100*D2/A3
gen P3 = 100*D3/A3
gen P4 = 100*D4/A3
tostring A3-D4, force format(%15.0fc) replace
tostring P1-P4, gen(p1 p2 p3 p4) format(%9.2f) force
tostring P1-P4, force format(%9.1f) replace
replace D1 = D1 + " (" + P1 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D2 = D2 + " (" + P2 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D3 = D3 + " (" + P3 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D4 = D4 + " (" + P4 + "\%)" if A2 != 1 & A2!= 4 & A2 != 5 & A2 != 10
replace D1 = D1 + " (" + p1 + "\%)" if A2 == 4 | A2 == 5
replace D2 = D2 + " (" + p2 + "\%)" if A2 == 4 | A2 == 5
replace D3 = D3 + " (" + p3 + "\%)" if A2 == 4 | A2 == 5
replace D4 = D4 + " (" + p4 + "\%)" if A2 == 4 | A2 == 5
save reshof_SCE`t', replace
preserve
keep A00 A0 A3 A4 D1
export delimited using CSV/Res_HOF_1_SCE`t'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A5 D2
export delimited using CSV/Res_HOF_2_SCE`t'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A6 D3
export delimited using CSV/Res_HOF_3_SCE`t'.csv, delimiter(":") novarnames replace
restore
preserve
keep A00 A0 A3 A7 D4
export delimited using CSV/Res_HOF_4_SCE`t'.csv, delimiter(":") novarnames replace
restore
use reshof_SCE`t', clear
replace A00 = A00[_n-1] if A2 == 2
keep if A2 == 2 | A2 == 5 | A2 == 9 | A2 == 10
drop A1-A7 P1-p4
export delimited using CSV/Res_HOF_SCE`t'.csv, delimiter(":") novarnames replace
}
}
texdoc stlog close

/***
\color{black}

\clearpage

\subsection{Results}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Scenario 1: discounting rate set at 0\%}
    \label{Microsim1Sce1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_SCE1.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Scenario 1: discounting rate set at 0\%}
    \label{Microsim2Sce1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_SCE1.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Scenario 1: discounting rate set at 0\%}
    \label{Microsim3Sce1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_SCE1.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Scenario 1: discounting rate set at 0\%}
    \label{Microsim4Sce1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_SCE1.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Scenario 2: discounting rate set at 1.5\%}
    \label{Microsim1Sce2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_SCE2.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Scenario 2: discounting rate set at 1.5\%}
    \label{Microsim2Sce2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_SCE2.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Scenario 2: discounting rate set at 1.5\%}
    \label{Microsim3Sce2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_SCE2.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Scenario 2: discounting rate set at 1.5\%}
    \label{Microsim4Sce2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_SCE2.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. Scenario 3: Interventions decrease in efficacy at 1\% per year.}
    \label{Microsim1Sce3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_SCE3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. Scenario 3: Interventions decrease in efficacy at 1\% per year.}
    \label{Microsim2Sce3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_SCE3.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. Scenario 3: Interventions decrease in efficacy at 1\% per year.}
    \label{Microsim3Sce3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_SCE3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. Scenario 3: Interventions decrease in efficacy at 1\% per year.}
    \label{Microsim4Sce3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_SCE3.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins. 
Scenario 4: 40\% of people stop taking therapy immediately.}
    \label{Microsim1Sce4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_1_SCE4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- High intensity statins. 
Scenario 4: 40\% of people stop taking therapy immediately.}
    \label{Microsim2Sce4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_2_SCE4.csv}
  \end{center}
\end{table}


\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Low/moderate intensity statins and ezetimibe. 
Scenario 4: 40\% of people stop taking therapy immediately.}
    \label{Microsim3Sce4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_3_SCE4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Inclisiran. 
Scenario 4: 40\% of people stop taking therapy immediately.}
    \label{Microsim4Sce4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{10}{*}{##1}}}},
      display columns/1/.style={column name=, column type={l}, text indicator="},
      display columns/2/.style={column name=, column type={r}, column type/.add={|}{|}},
      display columns/3/.style={column name=Absolute value, column type={r}},
      display columns/4/.style={column name=Difference to control, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					\multicolumn{1}{c}{Age of intervention} & \multicolumn{1}{c}{Outcome} & \multicolumn{1}{c}{Control} & \multicolumn{2}{c}{Intervention}\\
					},
        after row={\midrule}
            },
        every nth row={10}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_4_SCE4.csv}
  \end{center}
\end{table}

\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Summary of all interventions. Scenario 1: discounting rate set at 0\%. All results shown are the difference between the intervention and control.}
    \label{Microsim5Sce1}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= \specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}},
      display columns/3/.style={column name=High intensity statins, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}},
      display columns/5/.style={column name=Inclisiran, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_SCE1.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Summary of all interventions. Scenario 2: discounting rate set at 1.5\%. All results shown are the difference between the intervention and control.}
    \label{Microsim5Sce2}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= \specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}},
      display columns/3/.style={column name=High intensity statins, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}},
      display columns/5/.style={column name=Inclisiran, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_SCE2.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Summary of all interventions. Scenario 3: Interventions decrease in efficacy at 1\% per year. All results shown are the difference between the intervention and control.}
    \label{Microsim5Sce3}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= \specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}},
      display columns/3/.style={column name=High intensity statins, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}},
      display columns/5/.style={column name=Inclisiran, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_SCE3.csv}
  \end{center}
\end{table}



\begin{table}[h!]
  \begin{center}
    \caption{Microsimulation results -- Summary of all interventions. 
Scenario 4: 40\% of people stop taking therapy immediately. 
All results shown are the difference between the intervention and control.}
    \label{Microsim5Sce4}
     \fontsize{6pt}{8pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Age of intervention,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/1/.style={column name=Outcome, column type={l}, text indicator=", column type/.add={}{|}},
      display columns/2/.style={column name= \specialcell{\noindent Low/moderate \\ intensity statins}, column type={r}},
      display columns/3/.style={column name=High intensity statins, column type={r}, column type/.add={}{}},
      display columns/4/.style={column name=\specialcell{\noindent Low/moderate intensity \\ statins and ezetimibe}, column type={r}},
      display columns/5/.style={column name=Inclisiran, column type={r}, column type/.add={}{}},
      every head row/.style={
        before row={\toprule
					},
        after row={\midrule}
            },
        every nth row={4}{before row=\midrule},
        every last row/.style={after row=\bottomrule},
    ]{CSV/Res_HOF_SCE4.csv}
  \end{center}
\end{table}

\clearpage
\pagebreak
\section{Threshold analysis}
\label{Thresh}

Finally, given that Inclisiran was not even close to cost-effective 
in any analysis so far, it seems necessary to perform a threshold
analysis to estimate the maximum annual cost at which Inclisiran would
be cost-effective. Recall that the willingness-to-pay threshold
in the UK is a range, from \textsterling 20,000 to \textsterling 30,000; 
thus, I will conduct the threshold analysis at both thresholds. 
The analysis is exactly the same as before, yet instead of using a fixed
cost for Inclisiran, I will estimate the ICER at all costs from 
\textsterling 10 to \textsterling 1,000 (in increments of \textsterling 1), 
and present the maximum annual cost at which the ICER is under each 
threshold. 
Additionally, because the 0\% discounting results above were so different from
the primary analysis (and out of personal interest/to be as generous as possible),
I will estimate the maximum cost using 0\% discounting and the \textsterling 30,000
willingness-to-pay threshold. 

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.035)^((age-`i'))) if age >= `i'
}
forval i = 10(1)1000 {
forval ii = 30(10)60 {
gen cost = DC_`ii'*`i'/10
replace cost = 0 if age < `ii'
gen double ICcost_`i'_`ii' = sum(cost)
drop cost
}
}
tostring age, replace force format(%9.1f)
destring age, replace
keep age ICcost_10_30-ICcost_1000_60
save ICcost_Matrix, replace
clear
set obs 551
gen age = (_n+299)/10
forval i = 30(10)60 {
gen DC_`i' = 1/((1.0)^((age-`i'))) if age >= `i'
}
forval i = 10(1)1000 {
forval ii = 30(10)60 {
gen cost = DC_`ii'*`i'/10
replace cost = 0 if age < `ii'
gen double ICcost_`i'_`ii' = sum(cost)
drop cost
}
}
keep age ICcost_10_30-ICcost_1000_60
tostring age, replace force format(%9.1f)
destring age, replace
save ICcost_Matrix_DC0, replace
forval i = 30(10)60 {
use trial_4_`i', clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using ICcost_Matrix
drop if _merge == 2
drop _merge
keep if age >= `i' & MIage >= `i'
su(ICcost_10_`i')
matrix B = (`i',10,r(sum))
forval iii = 11/1000 {
su(ICcost_`iii'_`i')
matrix B = (B\0`i',0`iii',r(sum))
}
clear
svmat double B
rename (B1 B2 B3) (A1 A2 A7)
save ICthreshcosts_`i', replace
}
forval i = 30(10)60 {
use trial_4_`i', clear
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using ICcost_Matrix_DC0
drop if _merge == 2
drop _merge
keep if age >= `i' & MIage >= `i'
su(ICcost_10_`i')
matrix B = (`i',10,r(sum))
forval iii = 11/1000 {
su(ICcost_`iii'_`i')
matrix B = (B\0`i',0`iii',r(sum))
}
clear
svmat double B
rename (B1 B2 B3) (A1 A2 A7)
save ICthreshcosts_`i'_DC0, replace
}
texdoc stlog close
texdoc stlog, cmdlog
use reshof0, clear
keep A1 A2 A3 A7
drop if A2 == 10
append using ///
ICthreshcosts_30 ///
ICthreshcosts_40 ///
ICthreshcosts_50 ///
ICthreshcosts_60
bysort A1 (A2) : gen double AMIC = A7[7]
bysort A1 (A2) : gen double CMIC = A7[8]
bysort A1 (A2) : gen double RHCC = A3[9]
gen double THCC = A7+AMIC+CMIC if A2 >= 10
gen double DHCC = THCC-RHCC
bysort A1 (A2) : gen double DQLY = A7[5]-A3[5]
gen ICER = DHCC/DQLY
gen A = 1 if (ICER < 20000 & ICER[_n+1] >= 20000 & ICER[_n+1]!=.)
gen B = 1 if (ICER < 30000 & ICER[_n+1] >= 30000 & ICER[_n+1]!=.)
keep if A == 1 | B == 1
sort A A1
texdoc local C301 = A2[1]
texdoc local C401 = A2[2]
texdoc local C501 = A2[3]
texdoc local C601 = A2[4]
texdoc local C302 = A2[5]
texdoc local C402 = A2[6]
texdoc local C502 = A2[7]
texdoc local C602 = A2[8]
use reshof0_SCE1, clear
keep A1 A2 A3 A7
drop if A2 == 10
append using ///
ICthreshcosts_30_DC0 ///
ICthreshcosts_40_DC0 ///
ICthreshcosts_50_DC0 ///
ICthreshcosts_60_DC0
bysort A1 (A2) : gen double AMIC = A7[7]
bysort A1 (A2) : gen double CMIC = A7[8]
bysort A1 (A2) : gen double RHCC = A3[9]
gen double THCC = A7+AMIC+CMIC if A2 >= 10
gen double DHCC = THCC-RHCC
bysort A1 (A2) : gen double DQLY = A7[5]-A3[5]
gen ICER = DHCC/DQLY
gen A = 1 if (ICER < 20000 & ICER[_n+1] >= 20000 & ICER[_n+1]!=.)
gen B = 1 if (ICER < 30000 & ICER[_n+1] >= 30000 & ICER[_n+1]!=.)
keep if A == 1 | B == 1
sort A A1
texdoc local CC301 = A2[1]
texdoc local CC401 = A2[2]
texdoc local CC501 = A2[3]
texdoc local CC601 = A2[4]
texdoc local CC302 = A2[5]
texdoc local CC402 = A2[6]
texdoc local CC502 = A2[7]
texdoc local CC602 = A2[8]
texdoc stlog close

/***
\color{black}

So the maximum annual costs, in the overall population, that Inclisiran
would be cost-effective at the \textsterling 20,000 and \textsterling 30,000
willingness-to-pay thresholds when intervening from different ages are: 
\begin{itemize}
\item Age 30: \textsterling `C301' at \textsterling 20,000 and \textsterling `C302' at \textsterling 30,000
\item Age 40: \textsterling `C401' at \textsterling 20,000 and \textsterling `C402' at \textsterling 30,000
\item Age 50: \textsterling `C501' at \textsterling 20,000 and \textsterling `C502' at \textsterling 30,000
\item Age 60: \textsterling `C601' at \textsterling 20,000 and \textsterling `C602' at \textsterling 30,000
\end{itemize}

And for 0\% discounting:
\begin{itemize}
\item Age 30: \textsterling `CC301' at \textsterling 20,000 and \textsterling `CC302' at \textsterling 30,000
\item Age 40: \textsterling `CC401' at \textsterling 20,000 and \textsterling `CC402' at \textsterling 30,000
\item Age 50: \textsterling `CC501' at \textsterling 20,000 and \textsterling `CC502' at \textsterling 30,000
\item Age 60: \textsterling `CC601' at \textsterling 20,000 and \textsterling `CC602' at \textsterling 30,000
\end{itemize}

As usual, it's a good idea to stratify by sex and LDL-C.

\color{Blue4}
***/

texdoc stlog, cmdlog nodo
quietly {
forval s = 0/1 {
foreach l in 0 3 4 5 {
forval i = 30(10)60 {
use trial_4_`i', clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using ICcost_Matrix
drop if _merge == 2
drop _merge
keep if age >= `i' & MIage >= `i'
su(ICcost_10_`i')
matrix B = (`i',10,r(sum))
forval iii = 11/1000 {
su(ICcost_`iii'_`i')
matrix B = (B\0`i',0`iii',r(sum))
}
clear
svmat double B
rename (B1 B2 B3) (A1 A2 A7)
save ICthreshcosts_`i'_sex_`s'_ldl_`l', replace
}
forval i = 30(10)60 {
use trial_4_`i', clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using ICcost_Matrix_DC0
drop if _merge == 2
drop _merge
keep if age >= `i' & MIage >= `i'
su(ICcost_10_`i')
matrix B = (`i',10,r(sum))
forval iii = 11/1000 {
su(ICcost_`iii'_`i')
matrix B = (B\0`i',0`iii',r(sum))
}
clear
svmat double B
rename (B1 B2 B3) (A1 A2 A7)
save ICthreshcosts_`i'_sex_`s'_ldl_`l'_DC0, replace
}
}
}
forval s = 0/1 {
foreach l in 0 3 4 5 {
use trial_control, clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge 1:1 eid using agellt_control
drop if _merge == 2
drop _merge
merge m:1 age using YLL_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 agellt MIage using STcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHSTcost_Matrix_DC0
drop if _merge == 2
drop _merge
forval i = 30(10)60 {
recode QALY_MI_`i' .=0
recode ACMIcost_`i' .=0
recode CHMIcost_`i' .=0
recode STcost_`i' .=0
recode CHSTcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double MDcost_`i' = STcost_`i' + CHSTcost_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
}
forval i = 30(10)60 {
preserve
keep if age >= `i' & MIage >= `i'
count
matrix A_0_`i' = r(N)
count if MI == 1
matrix A_0_`i' = (A_0_`i'\r(N))
count if Death == 1
matrix A_0_`i' = (A_0_`i'\r(N))
su(YLL_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(QALY_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(MDcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(ACMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(CHMIcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
su(HCcost_`i')
matrix A_0_`i' = (A_0_`i'\r(sum))
restore
}
forval i = 30(10)60 {
forval ii = 1/4 {
use trial_`ii'_`i', clear
merge 1:1 eid using UKBldl
drop if _merge == 2
drop _merge
keep if ldl >= `l'
keep if sex == `s'
gen MIage = round(age-durn,0.1)
replace age = round(age,0.1)
tostring age MIage, replace force format(%9.1f)
destring age MIage, replace
merge m:1 age using YLL_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage sex using QALY_nMI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using QALY_MI_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 MIage using ACcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age MIage sex using CHcost_Matrix_DC0
drop if _merge == 2
drop _merge
merge m:1 age using INTcost_Matrix_`ii'_DC0
drop if _merge == 2
drop _merge
recode QALY_MI_`i' .=0
recode CHMIcost_`i' .=0
recode ACMIcost_`i' .=0
replace ACMIcost_`i' = 0 if MI==0
replace ACMIcost_`i' = ACMIcost_`i'*0.18 if MI == 1 & durn == 0
gen double QALY_`i' = QALY_nMI_`i' + QALY_MI_`i'
gen double HCcost_`i' = ACMIcost_`i'+ CHMIcost_`i' + MDcost_`i'
keep if age >= `i' & MIage >= `i'
count
matrix A_`ii'_`i' = r(N)
count if MI == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
count if Death == 1
matrix A_`ii'_`i' = (A_`ii'_`i'\r(N))
su(YLL_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(QALY_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(MDcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(ACMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(CHMIcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
su(HCcost_`i')
matrix A_`ii'_`i' = (A_`ii'_`i'\r(sum))
}
}
matrix AA = (1\2\3\4\5\6\7\8\9)
matrix A = (J(9,1,30),AA,A_0_30,A_1_30,A_2_30,A_3_30,A_4_30\ ///
30,10,J(1,5,.)\ ///
J(9,1,40),AA,A_0_40,A_1_40,A_2_40,A_3_40,A_4_40\ ///
40,10,J(1,5,.)\ ///
J(9,1,50),AA,A_0_50,A_1_50,A_2_50,A_3_50,A_4_50\ ///
50,10,J(1,5,.)\ ///
J(9,1,60),AA,A_0_60,A_1_60,A_2_60,A_3_60,A_4_60\ ///
60,10,J(1,5,.))
clear
svmat double A
gen double D1 = A4-A3
gen double D2 = A5-A3
gen double D3 = A6-A3
gen double D4 = A7-A3
save reshof0_sex_`s'_ldl_`l'_DC0, replace
}
}
forval s = 0/1 {
foreach l in 0 3 4 5 {
use reshof0_sex_`s'_ldl_`l', clear
keep A1 A2 A3 A7
drop if A2 == 10
append using ///
ICthreshcosts_30_sex_`s'_ldl_`l' ///
ICthreshcosts_40_sex_`s'_ldl_`l' ///
ICthreshcosts_50_sex_`s'_ldl_`l' ///
ICthreshcosts_60_sex_`s'_ldl_`l'
bysort A1 (A2) : gen double AMIC = A7[7]
bysort A1 (A2) : gen double CMIC = A7[8]
bysort A1 (A2) : gen double RHCC = A3[9]
gen double THCC = A7+AMIC+CMIC if A2 >= 10
gen double DHCC = THCC-RHCC
bysort A1 (A2) : gen double DQLY = A7[5]-A3[5]
gen ICER = DHCC/DQLY
gen A = 1 if (ICER < 20000 & ICER[_n+1] >= 20000 & ICER[_n+1]!=.)
gen B = 1 if (ICER < 30000 & ICER[_n+1] >= 30000 & ICER[_n+1]!=.)
keep if A == 1 | B == 1
sort A A1
rename A2 cost
keep A1 cost A B
gen sex = `s'
gen ldl = `l'
gen dc = 3.5
save Treshres_sex`s'_ldl`l', replace
use reshof0_sex_`s'_ldl_`l'_DC0, clear
keep A1 A2 A3 A7
drop if A2 == 10
append using ///
ICthreshcosts_30_sex_`s'_ldl_`l'_DC0 ///
ICthreshcosts_40_sex_`s'_ldl_`l'_DC0 ///
ICthreshcosts_50_sex_`s'_ldl_`l'_DC0 ///
ICthreshcosts_60_sex_`s'_ldl_`l'_DC0
bysort A1 (A2) : gen double AMIC = A7[7]
bysort A1 (A2) : gen double CMIC = A7[8]
bysort A1 (A2) : gen double RHCC = A3[9]
gen double THCC = A7+AMIC+CMIC if A2 >= 10
gen double DHCC = THCC-RHCC
bysort A1 (A2) : gen double DQLY = A7[5]-A3[5]
gen ICER = DHCC/DQLY
gen A = 1 if (ICER < 20000 & ICER[_n+1] >= 20000 & ICER[_n+1]!=.)
gen B = 1 if (ICER < 30000 & ICER[_n+1] >= 30000 & ICER[_n+1]!=.)
keep if A == 1 | B == 1
sort A A1
rename A2 cost
keep A1 cost A B
gen sex = `s'
gen ldl = `l'
gen dc = 0
save Treshres_sex`s'_ldl`l'_DC0, replace
}
}
clear
forval s = 0/1 {
foreach l in 0 3 4 5 {
append using Treshres_sex`s'_ldl`l'
append using Treshres_sex`s'_ldl`l'_DC0
}
}
gen WTP = 20000 if A == 1
recode WTP .=30000
drop A B
replace dc = dc*-1
reshape wide cost, i(dc WTP sex A) j(ldl)
replace dc = dc*-1
tostring A1 sex, gen(A11 sex1)
tostring cost0-cost5, replace format(%9.0f)
tostring dc, gen(dc1) format(%9.1f)
tostring WTP, gen(WTP1) format(%9.0fc) force
replace dc1 = dc1+ "\%"
replace dc = dc*-1
order dc1 WTP1 sex1 A11
bysort dc (WTP sex A1) : replace dc1 ="" if _n !=1
bysort dc WTP (sex A1) : replace WTP1 ="" if _n !=1
bysort dc WTP sex (A1) : replace sex1 ="" if _n !=1
replace sex1 = "Female" if sex1 == "0"
replace sex1 = "Male" if sex1 == "1"
drop A1-WTP
export delimited using CSV/Treshres.csv, delimiter(":") novarnames replace
}
texdoc stlog close

/***
\color{black}

\begin{table}[h!]
  \begin{center}
    \caption{Maximum annual cost of Inclisiran (\textsterling) at which the ICER is under the UK willingness-to-pay (WTP) threshold, by discounting rate, WTP threshold, sex, and LDL-C.}
    \label{Tresh}
     \fontsize{7pt}{9pt}\selectfont\pgfplotstabletypeset[
      multicolumn names,
      col sep=colon,
      header=false,
      string type,
	  display columns/0/.style={column name=Discounting rate,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{16}{*}{##1}}}},
	  display columns/1/.style={column name=WTP threshold (\textsterling),
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{8}{*}{##1}}}},
	  display columns/2/.style={column name=Sex,
		assign cell content/.code={
\pgfkeyssetvalue{/pgfplots/table/@cell content}
{\multirow{4}{*}{##1}}}},
      display columns/3/.style={column name=Age of intervention, column type={l}},
      display columns/4/.style={column name=Overall, column type={r}, column type/.add={|}{}},
      display columns/5/.style={column name=$\geq$3.0 mmol/L, column type={r}},
      display columns/6/.style={column name=$\geq$4.0 mmol/L, column type={r}},
      display columns/7/.style={column name=$\geq$5.0 mmol/L, column type={r}, column type/.add={}{|}},
      every head row/.style={
        before row={\toprule
					& & & & & \multicolumn{3}{c}{LDL-C}\\
					},
        after row={\midrule}
            },
        every last row/.style={after row=\bottomrule},
    ]{CSV/Treshres.csv}
  \end{center}
\end{table}

So, even in the highest risk groups, and under the most generous scenario, the maximum cost-effective price
of Inclisiran doesn't approach the current price. Moreover, given that all other interventions in this study
were cost-effective, the comparator here is probably wrong (i.e.,  it should probably be one of the interventions),
which would make Inclisiran even less cost-effective. 


\clearpage
\bibliography{/Users/jed/Documents/Library.bib}
\end{document}

***/

texdoc close
