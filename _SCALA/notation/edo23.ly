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
	title = \markup {\override #'(font-name . "Longinus") "EDO23"}
	tagline = \date
}

\score {
	\new Staff \relative a' {
		\accidentalStyle forget
		 {
			\textLengthOn
			\time 23/4

			
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
					

						bes4_"-47.83c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"52.17"}
								\vspace #-.65
								\line {"453.46Hz"}
							}
						}
					

						bes4_"+4.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"104.3"}
								\vspace #-.65
								\line {"467.34Hz"}
							}
						}
					

						b4_"-43.48c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"156.5"}
								\vspace #-.65
								\line {"481.63Hz"}
							}
						}
					

						b4_"+8.7c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"208.6"}
								\vspace #-.65
								\line {"496.37Hz"}
							}
						}
					

						c4_"-39.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"260.8"}
								\vspace #-.65
								\line {"511.56Hz"}
							}
						}
					

						c4_"+13.04c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"313.0"}
								\vspace #-.65
								\line {"527.21Hz"}
							}
						}
					

						cis4_"-34.78c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"365.2"}
								\vspace #-.65
								\line {"543.34Hz"}
							}
						}
					

						cis4_"+17.39c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"417.3"}
								\vspace #-.65
								\line {"559.96Hz"}
							}
						}
					

						d4_"-30.44c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"469.5"}
								\vspace #-.65
								\line {"577.09Hz"}
							}
						}
					

						d4_"+21.74c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"521.7"}
								\vspace #-.65
								\line {"594.75Hz"}
							}
						}
					

						ees4_"-26.09c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"573.9"}
								\vspace #-.65
								\line {"612.95Hz"}
							}
						}
					

						ees4_"+26.09c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"12"}
								\vspace #-.65
								\line {"626.0"}
								\vspace #-.65
								\line {"631.70Hz"}
							}
						}
					

						e4_"-21.74c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"13"}
								\vspace #-.65
								\line {"678.2"}
								\vspace #-.65
								\line {"651.03Hz"}
							}
						}
					

						e4_"+30.44c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"14"}
								\vspace #-.65
								\line {"730.4"}
								\vspace #-.65
								\line {"670.95Hz"}
							}
						}
					

						f4_"-17.39c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"15"}
								\vspace #-.65
								\line {"782.6"}
								\vspace #-.65
								\line {"691.48Hz"}
							}
						}
					

						f4_"+34.78c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"16"}
								\vspace #-.65
								\line {"834.7"}
								\vspace #-.65
								\line {"712.63Hz"}
							}
						}
					

						fis4_"-13.04c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"17"}
								\vspace #-.65
								\line {"886.9"}
								\vspace #-.65
								\line {"734.43Hz"}
							}
						}
					

						fis4_"+39.13c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"18"}
								\vspace #-.65
								\line {"939.1"}
								\vspace #-.65
								\line {"756.90Hz"}
							}
						}
					

						g4_"-8.7c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"19"}
								\vspace #-.65
								\line {"991.3"}
								\vspace #-.65
								\line {"780.06Hz"}
							}
						}
					

						g4_"+43.48c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"20"}
								\vspace #-.65
								\line {"1043."}
								\vspace #-.65
								\line {"803.93Hz"}
							}
						}
					

						aes4_"-4.35c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"21"}
								\vspace #-.65
								\line {"1095."}
								\vspace #-.65
								\line {"828.53Hz"}
							}
						}
					

						aes4_"+47.83c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"22"}
								\vspace #-.65
								\line {"1147."}
								\vspace #-.65
								\line {"853.88Hz"}
							}
						}
					

		}
	}
}

