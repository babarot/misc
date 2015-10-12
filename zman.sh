#!/bin/bash

zman() { PAGER="less -g -s '+/^ {7}"$1"'" man zshall; }
