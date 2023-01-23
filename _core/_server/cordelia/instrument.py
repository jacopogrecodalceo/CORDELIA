from  dataclasses import dataclass, field

@dataclass
class Instrument:
	
	function: list

	name: list = field(default_factory=list)
	dur: str = None
	dyn: str = None
	env: str = None
	freq: list = None
	route: list = None
	space: str = None

	add_in: list = field(default_factory=list)
	add_out: list = field(default_factory=list)

	route: list = field(default_factory=list)
