// tb_decode.sv

`default_nettype none

`include "uvm_macros.svh"

module tb_decode;

import uvm_pkg::*;
import decode_pkg::*;

/* DUT Parameter Configuration */
localparam int TClk = 10;
localparam int ResetClks = 10;
localparam int XLen = 64;


/* DUT Clocks and Resets */
bit clk;
initial begin
  clk = 0;
  forever #(TClk/2) clk = ~clk;
end

bit rstn;
initial begin
  rstn = 0;
  repeat (ResetClks) @(posedge clk);
  @(negedge clk);
  rstn = 1;
end


/* DUT Signals and Interfaces */
decode_if # (
  .XLEN (XLen)
) if_d (
  .clk  (clk),
  .rstn (rstn)
);

exception_if if_e (
  .clk  (clk),
  .rstn (rstn)
);

axi_lite_if # (
  .ALEN (XLen),
  .DLEN (32)
) if_im (
  .aclk     (clk),
  .aresetn  (rstn)
);


/* DUT Instantiation */
decode # (
  .XLEN (XLen)
) u_DUT (
  .clk              (clk),
  .rstn             (rstn),
  .if_im            (if_im),
  .i_dm_ready       (if_d.dm_ready),
  .o_int_comp_r     (if_d.int_comp_r),
  .o_int_comp_i     (if_d.int_comp_i),
  .o_lui            (if_d.lui),
  .o_auipc          (if_d.auipc),
  .o_jal            (if_d.jal),
  .o_jalr           (if_d.jalr),
  .o_branch_check   (if_d.branch_check),
  .o_load           (if_d.load),
  .o_store          (if_d.store),
  .o_invalid_opcode (if_e.invalid_opcode),
  .o_rd             (if_d.rd),
  .o_funct3         (if_d.funct3),
  .o_funct7         (if_d.funct7),
  .o_immediate      (if_d.immediate),
  .o_int_src1       (if_d.int_src1),
  .o_int_src2       (if_d.int_src2),
  .o_pc             (if_d.pc),
  .i_rf_wvalid      (if_d.rf_wvalid),
  .i_rf_waddr       (if_d.rf_waddr),
  .i_rf_wdata       (if_d.rf_wdata)
);

initial begin
  if_d.dm_ready = 0;
  if_d.rf_wvalid = 0;
  if_d.rf_waddr = 0;
  if_d.rf_wdata = 0;
  if_im.arvalid = 0;
  if_im.araddr = 0;

  uvm_config_db #(virtual decode_if#(XLen))::set(null,"*","vif_d",if_d);
  uvm_config_db #(virtual exception_if)::set(null,"*","vif_e",if_e);
  uvm_config_db #(virtual axi_lite_if#(.ALEN(XLen),.DLEN(32)))::set(null,"*","vif_im",if_im);

  uvm_top.run_test("decode_test");
end

endmodule
