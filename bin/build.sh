#!/bin/sh
bin/roxygenize.sh
R CMD build .
R CMD check StreamingLm_0.2.tar.gz
