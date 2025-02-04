/*
 * Copyright (c) 2025 Pat Deegan
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Direct inputs
  wire loopback = ui_in[0];
  reg [15:0] counter;
  reg [7:0] outport;
  reg [7:0] biport;
  reg [7:0] bidir;
  
  assign uo_out = outport;
  assign uio_out = biport;
  assign uio_oe = bidir;
  always @(posedge clk) begin
    if (~rst_n) begin
      counter <= 0;
      outport <= 0;
      biport <= 0;
    end else begin
      counter <= counter + 1;
      if (loopback) begin
        outport <= uio_in;
        biport <= 0;
        bidir <= 0;
      end else begin
        outport <= counter[7:0];
        biport <= counter[15:8];
        bidir <= 8'hff;
      end
    end
  end
endmodule
