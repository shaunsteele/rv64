// load_store_if.sv

`default_nettype none

interface load_store_if # (
  parameter int XLEN = 64
)(
  input var clk,
  input var rstn
);

// load signals

// store signals
logic             wvalid;
logic             wready;
logic [XLEN-1:0]  wdata;


// shared signals
logic [XLEN-1:0]  base_addr;
logic [XLEN-1:0]  offset;
logic [2:0]       width;

endinterface
