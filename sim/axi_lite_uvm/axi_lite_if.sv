// axi_lite_if.sv

`default_nettype none

interface axi_lite_if # (
  parameter int ALEN = 32,
  parameter int DLEN = 32,
  parameter int SLEN = DLEN / 8
)(
  input var aclk,
  input var aresetn
);

// write address channel
logic             awvalid;
logic             awready;
logic [ALEN-1:0]  awaddr;
logic [2:0]       awprot;

// write data channel
logic             wvalid;
logic             wready;
logic [DLEN-1:0]  wdata;
logic [SLEN-1:0]  wresp;

// write response channel
logic             bvalid;
logic             bready;
logic [1:0]       bresp;

// read address channel
logic             arvalid;
logic             arready;
logic [ALEN-1:0]  araddr;
logic [2:0]       arprot;

// read data channel
logic             rvalid;
logic             rready;
logic [DLEN-1:0]  rdata;
logic [1:0]       rresp;


endinterface
