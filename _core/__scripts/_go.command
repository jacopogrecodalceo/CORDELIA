#!/bin/bash

cd "$(dirname "$0")" ;
ruby instruments_gen.rb ;
ruby samples_gen.rb ;
ruby opcode_gen.rb ;
ruby space_gen_all.rb ;
ruby append_all.rb ;
ruby ./__others/list_instr.rb ;
ruby tab_gen.rb ;

exit