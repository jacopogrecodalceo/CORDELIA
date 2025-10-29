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
	title = \markup {\override #'(font-name . "Longinus") "PYT7A"}
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
					

						bes4_"+4.95c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"17th harmonic"
										}		
									}
								\vspace #.15
								\line {"01"}
								\vspace #-.65
								\line {"17/16"}
								\vspace #-.65
								\line {"467.50Hz"}
							}
						}
					

						b4_"+3.91c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"major whole tone"
										}		
									}
								\vspace #.15
								\line {"02"}
								\vspace #-.65
								\line {"9/8"}
								\vspace #-.65
								\line {"495.00Hz"}
							}
						}
					

						c4_"+8.87c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"03"}
								\vspace #-.65
								\line {"153/1"}
								\vspace #-.65
								\line {"525.94Hz"}
							}
						}
					

						cis4_"+7.82c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"Pythagorean major third"
										}		
									}
								\vspace #.15
								\line {"04"}
								\vspace #-.65
								\line {"81/64"}
								\vspace #-.65
								\line {"556.88Hz"}
							}
						}
					

						d4_"-1.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fourth"
										}		
									}
								\vspace #.15
								\line {"05"}
								\vspace #-.65
								\line {"4/3"}
								\vspace #-.65
								\line {"586.67Hz"}
							}
						}
					

						ees4_"+3.0c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"2nd septendecimal tritone"
										}		
									}
								\vspace #.15
								\line {"06"}
								\vspace #-.65
								\line {"17/12"}
								\vspace #-.65
								\line {"623.33Hz"}
							}
						}
					

						e4_"+1.96c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"perfect fifth"
										}		
									}
								\vspace #.15
								\line {"07"}
								\vspace #-.65
								\line {"3/2"}
								\vspace #-.65
								\line {"660.00Hz"}
							}
						}
					

						f4_"+6.91c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"08"}
								\vspace #-.65
								\line {"51/32"}
								\vspace #-.65
								\line {"701.25Hz"}
							}
						}
					

						fis4_"+5.86c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											"Pythagorean major sixth"
										}		
									}
								\vspace #.15
								\line {"09"}
								\vspace #-.65
								\line {"27/16"}
								\vspace #-.65
								\line {"742.50Hz"}
							}
						}
					

						g4_"+10.82c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"10"}
								\vspace #-.65
								\line {"459/2"}
								\vspace #-.65
								\line {"788.91Hz"}
							}
						}
					

						aes4_"+9.78c"^\markup {
							\column {
								\line \left-align \box {
									\fontsize #-3 \rotate #90 {
											""
										}		
									}
								\vspace #.15
								\line {"11"}
								\vspace #-.65
								\line {"243/1"}
								\vspace #-.65
								\line {"835.31Hz"}
							}
						}
					

		}
	}
}

