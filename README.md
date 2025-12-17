# ＣＯＲＤＥＬＩＡ 
_a method, a tender affection_
jacopo greco d'alceo

**Introduction**

Throughout my studies as a composer, I have become increasingly engaged with the relationship between electroacoustic composition and dance, particularly with choreography as a form of composition. This focus led me to explore alternative approaches for generating and structuring electroacoustic sound. Live coding attracted my interest. Because of its flexibility, responsiveness, and capacity for real-time transformation, it allows to fill the gap between composition and performance. Yet I found existing live coding languages insufficient for the artistic precision I sought. This dissatisfaction prompted me to develop my own environment, which rapidly became both personally resonant and artistically effective. *Cordelia* now functions as an instrument and an environment for composing, organising, and listening to sound as an active, continuous process.

**What is Cordelia**

*Cordelia* is an original, open-source compositional environment that integrates three interconnected domains: written composition, live performance, and musical representation. It enables the creation of rendered music through a horizontal timeline workflow inside a DAW such as Reaper, it supports real-time performance through live coding and finally it interfaces with notation systems such as LilyPond for high-quality score generation.

This triad, i.e. composition, performance, and representation, forms the core of *Cordelia*’s design and distinguishes it from conventional live coding tools.

**How’s built**

*Cordelia* is built in Python and grounded in the Csound audio engine. Csound remains one of the most powerful free and open-source languages for sound synthesis and musical composition, and its architecture allows extremely robust and precise control for musical creation. 

Csound’s architecture separates “orchestra” and “score” (instruments from instructions), a structure well suited to written composition, but less rapid and adaptable to the immediacy required in live coding. In *Cordelia*, this boundary is intentionally softened to enable active musical response and real-time decision-making. Paradoxically, it is precisely Csound’s structural clarity that makes it so valuable for *Cordelia*: live coding becomes possible without sacrificing the compositional depth and formal articulation normally associated with offline electroacoustic writing. This dual capacity, **real-time performance** and **rigorous compositional control**, is central to this project.

**What is live coding**

Live coding is a practice where writing code in real-time becomes the gesture of musical composition. Compared with other Python-based live coding environments such as Sardine, FoxDot, or Renardo, or languages like TidalCycles, *Cordelia* tries not to be conceived as just a domain-specific language. Instead, it functions as an integrated **compositional ecosystem**. Organisation, structure, and musical form are fundamental; representation, composition, and performance are designed as interconnected layers. Rather than a tool limited to triggering patterns, it aims to operate as a multi-functional system capable of bridging different media and modes of musical thought.

**Musical composition**

Each feature of *Cordelia* is meticulously crafted to achieve concrete artistic outcomes. The integration of new ideas directly into the code opens unusual avenues for creative exploration. Live coding, in particular, proves compelling for compositional thinking: its inherent nature as a programming language supports continuous structural development, enabling **unexpected directions and rich variations in compositional technique**. This flexibility allows both the creation of project-specific instruments and the organic growth of the environment across different works. 

An illustrative example is my piece «chiedimi le mie radici» («just ask me my roots», trad.), in which quadraphony organisation directly informed both the design of a wooden instrument played by a dancer and the piece’s dramaturgy. Space itself functions as a character: each speaker operates as an independent entity. Within *Cordelia*, this approach translates into creating separate instrument instances for each speaker, treating each sound source of a given event as a discrete voice.

This symbiotic relationship between the parallel construction of the instruments and the artistic requirements of the piece is possible only through a **holistic approach to compositional organisation and artistic research**.

**Choreographic composition**

In approaching composition, the integration of choreography is my answer and suggestion to move beyond, both aesthetically and ethically, the conceptual frameworks that Bernard Stiegler identifies as “western sicknesses”: hylomorphism (the rigid opposition between form and matter) and substantialism (the notion that the individual is a pre-existing substance rather than a process). Simon Emmerson notes that in electroacoustic music the body both disappears and reappears in non-physical forms. The performer is no longer the primary site of expression; instead, the body is displaced into gesture-less interfaces, loudspeakers, spatial projection, fixed media. The point is clear: electroacoustic practice risks eroding the embodied dimension of performance, which is precisely why he defends music as a medium that demands full attention. Listening becomes the new site of presence.

This tension is central to my work. Rather than accepting the disappearance of the body, I interrogate it. *Cordelia* operates in this gap: the system doesn’t remove the body but reframes it, letting it re-emerge through coded gesture, live manipulation, and choreographic and mouvement intentionality. I assert movement inseparable from sound, functioning as an instrumental gesture — even when it is not directly the cause of the sonic vibration. The goal is not to restore a performer-body, but to expose how embodiment of musical composition drives and change intrinsically the outcome. The relationship can manifest through procedural action, timing, and coded decision-making. In this sense, the “return” of the body is not physical but structural: expressed through rhythm, latency, response, symbolic movement, and the decision-space carved by the choices of algorithms and the language itself.

Thus, when I speak of choreography, I do not treat it as separate from musical composition. Following the practices of Jeppe Ernst — a Swedish composer whose work strongly resonate with my own approach, some ideas of the musical theatre of Aperghis, Kagel, Schnebel, certain aspects of Stockhausen (Inori, Harlequin) and Thierry De Mey, I reject a strict distinction between sound and gesture.

Choreography, in this framework, is no longer merely the movement of the performer, the rhythm, or the form of a composition, and it is not “music for dance”. Conceptually, choreography operates on the same level as sound: within the compositional process and inseparable in the act of creation.

Composition in this approach exists as a “permanent process of individuation” as in Gilbert Simondon’s concept. This means **disciplinary boundaries are fluid and permeable**. Rather than conceptualising artistic creation through unity or duality, **I embrace the complexity, constant evolution, and adaptive nature of the creative process**. This paradigm challenges conventional notions, inviting exploration of new territories where interdisciplinary and collaborative practices thrive.

In a period of transition for contemporary music and art, characterised by both a democratisation of skills and an increasing abstraction, this approach proposes a personal vision grounded in open-source philosophy, ecology and critically engaged artistic research, where the composer is also a maker, a craftsman.

**Conclusions**

I agree with Thor Magnusson when he says designing the instrument itself constitutes a fundamental artistic act that actively shapes creativity. Every decision in this direction carries significant aesthetic consequences, directly influencing both the sonic outcomes and the structural organisation of a composition. This encourages the exploration of new ideas rather than imposing constraints where habitual practice, conformity, or technological mastery overshadow the essence of creation.

By fusing technique and creativity and focusing on shaping their relations, *Cordelia* opens avenues for innovation and expands the conceptual boundaries of what music can be. It is precisely in this context that live coding emerges as a particularly compelling practice. By pushing the logical precision of programming languages toward poetic outcomes (creative coding), *Cordelia* enables a deeply personal aesthetic research that simultaneously motivates and enacts artistic transformation.

Shifting the common paradigm of separation between composition and technique, it encourages artists and composers to engage directly with underlying technical procedures, promoting transparency, collaboration, and hybrid, interdisciplinary methodologies. It contribute a deeper understanding of the relationship between technology and artistic process.

Ultimately, *Cordelia* becomes a way of thinking and imagining composition and by extension, music and dance. This reflection transcends technique to define the very structure of my artistic practice: the more diversified this structure becomes, the broader and richer the artistic landscape it enables.