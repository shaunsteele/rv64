// tb_fetch.sv

`default_nettype none

`include "uvm_macros.svh"


module tb_fetch;

import uvm_pkg::*;
import fetch_pkg::*;


// parameter configuration
localparam int XLen = 64;
localparam int ResetAddr = 'h1000;
localparam int IAlign = 4;

// clock
localparam int TClk = 10;
bit clk;

initial begin
  clk = 0;
  forever #(TClk/2) clk = ~clk;
end

// reset
localparam int ResetLen = 10;
bit rstn;

initial begin
  rstn = 0;
  repeat (ResetLen) @(posedge clk);
  @(negedge clk);
  rstn = 1;
end

// interfaces
fetch_if #(.XLEN(XLen)) f (.clk(clk), .rstn(rstn));
axi_lite_if #(.ALEN(XLen)) im (.aclk(clk), .aresetn(rstn));

// DUT
fetch # (
  .XLEN       (XLen),
  .RESET_ADDR (ResetAddr),
  .IALIGN     (IAlign)
) u_DUT (
  .clk            (clk),
  .rstn           (rstn),
  .i_jump_valid   (f.jump_valid),
  .i_jump_addr    (f.jump_addr),
  .i_branch_valid (f.branch_valid),
  .i_branch_addr  (f.branch_addr),
  .i_halt         (f.halt),
  .o_pc           (f.pc),
  .o_pc_misalign  (f.pc_misalign),
  .im_if          (im)
);

initial begin
  f.jump_valid = 0;
  f.jump_addr = 0;
  f.branch_valid = 0;
  f.branch_addr = 0;
  f.halt = 0;
  im.arready = 0;

  uvm_config_db #(virtual fetch_if#(.XLEN(XLen)))::set(null, "*", "f", f);
  uvm_config_db #(virtual axi_lite_if#(.ALEN(XLen)))::set(null, "*", "im", im);

  run_test("fetch_base_test");
end

endmodule
