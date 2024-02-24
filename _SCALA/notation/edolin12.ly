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
	title = \markup {\override #'(font-name . "Longinus") "EDOLIN12"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 12/4

			
						d4_"+0.0c"^\markup {
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
								\line {"293.67Hz"}
							}
						}
					

						ees4_"+38.57c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"1+(1/"}
								\vspace #-.65
								\line {"318.14Hz"}
							}
						}
					

						f4_"-33.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1+(2/"}
								\vspace #-.65
								\line {"342.61Hz"}
							}
						}
					

						fis4_"-13.68c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1+(3/"}
								\vspace #-.65
								\line {"367.08Hz"}
							}
						}
					

						g4_"-1.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"1+(4/"}
								\vspace #-.65
								\line {"391.55Hz"}
							}
						}
					

						aes4_"+3.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"1+(5/"}
								\vspace #-.65
								\line {"416.03Hz"}
							}
						}
					

						a4_"+1.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"1+(6/"}
								\vspace #-.65
								\line {"440.50Hz"}
							}
						}
					

						bes4_"-4.44c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"1+(7/"}
								\vspace #-.65
								\line {"464.97Hz"}
							}
						}
					

						b4_"-15.64c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"1+(8/"}
								\vspace #-.65
								\line {"489.44Hz"}
							}
						}
					

						c4_"-31.17c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"1+(9/"}
								\vspace #-.65
								\line {"513.91Hz"}
							}
						}
					

						c4_"+49.36c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"1+(10"}
								\vspace #-.65
								\line {"538.39Hz"}
							}
						}
					

						cis4_"+26.32c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"1+(11"}
								\vspace #-.65
								\line {"562.86Hz"}
							}
						}
					

		}
	}
}

