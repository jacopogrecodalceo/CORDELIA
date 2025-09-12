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
	title = \markup {\override #'(font-name . "Longinus") "MYSTIC"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 5/4

			
						ees4_"+0.0c"^\markup {
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
								\line {"77.78Hz"}
							}
						}
					

						a4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"110.00Hz"}
							}
						}
					

						cis4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"138.59Hz"}
							}
						}
					

						g4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"196.00Hz"}
							}
						}
					

						c4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"261.63Hz"}
							}
						}
					

						f4_"+0.01c"^\markup {
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
								\line {"349.23Hz"}
							}
						}
					

						b4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"493.88Hz"}
							}
						}
					

						ees4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"622.26Hz"}
							}
						}
					

						a4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"880.00Hz"}
							}
						}
					

						d4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"1174.66Hz"}
							}
						}
					

						g4_"+0.01c"^\markup {
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
								\line {"1567.99Hz"}
							}
						}
					

						cis4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"2217.47Hz"}
							}
						}
					

						f4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"2793.83Hz"}
							}
						}
					

						b4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"3951.08Hz"}
							}
						}
					

						e4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"5274.06Hz"}
							}
						}
					

						a4_"+0.01c"^\markup {
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
								\line {"7040.02Hz"}
							}
						}
					

						ees4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"9956.10Hz"}
							}
						}
					

						g4_"+0.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"12543.89Hz"}
							}
						}
					

						g4_"+600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"17739.75Hz"}
							}
						}
					

						g4_"+1100.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"23679.72Hz"}
							}
						}
					

						g4_"+1600.01c"^\markup {
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
								\line {"31608.63Hz"}
							}
						}
					

						g4_"+2200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"44701.36Hz"}
							}
						}
					

						g4_"+2600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"56320.18Hz"}
							}
						}
					

						g4_"+3200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"79648.77Hz"}
							}
						}
					

						g4_"+3700.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"106318.35Hz"}
							}
						}
					

						g4_"+4200.01c"^\markup {
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
								\line {"141917.97Hz"}
							}
						}
					

						g4_"+4800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"200702.32Hz"}
							}
						}
					

						g4_"+5200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"252869.08Hz"}
							}
						}
					

						g4_"+5800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"357610.88Hz"}
							}
						}
					

						g4_"+6300.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"477353.25Hz"}
							}
						}
					

						g4_"+6800.01c"^\markup {
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
								\line {"637190.14Hz"}
							}
						}
					

						g4_"+7400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"901122.94Hz"}
							}
						}
					

						g4_"+7800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"1135343.77Hz"}
							}
						}
					

						g4_"+8400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"1605618.55Hz"}
							}
						}
					

						g4_"+8900.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"2143243.63Hz"}
							}
						}
					

						g4_"+9400.01c"^\markup {
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
								\line {"2860887.02Hz"}
							}
						}
					

						g4_"+10000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"4045905.22Hz"}
							}
						}
					

						g4_"+10400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"5097521.15Hz"}
							}
						}
					

						g4_"+11000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"7208983.55Hz"}
							}
						}
					

						g4_"+11500.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"9622838.55Hz"}
							}
						}
					

						g4_"+12000.01c"^\markup {
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
								\line {"12844948.40Hz"}
							}
						}
					

						g4_"+12600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"18165500.24Hz"}
							}
						}
					

						g4_"+13000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"22887096.13Hz"}
							}
						}
					

						g4_"+13600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"32367241.76Hz"}
							}
						}
					

						g4_"+14100.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"43205084.27Hz"}
							}
						}
					

						g4_"+14600.01c"^\markup {
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
								\line {"57671868.38Hz"}
							}
						}
					

						g4_"+15200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"81560338.43Hz"}
							}
						}
					

						g4_"+15600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"102759587.23Hz"}
							}
						}
					

						g4_"+16200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"145324001.92Hz"}
							}
						}
					

						g4_"+16700.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"193984269.53Hz"}
							}
						}
					

						g4_"+17200.01c"^\markup {
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
								\line {"258937934.05Hz"}
							}
						}
					

						g4_"+17800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"366193538.15Hz"}
							}
						}
					

						g4_"+18200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"461374947.05Hz"}
							}
						}
					

						g4_"+18800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"652482707.46Hz"}
							}
						}
					

						g4_"+19300.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"870959922.07Hz"}
							}
						}
					

						g4_"+19800.01c"^\markup {
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
								\line {"1162592015.36Hz"}
							}
						}
					

						g4_"+20400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"1644153395.63Hz"}
							}
						}
					

						g4_"+20800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"2071503472.41Hz"}
							}
						}
					

						g4_"+21400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"2929548305.19Hz"}
							}
						}
					

						g4_"+21900.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"3910477832.48Hz"}
							}
						}
					

						g4_"+22400.01c"^\markup {
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
								\line {"5219861659.65Hz"}
							}
						}
					

						g4_"+23000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"7381999152.79Hz"}
							}
						}
					

						g4_"+23400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"9300736122.90Hz"}
							}
						}
					

						g4_"+24000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"13153227165.06Hz"}
							}
						}
					

						g4_"+24500.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"17557451830.87Hz"}
							}
						}
					

						g4_"+25000.01c"^\markup {
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
								\line {"23436386441.52Hz"}
							}
						}
					

						g4_"+25600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"33144055558.61Hz"}
							}
						}
					

						g4_"+26000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"41758893277.18Hz"}
							}
						}
					

						g4_"+26600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"59055993222.28Hz"}
							}
						}
					

						g4_"+27100.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"78830293380.70Hz"}
							}
						}
					

						g4_"+27600.01c"^\markup {
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
								\line {"105225817320.48Hz"}
							}
						}
					

						g4_"+28200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"148811777966.41Hz"}
							}
						}
					

						g4_"+28600.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"187491091532.16Hz"}
							}
						}
					

						g4_"+29200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"265152444468.92Hz"}
							}
						}
					

						g4_"+29700.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"353936050307.72Hz"}
							}
						}
					

						g4_"+30200.01c"^\markup {
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
								\line {"472447945778.27Hz"}
							}
						}
					

						g4_"+30800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"668142292434.94Hz"}
							}
						}
					

						g4_"+31200.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"841806538563.80Hz"}
							}
						}
					

						g4_"+31800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"1190494223731.28Hz"}
							}
						}
					

						g4_"+32300.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"1589119135995.72Hz"}
							}
						}
					

						g4_"+32800.01c"^\markup {
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
								\line {"2121219555751.34Hz"}
							}
						}
					

						g4_"+33400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"2999857464514.58Hz"}
							}
						}
					

						g4_"+33800.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"3779583566226.18Hz"}
							}
						}
					

						g4_"+34400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"5345138339479.54Hz"}
							}
						}
					

						g4_"+34900.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"2100."}
								\vspace #-.65
								\line {"7134903681589.53Hz"}
							}
						}
					

						g4_"+35400.01c"^\markup {
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
								\line {"9523953789850.20Hz"}
							}
						}
					

						g4_"+36000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"13468904617020.80Hz"}
							}
						}
					

						g4_"+36400.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"1000."}
								\vspace #-.65
								\line {"16969756446010.74Hz"}
							}
						}
					

						g4_"+37000.01c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"1600."}
								\vspace #-.65
								\line {"23998859716116.65Hz"}
							}
						}
					

		}
	}
}

