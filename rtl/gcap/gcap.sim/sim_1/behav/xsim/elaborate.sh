#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2_AR72614 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sun Mar 01 21:06:43 PST 2020
# SW Build 2708876 on Wed Nov  6 21:39:14 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto a5e25f0dfa0747ffa1d4c2d5b0b7bddf --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_dram_behav xil_defaultlib.tb_dram xil_defaultlib.glbl -log elaborate.log"
xelab -wto a5e25f0dfa0747ffa1d4c2d5b0b7bddf --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_dram_behav xil_defaultlib.tb_dram xil_defaultlib.glbl -log elaborate.log

