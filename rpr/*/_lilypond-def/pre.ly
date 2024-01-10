\version "2.24.0"

\header {
  tagline = "jacopo greco d'alceo, 2023"
}

\paper {
	#(set-paper-size "a4landscape")
	%left-margin = 15
	%bottom-margin = 10
	%top-margin = 10
	print-page-number = ##t
	%system-count = 2
	%page-breaking = #ly:one-line-auto-height-breaking
	system-separator-markup = \slashSeparator
	system-system-spacing =
    #'((basic-distance . 25) 
       (minimum-distance . 25)
       (padding . 1)
       (stretchability . 15)) 
}

\layout {
	\context {
		\Score
		proportionalNotationDuration = #(ly:make-moment 1/64)
		\override SpacingSpanner.uniform-stretching = ##t
		\override DurationLine.bound-details.right.end-style = #'hook
		\override DurationLine.thickness = 2.5
		\override TextScript.font-size = #-9
	}
	\context {
		\Voice
		\consists Duration_line_engraver
		\remove Stem_engraver
		\remove Dots_engraver
		\override NoteHead.duration-log = 2
	}
}

at =
#(define-music-function (instrument point pitch len cent time) (string? exact-rational? ly:pitch? exact-rational? string? string?)
	#{ \context Staff = #instrument \new Voice \after 4*#point { $pitch 4*#len \- _#cent ^#time } <> #})
