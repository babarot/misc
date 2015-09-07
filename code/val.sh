#!/bin/bash

define(){ eval ${1:?}='"${*:2}"'; }

a="false"
define a "true"

VAL="false"
declare VAL=${VAL:-true}
echo $VAL
