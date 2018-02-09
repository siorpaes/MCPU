// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Fri Feb  9 11:07:09 2018
// Host        : AGRCWD3314 running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub {C:/Users/david
//               siorpaes/Desktop/MCPU/projects/Basys3/mcpu.srcs/sources_1/ip/mcpu_ram/mcpu_ram_stub.v}
// Design      : mcpu_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2017.4" *)
module mcpu_ram(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[5:0],d[7:0],clk,we,spo[7:0]" */;
  input [5:0]a;
  input [7:0]d;
  input clk;
  input we;
  output [7:0]spo;
endmodule
