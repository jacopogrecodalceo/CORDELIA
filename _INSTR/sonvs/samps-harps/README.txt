# Harpsimachord - Version: 1.0

Date: 2022-10-13
Name: Douglas Knisely
Profile: https://www.pianobook.co.uk/profile/dknisely

## Included formats

- Decent Sampler

## Release notes

Initial release.

### New

### Bugfixes

## Using the instrument

Harpsimachord is a Decent Sampler deep sampling of my 1970s Douglas Van Dyck Brown harpsichord.  The
instrument is a two manual/three rank (8/8/4) design with cabinetry closely styled to resemble a
1750 Kirckman English harpsichord.  The sound resembles existing Kirckmans (easily found on
recordings), but the mechanics are custom and modern.  The long string length of the instrument
produces a warm resonant tone with long reverberation.

The samples were captured with two close ribbon mics in a roughly Blumlein pattern to hopefully
provide some image of the bass vs. treble strings, along with a pair of cardioid mics in an ORTF
configuration about one foot away from the open lid.  They were mixed about 60/40 in favor of
the richer ribbons.

I captured every note from the F1-F6 61-note range for seven manual/registration combinations:
- Lower Manual
- Upper Manual (slightly more nasal quality)
- Upper Manual with the regular and Nasat plectras for a strong nasal quality
- Upper Manual with the Nasat plectra only for a softer nasal quality
- Lower Manual + 4' Stop
- Lower Manual coupled to the Upper Manual + 4' Stop (full instrument)
- Lower Manual with Buff stop (leather mutes applied to each string for a lute-like sound)

My goal was to capture all the quirks and mechanical noises that are different for every key
press and delightful release, and for every manual/registration combination due to the hand-built
design.  The samples were processed with a moderate EQ to high-pass the bass boominess and
balance the mid-frequencies with the upper, and a small amount of reverb.  Even though the
samples seemed relatively noise-free individually, the noise accumulates, so I ran them through
a basic NR plugin that was the most challenging part of the task (aside from preparing all
the note and release samples).

Note:

The instrument is tuned to A=415 (1/2 note below A=440), with notes ranging from F1-F6, corresponding
E1-E6 in modern tuning.  For convenience and to avoid confusion of users, I have designed the sample
pack to align with A=440, with notes from E1-F6, the top note extended upward to F6.  The sample
files are named with the MIDI note numbers in A440 tuning for convenience in DS dspreset creation.

Structure:
- Photos contains the DS background image.
- SamplesNR contains the noise-reduced samples (in MIDI note numbers).
- Harpsimachord.dspreset is the DS XML file.
- README.txt is this file.

