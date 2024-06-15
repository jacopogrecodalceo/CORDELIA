from  dataclasses import dataclass, field

@dataclass
class Instrument:
	
	opcode: list = field(default_factory=list)

	space: str = None
	name: list = field(default_factory=list)
	dur: str = None
	dyn: str = None
	env: str = None
	freq: list = field(default_factory=list)
	route: list = field(default_factory=list)

	add_in: list = field(default_factory=list)
	add_out: list = field(default_factory=list)

	route: list = field(default_factory=list)

	kill: bool = False


