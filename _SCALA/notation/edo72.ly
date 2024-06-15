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
	title = \markup {\override #'(font-name . "Longinus") "EDO72"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 72/4

			
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
					

						a4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"16.66"}
								\vspace #-.65
								\line {"444.26Hz"}
							}
						}
					

						a4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"33.33"}
								\vspace #-.65
								\line {"448.55Hz"}
							}
						}
					

						a4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"50.0"}
								\vspace #-.65
								\line {"452.89Hz"}
							}
						}
					

						bes4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"66.66"}
								\vspace #-.65
								\line {"457.27Hz"}
							}
						}
					

						bes4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"83.33"}
								\vspace #-.65
								\line {"461.70Hz"}
							}
						}
					

						bes4_"+-0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"100.0"}
								\vspace #-.65
								\line {"466.16Hz"}
							}
						}
					

						bes4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"116.6"}
								\vspace #-.65
								\line {"470.67Hz"}
							}
						}
					

						bes4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"133.3"}
								\vspace #-.65
								\line {"475.23Hz"}
							}
						}
					

						bes4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"150.0"}
								\vspace #-.65
								\line {"479.82Hz"}
							}
						}
					

						b4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"166.6"}
								\vspace #-.65
								\line {"484.46Hz"}
							}
						}
					

						b4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"183.3"}
								\vspace #-.65
								\line {"489.15Hz"}
							}
						}
					

						b4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"12"}
								\vspace #-.65
								\line {"200.0"}
								\vspace #-.65
								\line {"493.88Hz"}
							}
						}
					

						b4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"13"}
								\vspace #-.65
								\line {"216.6"}
								\vspace #-.65
								\line {"498.66Hz"}
							}
						}
					

						b4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"14"}
								\vspace #-.65
								\line {"233.3"}
								\vspace #-.65
								\line {"503.48Hz"}
							}
						}
					

						b4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"15"}
								\vspace #-.65
								\line {"250.0"}
								\vspace #-.65
								\line {"508.36Hz"}
							}
						}
					

						c4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"16"}
								\vspace #-.65
								\line {"266.6"}
								\vspace #-.65
								\line {"513.27Hz"}
							}
						}
					

						c4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"17"}
								\vspace #-.65
								\line {"283.3"}
								\vspace #-.65
								\line {"518.24Hz"}
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
								\line {"18"}
								\vspace #-.65
								\line {"300.0"}
								\vspace #-.65
								\line {"523.25Hz"}
							}
						}
					

						c4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"19"}
								\vspace #-.65
								\line {"316.6"}
								\vspace #-.65
								\line {"528.31Hz"}
							}
						}
					

						c4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"20"}
								\vspace #-.65
								\line {"333.3"}
								\vspace #-.65
								\line {"533.42Hz"}
							}
						}
					

						c4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"21"}
								\vspace #-.65
								\line {"350.0"}
								\vspace #-.65
								\line {"538.58Hz"}
							}
						}
					

						cis4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"22"}
								\vspace #-.65
								\line {"366.6"}
								\vspace #-.65
								\line {"543.79Hz"}
							}
						}
					

						cis4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"23"}
								\vspace #-.65
								\line {"383.3"}
								\vspace #-.65
								\line {"549.05Hz"}
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
								\line {"24"}
								\vspace #-.65
								\line {"400.0"}
								\vspace #-.65
								\line {"554.37Hz"}
							}
						}
					

						cis4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"25"}
								\vspace #-.65
								\line {"416.6"}
								\vspace #-.65
								\line {"559.73Hz"}
							}
						}
					

						cis4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"26"}
								\vspace #-.65
								\line {"433.3"}
								\vspace #-.65
								\line {"565.14Hz"}
							}
						}
					

						cis4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"27"}
								\vspace #-.65
								\line {"450.0"}
								\vspace #-.65
								\line {"570.61Hz"}
							}
						}
					

						d4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"28"}
								\vspace #-.65
								\line {"466.6"}
								\vspace #-.65
								\line {"576.13Hz"}
							}
						}
					

						d4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"29"}
								\vspace #-.65
								\line {"483.3"}
								\vspace #-.65
								\line {"581.70Hz"}
							}
						}
					

						d4_"+-0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"30"}
								\vspace #-.65
								\line {"500.0"}
								\vspace #-.65
								\line {"587.33Hz"}
							}
						}
					

						d4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"31"}
								\vspace #-.65
								\line {"516.6"}
								\vspace #-.65
								\line {"593.01Hz"}
							}
						}
					

						d4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"32"}
								\vspace #-.65
								\line {"533.3"}
								\vspace #-.65
								\line {"598.75Hz"}
							}
						}
					

						d4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"33"}
								\vspace #-.65
								\line {"550.0"}
								\vspace #-.65
								\line {"604.54Hz"}
							}
						}
					

						ees4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"34"}
								\vspace #-.65
								\line {"566.6"}
								\vspace #-.65
								\line {"610.39Hz"}
							}
						}
					

						ees4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"35"}
								\vspace #-.65
								\line {"583.3"}
								\vspace #-.65
								\line {"616.29Hz"}
							}
						}
					

						ees4_"+-0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"36"}
								\vspace #-.65
								\line {"600.0"}
								\vspace #-.65
								\line {"622.25Hz"}
							}
						}
					

						ees4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"37"}
								\vspace #-.65
								\line {"616.6"}
								\vspace #-.65
								\line {"628.27Hz"}
							}
						}
					

						ees4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"38"}
								\vspace #-.65
								\line {"633.3"}
								\vspace #-.65
								\line {"634.35Hz"}
							}
						}
					

						ees4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"39"}
								\vspace #-.65
								\line {"650.0"}
								\vspace #-.65
								\line {"640.49Hz"}
							}
						}
					

						e4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"40"}
								\vspace #-.65
								\line {"666.6"}
								\vspace #-.65
								\line {"646.68Hz"}
							}
						}
					

						e4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"41"}
								\vspace #-.65
								\line {"683.3"}
								\vspace #-.65
								\line {"652.94Hz"}
							}
						}
					

						e4_"+0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"42"}
								\vspace #-.65
								\line {"700.0"}
								\vspace #-.65
								\line {"659.26Hz"}
							}
						}
					

						e4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"43"}
								\vspace #-.65
								\line {"716.6"}
								\vspace #-.65
								\line {"665.63Hz"}
							}
						}
					

						e4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"44"}
								\vspace #-.65
								\line {"733.3"}
								\vspace #-.65
								\line {"672.07Hz"}
							}
						}
					

						e4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"45"}
								\vspace #-.65
								\line {"750.0"}
								\vspace #-.65
								\line {"678.57Hz"}
							}
						}
					

						f4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"46"}
								\vspace #-.65
								\line {"766.6"}
								\vspace #-.65
								\line {"685.14Hz"}
							}
						}
					

						f4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"47"}
								\vspace #-.65
								\line {"783.3"}
								\vspace #-.65
								\line {"691.76Hz"}
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
								\line {"48"}
								\vspace #-.65
								\line {"800.0"}
								\vspace #-.65
								\line {"698.46Hz"}
							}
						}
					

						f4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"49"}
								\vspace #-.65
								\line {"816.6"}
								\vspace #-.65
								\line {"705.21Hz"}
							}
						}
					

						f4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"50"}
								\vspace #-.65
								\line {"833.3"}
								\vspace #-.65
								\line {"712.03Hz"}
							}
						}
					

						f4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"51"}
								\vspace #-.65
								\line {"850.0"}
								\vspace #-.65
								\line {"718.92Hz"}
							}
						}
					

						fis4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"52"}
								\vspace #-.65
								\line {"866.6"}
								\vspace #-.65
								\line {"725.88Hz"}
							}
						}
					

						fis4_"-16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"53"}
								\vspace #-.65
								\line {"883.3"}
								\vspace #-.65
								\line {"732.90Hz"}
							}
						}
					

						fis4_"+-0.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"54"}
								\vspace #-.65
								\line {"900.0"}
								\vspace #-.65
								\line {"739.99Hz"}
							}
						}
					

						fis4_"+16.67c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"55"}
								\vspace #-.65
								\line {"916.6"}
								\vspace #-.65
								\line {"747.15Hz"}
							}
						}
					

						fis4_"+33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"56"}
								\vspace #-.65
								\line {"933.3"}
								\vspace #-.65
								\line {"754.37Hz"}
							}
						}
					

						fis4_"+50.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"57"}
								\vspace #-.65
								\line {"950.0"}
								\vspace #-.65
								\line {"761.67Hz"}
							}
						}
					

						g4_"-33.33c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"58"}
								\vspace #-.65
								\line {"966.6"}
								\vspace #-.65
								\line {"769.04Hz"}
							}
						}
					

		}
	}
}

