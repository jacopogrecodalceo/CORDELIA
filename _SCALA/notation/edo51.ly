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
	title = \markup {\override #'(font-name . "Longinus") "EDO51"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 51/4

			
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
					

						a4_"+23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"23.52"}
								\vspace #-.65
								\line {"446.02Hz"}
							}
						}
					

						a4_"+47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"47.05"}
								\vspace #-.65
								\line {"452.12Hz"}
							}
						}
					

						bes4_"-29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"70.58"}
								\vspace #-.65
								\line {"458.31Hz"}
							}
						}
					

						bes4_"-5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"94.11"}
								\vspace #-.65
								\line {"464.58Hz"}
							}
						}
					

						bes4_"+17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"117.6"}
								\vspace #-.65
								\line {"470.94Hz"}
							}
						}
					

						bes4_"+41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"141.1"}
								\vspace #-.65
								\line {"477.38Hz"}
							}
						}
					

						b4_"-35.29c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"164.7"}
								\vspace #-.65
								\line {"483.92Hz"}
							}
						}
					

						b4_"-11.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"188.2"}
								\vspace #-.65
								\line {"490.54Hz"}
							}
						}
					

						b4_"+11.77c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"211.7"}
								\vspace #-.65
								\line {"497.25Hz"}
							}
						}
					

						b4_"+35.3c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"235.2"}
								\vspace #-.65
								\line {"504.06Hz"}
							}
						}
					

						c4_"-41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"258.8"}
								\vspace #-.65
								\line {"510.95Hz"}
							}
						}
					

						c4_"-17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"12"}
								\vspace #-.65
								\line {"282.3"}
								\vspace #-.65
								\line {"517.94Hz"}
							}
						}
					

						c4_"+5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"13"}
								\vspace #-.65
								\line {"305.8"}
								\vspace #-.65
								\line {"525.03Hz"}
							}
						}
					

						c4_"+29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"14"}
								\vspace #-.65
								\line {"329.4"}
								\vspace #-.65
								\line {"532.22Hz"}
							}
						}
					

						cis4_"-47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"15"}
								\vspace #-.65
								\line {"352.9"}
								\vspace #-.65
								\line {"539.50Hz"}
							}
						}
					

						cis4_"-23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"16"}
								\vspace #-.65
								\line {"376.4"}
								\vspace #-.65
								\line {"546.88Hz"}
							}
						}
					

						cis4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"17"}
								\vspace #-.65
								\line {"400.0"}
								\vspace #-.65
								\line {"554.37Hz"}
							}
						}
					

						cis4_"+23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"18"}
								\vspace #-.65
								\line {"423.5"}
								\vspace #-.65
								\line {"561.95Hz"}
							}
						}
					

						cis4_"+47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"19"}
								\vspace #-.65
								\line {"447.0"}
								\vspace #-.65
								\line {"569.64Hz"}
							}
						}
					

						d4_"-29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"20"}
								\vspace #-.65
								\line {"470.5"}
								\vspace #-.65
								\line {"577.44Hz"}
							}
						}
					

						d4_"-5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"21"}
								\vspace #-.65
								\line {"494.1"}
								\vspace #-.65
								\line {"585.34Hz"}
							}
						}
					

						d4_"+17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"22"}
								\vspace #-.65
								\line {"517.6"}
								\vspace #-.65
								\line {"593.35Hz"}
							}
						}
					

						d4_"+41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"23"}
								\vspace #-.65
								\line {"541.1"}
								\vspace #-.65
								\line {"601.47Hz"}
							}
						}
					

						ees4_"-35.29c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"24"}
								\vspace #-.65
								\line {"564.7"}
								\vspace #-.65
								\line {"609.70Hz"}
							}
						}
					

						ees4_"-11.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"25"}
								\vspace #-.65
								\line {"588.2"}
								\vspace #-.65
								\line {"618.04Hz"}
							}
						}
					

						ees4_"+11.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"26"}
								\vspace #-.65
								\line {"611.7"}
								\vspace #-.65
								\line {"626.50Hz"}
							}
						}
					

						ees4_"+35.29c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"27"}
								\vspace #-.65
								\line {"635.2"}
								\vspace #-.65
								\line {"635.07Hz"}
							}
						}
					

						e4_"-41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"28"}
								\vspace #-.65
								\line {"658.8"}
								\vspace #-.65
								\line {"643.76Hz"}
							}
						}
					

						e4_"-17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"29"}
								\vspace #-.65
								\line {"682.3"}
								\vspace #-.65
								\line {"652.57Hz"}
							}
						}
					

						e4_"+5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"30"}
								\vspace #-.65
								\line {"705.8"}
								\vspace #-.65
								\line {"661.50Hz"}
							}
						}
					

						e4_"+29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"31"}
								\vspace #-.65
								\line {"729.4"}
								\vspace #-.65
								\line {"670.55Hz"}
							}
						}
					

						f4_"-47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"32"}
								\vspace #-.65
								\line {"752.9"}
								\vspace #-.65
								\line {"679.73Hz"}
							}
						}
					

						f4_"-23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"33"}
								\vspace #-.65
								\line {"776.4"}
								\vspace #-.65
								\line {"689.03Hz"}
							}
						}
					

						f4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"34"}
								\vspace #-.65
								\line {"800.0"}
								\vspace #-.65
								\line {"698.46Hz"}
							}
						}
					

						f4_"+23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"35"}
								\vspace #-.65
								\line {"823.5"}
								\vspace #-.65
								\line {"708.01Hz"}
							}
						}
					

						f4_"+47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"36"}
								\vspace #-.65
								\line {"847.0"}
								\vspace #-.65
								\line {"717.70Hz"}
							}
						}
					

						fis4_"-29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"37"}
								\vspace #-.65
								\line {"870.5"}
								\vspace #-.65
								\line {"727.52Hz"}
							}
						}
					

						fis4_"-5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"38"}
								\vspace #-.65
								\line {"894.1"}
								\vspace #-.65
								\line {"737.48Hz"}
							}
						}
					

						fis4_"+17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"39"}
								\vspace #-.65
								\line {"917.6"}
								\vspace #-.65
								\line {"747.57Hz"}
							}
						}
					

						fis4_"+41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"40"}
								\vspace #-.65
								\line {"941.1"}
								\vspace #-.65
								\line {"757.80Hz"}
							}
						}
					

						g4_"-35.29c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"41"}
								\vspace #-.65
								\line {"964.7"}
								\vspace #-.65
								\line {"768.17Hz"}
							}
						}
					

						g4_"-11.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"42"}
								\vspace #-.65
								\line {"988.2"}
								\vspace #-.65
								\line {"778.68Hz"}
							}
						}
					

						g4_"+11.76c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"43"}
								\vspace #-.65
								\line {"1011."}
								\vspace #-.65
								\line {"789.34Hz"}
							}
						}
					

						g4_"+35.29c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"44"}
								\vspace #-.65
								\line {"1035."}
								\vspace #-.65
								\line {"800.14Hz"}
							}
						}
					

						aes4_"-41.18c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"45"}
								\vspace #-.65
								\line {"1058."}
								\vspace #-.65
								\line {"811.09Hz"}
							}
						}
					

						aes4_"-17.65c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"46"}
								\vspace #-.65
								\line {"1082."}
								\vspace #-.65
								\line {"822.19Hz"}
							}
						}
					

						aes4_"+5.88c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"47"}
								\vspace #-.65
								\line {"1105."}
								\vspace #-.65
								\line {"833.44Hz"}
							}
						}
					

						aes4_"+29.41c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"48"}
								\vspace #-.65
								\line {"1129."}
								\vspace #-.65
								\line {"844.84Hz"}
							}
						}
					

						a4_"-47.06c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"49"}
								\vspace #-.65
								\line {"1152."}
								\vspace #-.65
								\line {"856.40Hz"}
							}
						}
					

						a4_"-23.53c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"50"}
								\vspace #-.65
								\line {"1176."}
								\vspace #-.65
								\line {"868.12Hz"}
							}
						}
					

		}
	}
}

