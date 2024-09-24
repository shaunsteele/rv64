// load_unit.sv

`default_nettype  none

module load_unit # (
  parameter int XLEN = 64,
  parameter int ALEN = XLEN,
  parameter int DLEN = XLEN,
  parameter int SLEN = DLEN / 8
)(
  input var                 clk,
  input var                 rstn,

  // datapath interface
  input var                 i_tvalid,
  output var logic          o_tready,

  input var         [XLEN-1:0]  i_base_addr,
  input var         [XLEN-1:0]  i_offset,

  input var         [2:0]       i_width,
  input var         [4:0]       i_dest,

  // axi lite master read interface

  // register file write interface
);

endmodule
