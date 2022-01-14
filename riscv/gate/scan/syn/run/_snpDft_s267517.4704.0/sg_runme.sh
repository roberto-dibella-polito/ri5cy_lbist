#!/usr/bin/env sh
#export SPYGLASS_HOME=/eda/synopsys/2020-21/RHELx86/SPYGLASS_2020.12/SPYGLASS_HOME
#Launch Spyglass GUI
$SPYGLASS_HOME/bin/spyglass -project sg_config.prj -goal sg_dft_testpoint_analysis 
#Launch Spyglass Batch Run
#$SPYGLASS_HOME/bin/spyglass -project sg_config.prj -goal sg_dft_testpoint_analysis -batch
