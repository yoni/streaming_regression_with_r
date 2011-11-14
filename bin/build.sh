#!/bin/sh
bin/roxygenize.sh
R CMD build .
R CMD check StreamingLm_0.1.tar.gz
