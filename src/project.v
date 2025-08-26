/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none
module tt_um_TT16 #(
    parameter DATA_WIDTH = 4,
    parameter ADDR_WIDTH = 4
)(
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, can be ignored
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - active low reset
);

  // Write enable and read enable signals from input bits
  wire winc = ui_in[4];
  wire rinc = ui_in[5];
  
  // Data to write into FIFO (lower 4 bits of ui_in)
  wire [3:0] wdata = ui_in[3:0];
  
  // Read data output from FIFO
  wire [3:0] rdata;
  
  // FIFO status flags
  wire full, empty;

  // Assign FIFO output data and status to uo_out bits
  assign uo_out[3:0] = rdata;
  assign uo_out[4]   = full;
  assign uo_out[5]   = empty;
  assign uo_out[6]   = 0;      // Unused output bits set to 0
  assign uo_out[7]   = 0;

  // Unused IO outputs driven to zero
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Prevent unused signal warnings for inputs not connected in this module
  wire _unused = &{ena, ui_in[6], ui_in[7], uio_in};

  // FIFO instance (assumes synchronous FIFO with single clock)
  fifo #(DATA_WIDTH, ADDR_WIDTH) fifo_inst (
      .winc(winc),
      .rinc(rinc),
      .wclk(clk),
      .rclk(clk),
      .clk(clk),
      .rst_n(rst_n),
      .wdata(wdata),
      .rdata(rdata),
      .full(full),
      .empty(empty)
  );

endmodule
