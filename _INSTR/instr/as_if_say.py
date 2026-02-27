'''
as_i_say structure, but with a diode_filter

'''

from pathlib import Path
from rapidfuzz import process

MAIN_PATH_DIR = Path('/Users/j/Documents/PROJECTs/CORDELIA/_INSTR/sonvs/samp-as_i_say')

# ---------------------------------------------------------------------------- #
#                                   TEMPLATE                                   #
# ---------------------------------------------------------------------------- #

INSTR_TEMPLATE = '''\

gS{name}_path init "{path}"
gS{name}_prefix init "{prefix}"
gi{name}_n init {count}

   $start_instr({name})

inum      init 1 + floor(icps % gi{name}_n)
Snum      sprintf "%d", inum
while strlen(Snum) < 4 do
   Snum strcat "0", Snum
od

Spath     sprintf "%s/%s-%s.wav", gS{name}_path, gS{name}_prefix, Snum
ilen      filelen Spath

if p3 > ilen then
   p3     init ilen
endif
idur      init p3

aenv      linseg 0, .005, 1, idur-.005-.05, 1, .05, 0
aout      diskin Spath, 1+random(-.05, .05)
aout      *= idyn
aout      *= aenv
aout      diode_ladder aout, limit(icps+(17500-icps)*idyn, 20, 17500), 10+jitter(5, 1, 1/8)
aout      *= 12
   $channel_mix
   endin

'''

# ---------------------------------------------------------------------------- #
#                                    HELPERs                                   #
# ---------------------------------------------------------------------------- #

def build_instr(instr_name: str, path: Path, count: int) -> str:
   return INSTR_TEMPLATE.format(name=instr_name, prefix=path.stem, path=path, count=count)


def get_subdirs(base: Path) -> list[Path]:
   return [d for d in base.iterdir() if d.is_dir()]


def count_wavs(directory: Path) -> int:
   return sum(1 for _ in directory.glob('*.wav'))


def resolve_subdir_by_index(base: Path, index: int) -> Path | None:
   dirs = get_subdirs(base)
   return dirs[index % len(dirs)] if dirs else None


def resolve_subdir_by_name(base: Path, name: str) -> Path | None:
   candidate = base / name
   if candidate.is_dir():
      return candidate

   dir_names = [d.name for d in get_subdirs(base)]
   if not dir_names:
      return None

   best_match, *_ = process.extractOne(name, dir_names)
   matched = base / best_match
   return matched if matched.is_dir() else None

# ---------------------------------------------------------------------------- #
#                                  MAIN ENTRY                                  #
# ---------------------------------------------------------------------------- #

def cordelia_main(instrument_string: str) -> str | None:
   digits = ''.join(ch for ch in instrument_string if ch.isdigit())

   if digits:
      subdir = resolve_subdir_by_index(MAIN_PATH_DIR, int(digits))
      instr_name = instrument_string
   else:
      last_dash = instrument_string.rfind('-')
      if last_dash == -1:
         return None
      subdir_name = instrument_string[last_dash + 1:]
      subdir = resolve_subdir_by_name(MAIN_PATH_DIR, subdir_name)
      instr_name = instrument_string.replace('-', '_')

   if subdir is None:
      return None

   return build_instr(instr_name, subdir, count_wavs(subdir))