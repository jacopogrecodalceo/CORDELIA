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
	title = \markup {\override #'(font-name . "Longinus") "UNDETR2 12"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 12/4

			
						a4_"+0.0c"^\markup {
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
								\line {"440.00Hz"}
							}
						}
					

						b4_"+9.98c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"496.74Hz"}
							}
						}
					

						cis4_"-25.02c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"546.41Hz"}
							}
						}
					

						cis4_"+19.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"419.9"}
								\vspace #-.65
								\line {"560.79Hz"}
							}
						}
					

						d4_"+39.98c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"601.05Hz"}
							}
						}
					

						ees4_"-15.05c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"584.9"}
								\vspace #-.65
								\line {"616.87Hz"}
							}
						}
					

						e4_"+4.99c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"2000/"}
								\vspace #-.65
								\line {"661.16Hz"}
							}
						}
					

						e4_"+49.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"749.9"}
								\vspace #-.65
								\line {"678.56Hz"}
							}
						}
					

						fis4_"-30.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"200/1"}
								\vspace #-.65
								\line {"727.27Hz"}
							}
						}
					

						fis4_"+14.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"914.9"}
								\vspace #-.65
								\line {"746.41Hz"}
							}
						}
					

						g4_"+35.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"large minor seventh"
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"20/11"}
								\vspace #-.65
								\line {"800.00Hz"}
							}
						}
					

						aes4_"-20.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"40000"}
								\vspace #-.65
								\line {"821.05Hz"}
							}
						}
					

						a4_"+44.97c"^\markup {
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
								\line {"903.16Hz"}
							}
						}
					

						c4_"-45.05c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"1019.62Hz"}
							}
						}
					

						cis4_"+19.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"1121.58Hz"}
							}
						}
					

						d4_"-35.08c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"419.9"}
								\vspace #-.65
								\line {"1151.10Hz"}
							}
						}
					

						ees4_"-15.05c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"1233.74Hz"}
							}
						}
					

						ees4_"+29.92c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"584.9"}
								\vspace #-.65
								\line {"1266.21Hz"}
							}
						}
					

						e4_"+49.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"2000/"}
								\vspace #-.65
								\line {"1357.11Hz"}
							}
						}
					

						f4_"-5.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"749.9"}
								\vspace #-.65
								\line {"1392.83Hz"}
							}
						}
					

						fis4_"+14.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"200/1"}
								\vspace #-.65
								\line {"1492.82Hz"}
							}
						}
					

						g4_"-40.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"914.9"}
								\vspace #-.65
								\line {"1532.11Hz"}
							}
						}
					

						aes4_"-20.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"large minor seventh"
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"20/11"}
								\vspace #-.65
								\line {"1642.11Hz"}
							}
						}
					

						aes4_"+24.94c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"40000"}
								\vspace #-.65
								\line {"1685.32Hz"}
							}
						}
					

						bes4_"-10.06c"^\markup {
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
								\line {"1853.85Hz"}
							}
						}
					

						c4_"-0.08c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"2092.90Hz"}
							}
						}
					

						d4_"-35.08c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"2302.19Hz"}
							}
						}
					

						d4_"+9.89c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"419.9"}
								\vspace #-.65
								\line {"2362.78Hz"}
							}
						}
					

						ees4_"+29.92c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"2532.41Hz"}
							}
						}
					

						e4_"-25.11c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"584.9"}
								\vspace #-.65
								\line {"2599.06Hz"}
							}
						}
					

						f4_"-5.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"2000/"}
								\vspace #-.65
								\line {"2785.65Hz"}
							}
						}
					

						f4_"+39.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"749.9"}
								\vspace #-.65
								\line {"2858.96Hz"}
							}
						}
					

						g4_"-40.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"200/1"}
								\vspace #-.65
								\line {"3064.22Hz"}
							}
						}
					

						g4_"+4.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"914.9"}
								\vspace #-.65
								\line {"3144.86Hz"}
							}
						}
					

						aes4_"+24.94c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"large minor seventh"
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"20/11"}
								\vspace #-.65
								\line {"3370.64Hz"}
							}
						}
					

						a4_"-30.09c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"40000"}
								\vspace #-.65
								\line {"3459.34Hz"}
							}
						}
					

						bes4_"+34.91c"^\markup {
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
								\line {"3805.28Hz"}
							}
						}
					

						c4_"+44.89c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"4295.96Hz"}
							}
						}
					

						d4_"+9.89c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"4725.56Hz"}
							}
						}
					

						ees4_"-45.14c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"419.9"}
								\vspace #-.65
								\line {"4849.91Hz"}
							}
						}
					

						e4_"-25.11c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"5198.11Hz"}
							}
						}
					

						e4_"+19.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"584.9"}
								\vspace #-.65
								\line {"5334.91Hz"}
							}
						}
					

						f4_"+39.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"2000/"}
								\vspace #-.65
								\line {"5717.92Hz"}
							}
						}
					

						fis4_"-15.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"749.9"}
								\vspace #-.65
								\line {"5868.40Hz"}
							}
						}
					

						g4_"+4.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"200/1"}
								\vspace #-.65
								\line {"6289.71Hz"}
							}
						}
					

						g4_"+49.87c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"914.9"}
								\vspace #-.65
								\line {"6455.24Hz"}
							}
						}
					

						a4_"-30.09c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"large minor seventh"
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"20/11"}
								\vspace #-.65
								\line {"6918.69Hz"}
							}
						}
					

						a4_"+14.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"40000"}
								\vspace #-.65
								\line {"7100.76Hz"}
							}
						}
					

						b4_"-20.12c"^\markup {
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
								\line {"7810.83Hz"}
							}
						}
					

						cis4_"-10.14c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"8818.03Hz"}
							}
						}
					

						ees4_"-45.14c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"9699.83Hz"}
							}
						}
					

						ees4_"-0.17c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"419.9"}
								\vspace #-.65
								\line {"9955.09Hz"}
							}
						}
					

						e4_"+19.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"20000"}
								\vspace #-.65
								\line {"10669.81Hz"}
							}
						}
					

						f4_"-35.16c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"584.9"}
								\vspace #-.65
								\line {"10950.60Hz"}
							}
						}
					

						fis4_"-15.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"2000/"}
								\vspace #-.65
								\line {"11736.79Hz"}
							}
						}
					

						fis4_"+29.84c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"749.9"}
								\vspace #-.65
								\line {"12045.66Hz"}
							}
						}
					

						g4_"+49.87c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"200/1"}
								\vspace #-.65
								\line {"12910.47Hz"}
							}
						}
					

						g4_"+94.84c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"914.9"}
								\vspace #-.65
								\line {"13250.23Hz"}
							}
						}
					

						g4_"+214.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"large minor seventh"
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"20/11"}
								\vspace #-.65
								\line {"14201.52Hz"}
							}
						}
					

		}
	}
}

