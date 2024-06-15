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
	title = \markup {\override #'(font-name . "Longinus") "EDO71"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 71/4

			
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
					

						a4_"+16.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"16.90"}
								\vspace #-.65
								\line {"444.32Hz"}
							}
						}
					

						a4_"+33.8c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"33.80"}
								\vspace #-.65
								\line {"448.68Hz"}
							}
						}
					

						a4_"+50.7c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"50.70"}
								\vspace #-.65
								\line {"453.08Hz"}
							}
						}
					

						bes4_"-32.4c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"67.60"}
								\vspace #-.65
								\line {"457.52Hz"}
							}
						}
					

						bes4_"-15.49c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"84.50"}
								\vspace #-.65
								\line {"462.01Hz"}
							}
						}
					

						bes4_"+1.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"101.4"}
								\vspace #-.65
								\line {"466.54Hz"}
							}
						}
					

						bes4_"+18.31c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"118.3"}
								\vspace #-.65
								\line {"471.12Hz"}
							}
						}
					

						bes4_"+35.21c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"135.2"}
								\vspace #-.65
								\line {"475.74Hz"}
							}
						}
					

						b4_"-47.89c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"152.1"}
								\vspace #-.65
								\line {"480.41Hz"}
							}
						}
					

						b4_"-30.98c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"169.0"}
								\vspace #-.65
								\line {"485.12Hz"}
							}
						}
					

						b4_"-14.08c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"185.9"}
								\vspace #-.65
								\line {"489.88Hz"}
							}
						}
					

						b4_"+2.82c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"12"}
								\vspace #-.65
								\line {"202.8"}
								\vspace #-.65
								\line {"494.69Hz"}
							}
						}
					

						b4_"+19.72c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"13"}
								\vspace #-.65
								\line {"219.7"}
								\vspace #-.65
								\line {"499.54Hz"}
							}
						}
					

						b4_"+36.62c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"14"}
								\vspace #-.65
								\line {"236.6"}
								\vspace #-.65
								\line {"504.44Hz"}
							}
						}
					

						c4_"-46.48c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"15"}
								\vspace #-.65
								\line {"253.5"}
								\vspace #-.65
								\line {"509.39Hz"}
							}
						}
					

						c4_"-29.58c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"16"}
								\vspace #-.65
								\line {"270.4"}
								\vspace #-.65
								\line {"514.39Hz"}
							}
						}
					

						c4_"-12.68c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"17"}
								\vspace #-.65
								\line {"287.3"}
								\vspace #-.65
								\line {"519.43Hz"}
							}
						}
					

						c4_"+4.23c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"18"}
								\vspace #-.65
								\line {"304.2"}
								\vspace #-.65
								\line {"524.53Hz"}
							}
						}
					

						c4_"+21.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"19"}
								\vspace #-.65
								\line {"321.1"}
								\vspace #-.65
								\line {"529.68Hz"}
							}
						}
					

						c4_"+38.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"20"}
								\vspace #-.65
								\line {"338.0"}
								\vspace #-.65
								\line {"534.87Hz"}
							}
						}
					

						cis4_"-45.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"21"}
								\vspace #-.65
								\line {"354.9"}
								\vspace #-.65
								\line {"540.12Hz"}
							}
						}
					

						cis4_"-28.17c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"22"}
								\vspace #-.65
								\line {"371.8"}
								\vspace #-.65
								\line {"545.42Hz"}
							}
						}
					

						cis4_"-11.27c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"23"}
								\vspace #-.65
								\line {"388.7"}
								\vspace #-.65
								\line {"550.77Hz"}
							}
						}
					

						cis4_"+5.63c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"24"}
								\vspace #-.65
								\line {"405.6"}
								\vspace #-.65
								\line {"556.17Hz"}
							}
						}
					

						cis4_"+22.54c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"25"}
								\vspace #-.65
								\line {"422.5"}
								\vspace #-.65
								\line {"561.63Hz"}
							}
						}
					

						cis4_"+39.44c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"26"}
								\vspace #-.65
								\line {"439.4"}
								\vspace #-.65
								\line {"567.14Hz"}
							}
						}
					

						d4_"-43.66c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"27"}
								\vspace #-.65
								\line {"456.3"}
								\vspace #-.65
								\line {"572.70Hz"}
							}
						}
					

						d4_"-26.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"28"}
								\vspace #-.65
								\line {"473.2"}
								\vspace #-.65
								\line {"578.32Hz"}
							}
						}
					

						d4_"-9.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"29"}
								\vspace #-.65
								\line {"490.1"}
								\vspace #-.65
								\line {"583.99Hz"}
							}
						}
					

						d4_"+7.04c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"30"}
								\vspace #-.65
								\line {"507.0"}
								\vspace #-.65
								\line {"589.72Hz"}
							}
						}
					

						d4_"+23.94c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"31"}
								\vspace #-.65
								\line {"523.9"}
								\vspace #-.65
								\line {"595.51Hz"}
							}
						}
					

						d4_"+40.84c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"32"}
								\vspace #-.65
								\line {"540.8"}
								\vspace #-.65
								\line {"601.35Hz"}
							}
						}
					

						ees4_"-42.25c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"33"}
								\vspace #-.65
								\line {"557.7"}
								\vspace #-.65
								\line {"607.25Hz"}
							}
						}
					

						ees4_"-25.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"34"}
								\vspace #-.65
								\line {"574.6"}
								\vspace #-.65
								\line {"613.21Hz"}
							}
						}
					

						ees4_"-8.45c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"35"}
								\vspace #-.65
								\line {"591.5"}
								\vspace #-.65
								\line {"619.22Hz"}
							}
						}
					

						ees4_"+8.45c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"36"}
								\vspace #-.65
								\line {"608.4"}
								\vspace #-.65
								\line {"625.30Hz"}
							}
						}
					

						ees4_"+25.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"37"}
								\vspace #-.65
								\line {"625.3"}
								\vspace #-.65
								\line {"631.43Hz"}
							}
						}
					

						ees4_"+42.25c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"38"}
								\vspace #-.65
								\line {"642.2"}
								\vspace #-.65
								\line {"637.63Hz"}
							}
						}
					

						e4_"-40.84c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"39"}
								\vspace #-.65
								\line {"659.1"}
								\vspace #-.65
								\line {"643.88Hz"}
							}
						}
					

						e4_"-23.94c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"40"}
								\vspace #-.65
								\line {"676.0"}
								\vspace #-.65
								\line {"650.20Hz"}
							}
						}
					

						e4_"-7.04c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"41"}
								\vspace #-.65
								\line {"692.9"}
								\vspace #-.65
								\line {"656.58Hz"}
							}
						}
					

						e4_"+9.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"42"}
								\vspace #-.65
								\line {"709.8"}
								\vspace #-.65
								\line {"663.02Hz"}
							}
						}
					

						e4_"+26.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"43"}
								\vspace #-.65
								\line {"726.7"}
								\vspace #-.65
								\line {"669.52Hz"}
							}
						}
					

						e4_"+43.66c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"44"}
								\vspace #-.65
								\line {"743.6"}
								\vspace #-.65
								\line {"676.09Hz"}
							}
						}
					

						f4_"-39.44c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"45"}
								\vspace #-.65
								\line {"760.5"}
								\vspace #-.65
								\line {"682.73Hz"}
							}
						}
					

						f4_"-22.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"46"}
								\vspace #-.65
								\line {"777.4"}
								\vspace #-.65
								\line {"689.42Hz"}
							}
						}
					

						f4_"-5.63c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"47"}
								\vspace #-.65
								\line {"794.3"}
								\vspace #-.65
								\line {"696.19Hz"}
							}
						}
					

						f4_"+11.27c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"48"}
								\vspace #-.65
								\line {"811.2"}
								\vspace #-.65
								\line {"703.02Hz"}
							}
						}
					

						f4_"+28.17c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"49"}
								\vspace #-.65
								\line {"828.1"}
								\vspace #-.65
								\line {"709.91Hz"}
							}
						}
					

						f4_"+45.07c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"50"}
								\vspace #-.65
								\line {"845.0"}
								\vspace #-.65
								\line {"716.88Hz"}
							}
						}
					

						fis4_"-38.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"51"}
								\vspace #-.65
								\line {"861.9"}
								\vspace #-.65
								\line {"723.91Hz"}
							}
						}
					

						fis4_"-21.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"52"}
								\vspace #-.65
								\line {"878.8"}
								\vspace #-.65
								\line {"731.01Hz"}
							}
						}
					

						fis4_"-4.23c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"53"}
								\vspace #-.65
								\line {"895.7"}
								\vspace #-.65
								\line {"738.18Hz"}
							}
						}
					

						fis4_"+12.68c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"54"}
								\vspace #-.65
								\line {"912.6"}
								\vspace #-.65
								\line {"745.43Hz"}
							}
						}
					

						fis4_"+29.58c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"55"}
								\vspace #-.65
								\line {"929.5"}
								\vspace #-.65
								\line {"752.74Hz"}
							}
						}
					

						fis4_"+46.48c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"56"}
								\vspace #-.65
								\line {"946.4"}
								\vspace #-.65
								\line {"760.12Hz"}
							}
						}
					

						g4_"-36.62c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"57"}
								\vspace #-.65
								\line {"963.3"}
								\vspace #-.65
								\line {"767.58Hz"}
							}
						}
					

						g4_"-19.72c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"58"}
								\vspace #-.65
								\line {"980.2"}
								\vspace #-.65
								\line {"775.11Hz"}
							}
						}
					

		}
	}
}

