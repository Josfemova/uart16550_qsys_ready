`include "uart_defines.v"

// Avalon wrapper for the uart16550 core
module uart_top_avalon(
  input clk, 
  input reset,
  input write,
  input read,
  input [4:0] address,
  input [31:0] writedata,
  input [3:0] byteenable, 
  input chipselect,
  output waitrequest,
  output [31:0] readdata,
  
  // conduit
  input srx_pad_i, 
  output stx_pad_o,
  output rts_pad_o,
  input cts_pad_i,
  output dtr_pad_o,
  input dsr_pad_i,
  input ri_pad_i,
  input dcd_pad_i,
`ifdef UART_HAS_BAUDRATE_OUTPUT
  output baud_o,
`endif

  // interrupt 
  output irq
);

// Wishbone signals 
wire cyc, stb, we, ack;

assign cyc = write | read; 
assign stb = chipselect;
assign we = write && ~read;
assign waitrequest = ~ack;

uart_top uart(
    .wb_clk_i(clk),
    .wb_rst_i(reset),
    .wb_adr_i(address),
    .wb_dat_i(writedata),
    .wb_dat_o(readdata),
    .wb_we_i(we), 
    .wb_stb_i(stb),
    .wb_cyc_i(cyc),
    .wb_ack_o(ack),
    .wb_sel_i(byteenable),
    // irq
    .int_o(irq),
    .stx_pad_o(stx_pad_o), 
    .srx_pad_i(srx_pad_i),
    .rts_pad_o(rts_pad_o), 
    .cts_pad_i(cts_pad_i), 
    .dtr_pad_o(dtr_pad_o), 
    .dsr_pad_i(dsr_pad_i), 
    .ri_pad_i(ri_pad_i), 
    .dcd_pad_i(dcd_pad_i)
`ifdef UART_HAS_BAUDRATE_OUTPUT
	  ,
    .baud_o(baud_o)
`endif
);


endmodule
