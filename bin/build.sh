#!/bin/sh
bin/roxygenize.sh
R CMD build .
R CMD check StreamingLm_1.0.tar.gz
