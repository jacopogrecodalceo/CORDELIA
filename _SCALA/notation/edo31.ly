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
	title = \markup {\override #'(font-name . "Longinus") "EDO31"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 31/4

			
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
					

						a4_"+38.71c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"38.70"}
								\vspace #-.65
								\line {"449.95Hz"}
							}
						}
					

						bes4_"-22.58c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"77.41"}
								\vspace #-.65
								\line {"460.12Hz"}
							}
						}
					

						bes4_"+16.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"116.1"}
								\vspace #-.65
								\line {"470.53Hz"}
							}
						}
					

						b4_"-45.16c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"154.8"}
								\vspace #-.65
								\line {"481.17Hz"}
							}
						}
					

						b4_"-6.45c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"193.5"}
								\vspace #-.65
								\line {"492.05Hz"}
							}
						}
					

						b4_"+32.26c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"232.2"}
								\vspace #-.65
								\line {"503.17Hz"}
							}
						}
					

						c4_"-29.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"270.9"}
								\vspace #-.65
								\line {"514.55Hz"}
							}
						}
					

						c4_"+9.68c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"309.6"}
								\vspace #-.65
								\line {"526.18Hz"}
							}
						}
					

						c4_"+48.39c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"348.3"}
								\vspace #-.65
								\line {"538.08Hz"}
							}
						}
					

						cis4_"-12.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"387.0"}
								\vspace #-.65
								\line {"550.25Hz"}
							}
						}
					

						cis4_"+25.81c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"425.8"}
								\vspace #-.65
								\line {"562.69Hz"}
							}
						}
					

						d4_"-35.49c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"12"}
								\vspace #-.65
								\line {"464.5"}
								\vspace #-.65
								\line {"575.41Hz"}
							}
						}
					

						d4_"+3.22c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"13"}
								\vspace #-.65
								\line {"503.2"}
								\vspace #-.65
								\line {"588.42Hz"}
							}
						}
					

						d4_"+41.93c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"14"}
								\vspace #-.65
								\line {"541.9"}
								\vspace #-.65
								\line {"601.73Hz"}
							}
						}
					

						ees4_"-19.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"15"}
								\vspace #-.65
								\line {"580.6"}
								\vspace #-.65
								\line {"615.34Hz"}
							}
						}
					

						ees4_"+19.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"16"}
								\vspace #-.65
								\line {"619.3"}
								\vspace #-.65
								\line {"629.25Hz"}
							}
						}
					

						e4_"-41.94c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"17"}
								\vspace #-.65
								\line {"658.0"}
								\vspace #-.65
								\line {"643.48Hz"}
							}
						}
					

						e4_"-3.23c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"18"}
								\vspace #-.65
								\line {"696.7"}
								\vspace #-.65
								\line {"658.03Hz"}
							}
						}
					

						e4_"+35.48c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"19"}
								\vspace #-.65
								\line {"735.4"}
								\vspace #-.65
								\line {"672.91Hz"}
							}
						}
					

						f4_"-25.81c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"20"}
								\vspace #-.65
								\line {"774.1"}
								\vspace #-.65
								\line {"688.12Hz"}
							}
						}
					

						f4_"+12.9c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"21"}
								\vspace #-.65
								\line {"812.9"}
								\vspace #-.65
								\line {"703.68Hz"}
							}
						}
					

						fis4_"-48.39c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"22"}
								\vspace #-.65
								\line {"851.6"}
								\vspace #-.65
								\line {"719.59Hz"}
							}
						}
					

						fis4_"-9.68c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"23"}
								\vspace #-.65
								\line {"890.3"}
								\vspace #-.65
								\line {"735.86Hz"}
							}
						}
					

						fis4_"+29.03c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"24"}
								\vspace #-.65
								\line {"929.0"}
								\vspace #-.65
								\line {"752.50Hz"}
							}
						}
					

						g4_"-32.26c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"25"}
								\vspace #-.65
								\line {"967.7"}
								\vspace #-.65
								\line {"769.52Hz"}
							}
						}
					

						g4_"+6.45c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"26"}
								\vspace #-.65
								\line {"1006."}
								\vspace #-.65
								\line {"786.92Hz"}
							}
						}
					

						g4_"+45.16c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"27"}
								\vspace #-.65
								\line {"1045."}
								\vspace #-.65
								\line {"804.71Hz"}
							}
						}
					

						aes4_"-16.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"28"}
								\vspace #-.65
								\line {"1083."}
								\vspace #-.65
								\line {"822.91Hz"}
							}
						}
					

						aes4_"+22.58c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"29"}
								\vspace #-.65
								\line {"1122."}
								\vspace #-.65
								\line {"841.51Hz"}
							}
						}
					

						a4_"-38.71c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"30"}
								\vspace #-.65
								\line {"1161."}
								\vspace #-.65
								\line {"860.54Hz"}
							}
						}
					

		}
	}
}

