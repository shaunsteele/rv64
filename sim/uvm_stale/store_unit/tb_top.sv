// top.sv

`default_nettype none

`include "uvm_macros.svh"

module tb_top;

import uvm_pkg::*;


// parameter configuration
localparam int XLen = 64;
localparam int ALen = 64;
localparam int DLen = 64;


// clock
localparam int TClk = 10;
bit clk;


// reset
localparam int ResetLen = 10;
bit rstn;


// interfaces
load_store_if #(.XLEN(XLen)) ls (.clk(clk), .rstn(rstn));
axi_lite_if #(.ALEN(Alen), .DLEN(DLen)) axi (.aclk(clk), .aresetn(rstn));


// DUT
store_unit # (
  .XLEN (XLen),
  .ALEN (ALen),
  .DLEN (DLen),
  .SLEN (SLen)
) u_DUT (
  .clk          (clk),
  .rstn         (rstn),
  .i_wvalid     (ls.wvalid),
  .o_wready     (ls.wready),
  .i_base_addr  (ls.base_addr),
  .i_offset     (ls.offset),
  .i_width      (ls.width),
  .i_wdata      (ls.wdata),
  .o_dm_awvalid (axi.awvalid),
  .i_dm_awready (axi.awready),
  .o_dm_awaddr  (axi.awaddr),
  .o_dm_awprot  (axi.awprot),
  .o_dm_wvalid  (axi.wvalid),
  .i_dm_wvalid  (axi.wvalid),
  .o_dm_wdata   (axi.wdata),
  .o_dm_wstrb   (axi.wstrb),
  .i_dm_bvalid  (axi.bvalid),
  .o_dm_bready  (axi.bready),
  .i_dm_bresp   (axi.bresp)
);


// processes
initial begin
  clk = 1;
  forever #(TClk/2) clk = ~clk;
end

initial begin
  rstn = 0;
  repeat (ResetLen) @(posedge clk);
  @(negedge clk);
  rstn = 1;
end

initial begin
  ls.wvalid = 0;
  ls.base_addr = 0;
  ls.offset = 0;
  ls.width = 0;
  ls.wdata = 0;
  ls.awready = 0;
  ls.wready = 0;
  ls.bvalid = 0;
  ls.bresp = 0;

  uvm_config_db #(virtual load_store_if)::set(null, "*", "ls", ls);
  uvm_config_db #(virtual axi_lite_if)::set(null, "*", "axi", ls);

  run_test();
end

endmodule
