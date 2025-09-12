\version "2.24.0"

#(use-modules (ice-9 pretty-print))
#(define-public (format-time-sig-note grob)
   (let* ((frac (ly:grob-property grob 'fraction))
		  (num (if (pair? frac) (car frac) 4))
		  (den (if (pair? frac) (cdr frac) 4))
		  (m (markup #:override '(baseline-skip . 0.5)
					 #:center-column (#:number (number->string num)
											   #:override '(style . default)
											   #:note 
												 (ly:make-duration (1- (integer-length den)) 0 1)
												 DOWN))))
	 (grob-interpret-markup grob m)))

#(set-global-staff-size 48)

date = #(strftime "%d-%m-%Y" (localtime (current-time)))

\paper {
	indent = #0
	%annotate-spacing = ##t
	#(set-paper-size "a4landscape")
	%left-margin = 15
	%bottom-margin = 10
	%top-margin = 15
	%ragged-last-bottom = ##f
	%ragged-last = ##t
	%line-width = #150
	print-page-number = ##f
	%system-count = #4
	%page-breaking = #ly:one-line-breaking
	%system-separator-markup = \slashSeparator

	score-system-spacing =
		#'((basic-distance . 12)
		(minimum-distance . 12)
		(padding . 1)
		(stretchability . 5))

	#(define fonts
	(set-global-fonts
		#:roman "Courier New"
		#:music "lilyboulez"
		#:brace "lilyboulez"
	))
}

\layout {
	\context {
		\Score
		%\override TimeSignature.stencil = #format-time-sig-note
		\override TimeSignature.font-name = "Longinus"
		\override TimeSignature.font-size = #2
		\override TimeSignature.stencil = #format-time-sig-note
		\override Clef.font-size = #5
		proportionalNotationDuration = #(ly:make-moment 1/24)
	}
}
\header {
	title = \markup {\override #'(font-name . "Longinus") "JI5COH"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 5/4

			
						c4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"unison, perfect prime"
										}		
									}
								\vspace #.15
								\line {"00"}
								\vspace #-.65
								\line {"1/1"}
								\vspace #-.65
								\line {"1046.50Hz"}
							}
						}
					

						ees4_"-33.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"septimal minor third"
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"7/6"}
								\vspace #-.65
								\line {"1220.92Hz"}
							}
						}
					

						f4_"-1.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fourth"
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"4/3"}
								\vspace #-.65
								\line {"1395.34Hz"}
							}
						}
					

						g4_"-46.82c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"septimal semi-diminished fifth"
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"35/24"}
								\vspace #-.65
								\line {"1526.15Hz"}
							}
						}
					

						a4_"+27.11c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"41/24"}
								\vspace #-.65
								\line {"1787.77Hz"}
							}
						}
					

		}
	}
}

