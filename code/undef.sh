#!/bin/bash

#is_defined() { [[ "${1-undefined}" == 'undefined' && "${1}" == "" ]]; }
is_defined() { [[ -n "$1" && "`eval echo \$\{$1\}`" ]]; }
#is_defined() { [[ "`eval echo \$\{${1-undefined}\}`" == 'undefined' ]]; }
#is_defined() { eval echo "\$\{${1-undefined}\} == 'undefined'"; }
#is_defined() { test -n $(eval echo "\$$1"); }
#is_defined() { eval "\$$1"; }

is_defined "$@" && echo def || echo undef

