#!/bin/bash

cp ../vivado/ultra96.runs/impl_1/ultra96_wrapper.bit ./hardware.bit
cp ../vivado/ultra96.sdk/fsbl/Debug/fsbl.elf .
cp ../vivado/ultra96.sdk/pmufw/Debug/pmufw.elf .

bootgen -arch zynqmp -image build_boot.bif -o i boot.bin -w on
