#!/bin/bash

cp ../ultra96_2018.3/ultra96.runs/impl_1/ultra96_wrapper.bit ./hardware.bit
cp ../ultra96_2018.3/ultra96.sdk/fsbl/Debug/fsbl.elf .
cp ../ultra96_2018.3/ultra96.sdk/pmufw/Debug/pmufw.elf .
#cp ../ultra96_2018.3/ultra96.sdk/dp_sample/Debug/dp_sample.elf .

bootgen -arch zynqmp -image build_boot.bif -o i boot.bin -w on
