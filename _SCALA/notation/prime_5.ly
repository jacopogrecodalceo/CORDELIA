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
	title = \markup {\override #'(font-name . "Longinus") "PRIME 5"}
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
					

						d4_"+3.91c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"major whole tone"
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"9/8"}
								\vspace #-.65
								\line {"1177.31Hz"}
							}
						}
					

						e4_"-13.69c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"major third"
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"5/4"}
								\vspace #-.65
								\line {"1308.13Hz"}
							}
						}
					

						g4_"+1.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fifth"
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"3/2"}
								\vspace #-.65
								\line {"1569.75Hz"}
							}
						}
					

						a4_"-15.64c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"major sixth, BP sixth"
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"5/3"}
								\vspace #-.65
								\line {"1744.17Hz"}
							}
						}
					

		}
	}
}

