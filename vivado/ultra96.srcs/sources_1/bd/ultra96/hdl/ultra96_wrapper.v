//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
//Date        : Fri Dec 14 23:36:41 2018
//Host        : neptune running 64-bit Ubuntu 18.04.1 LTS
//Command     : generate_target ultra96_wrapper.bd
//Design      : ultra96_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ultra96_wrapper
   (BT_ctsn,
    BT_rtsn);
  input BT_ctsn;
  output BT_rtsn;

  wire BT_ctsn;
  wire BT_rtsn;

  ultra96 ultra96_i
       (.BT_ctsn(BT_ctsn),
        .BT_rtsn(BT_rtsn));
endmodule
