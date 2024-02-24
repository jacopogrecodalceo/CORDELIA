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
	title = \markup {\override #'(font-name . "Longinus") "CHIN 7"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 7/4

			
						b4_"+0.0c"^\markup {
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
								\line {"493.88Hz"}
							}
						}
					

						cis4_"+3.91c"^\markup {
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
								\line {"555.62Hz"}
							}
						}
					

						ees4_"+7.82c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"Pythagorean major third"
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"81/64"}
								\vspace #-.65
								\line {"625.07Hz"}
							}
						}
					

						e4_"-1.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fourth"
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"4/3"}
								\vspace #-.65
								\line {"658.51Hz"}
							}
						}
					

						fis4_"+1.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fifth"
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"3/2"}
								\vspace #-.65
								\line {"740.82Hz"}
							}
						}
					

						aes4_"+5.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"Pythagorean major sixth"
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"27/16"}
								\vspace #-.65
								\line {"833.43Hz"}
							}
						}
					

						bes4_"+9.77c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"243/1"}
								\vspace #-.65
								\line {"937.61Hz"}
							}
						}
					

		}
	}
}

