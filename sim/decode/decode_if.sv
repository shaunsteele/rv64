// decode_if.sv

`default_nettype none

interface decode_if # (
  parameter int XLEN = 64
)(
  input var clk,
  input var rstn
);

logic dm_ready;

logic int_comp_r;
logic int_comp_i;
logic lui;
logic auipc;
logic jal;
logic jalr;
logic branch_check;
logic load;
logic store;

logic [4:0] rd;
logic [2:0] funct3;
logic [6:0] funct7;
logic [XLEN-1:0]  immediate;
logic [XLEN-1:0]  int_src1;
logic [XLEN-1:0]  int_src2;
logic [XLEN-1:0]  pc;

logic rf_wvalid;
logic [4:0] rf_waddr;
logic [XLEN-1:0]  rf_wdata;

endinterface
