// store_unit.sv

`default_nettype none

module store_unit # (
  parameter int XLEN = 64,
  parameter int ALEN = XLEN,
  parameter int DLEN = XLEN,
  parameter int SLEN = DLEN / 8
)(
  input var                     clk,
  input var                     rstn,

  // datapath interface
  input var                     i_tvalid,
  output var logic              o_tready,

  input var         [XLEN-1:0]  i_base_addr,
  input var         [XLEN-1:0]  i_offset,

  input var         [2:0]       i_width,
  input var         [XLEN-1:0]  i_source,

  // axi lite master write interface
  output var logic              o_dm_awvalid,
  input var                     i_dm_awready,
  output var logic  [ALEN-1:0]  o_dm_awaddr,
  output var logic  [2:0]       o_dm_awprot,

  output var logic              o_dm_wvalid,
  input var logic               i_dm_wready,
  output var logic  [DLEN-1:0]  o_dm_wdata,
  output var logic  [SLEN-1:0]  o_dm_wstrb,

  input var                     i_dm_bvalid,
  output var logic              o_dm_bready,
  input var         [1:0]       i_dm_bresp
);

initial begin
  assert (ALEN >= XLEN) else $error("AXI Address width must not be less than processor XLEN:\tALEN= %d\tXLEN= %d");
  assert (DLEN >= XLEN) else $error("AXI Data width must not be less than processor XLEN:\tALEN= %d\tXLEN= %d");
end

// write enable
logic en;
always_comb begin
  en = i_tvalid & o_tready;
end

// write address channel control
always_ff @(posedge clk) begin
  if (!rstn) begin
    o_dm_awvalid <= 0;
  end else begin
    if (o_dm_awvalid) begin
      o_dm_awvalid <= ~i_dm_awready;
    end else begin
      o_dm_awvalid <= en;
    end
  end
end

// write response accepted
logic b_done;
always_comb begin
  b_done = i_dm_bvalid & o_dm_bready;
end

// write address done latch
logic aw_done;
always_ff @(posedge clk) begin
  if (!rstn) begin
    aw_done <= 0;
  end else begin
    if (aw_done) begin
      aw_done <= ~b_done;
    end else begin
      aw_done <= i_dm_awvalid & o_dm_awready;
    end
  end
end

// write data done latch
logic w_done;
always_ff @(posedge clk) begin
  if (!rstn) begin
    w_done <= 0;
  end else begin
    if (w_done) begin
      w_done <= ~b_done;
    end else begin
      w_done <= i_dm_wvalid & o_dm_wready;
    end
  end
end

// write address channel address
always_ff @(posedge clk) begin
  if (en) begin
    o_dm_awaddr <= i_base_addr + i_offset;
  end else begin
    o_dm_awaddr <= o_dm_awaddr;
  end
end

// write address channel protection
assign o_dm_awprot = 3'b000;

// write data channel control
always_ff @(posedge clk) begin
  if (!rstn) begin
    o_dm_wvalid <= 0;
  end else begin
    if (o_dm_wvalid) begin
      o_dm_wvalid <= ~i_dm_wready;
    end else begin
      o_dm_wvalid <= en;
    end
  end
end

// write data channel data
always_ff @(posedge clk) begin
  if (en) begin
    o_dm_wdata <= i_source;
  end else begin
    o_dm_wdata <= o_dm_wdata;
  end
end

// store widths
localparam bit [2:0] Byte = 3'b000;
localparam bit [2:0] Half = 3'b001;
localparam bit [2:0] Word = 3'b010;
localparam bit [2:0] Double = 3'b100;

// write data channel strobe
always_ff @(posedge clk) begin
  if (en) begin
    unique case (i_width)
      Byte: o_dm_wstrb <= {{(SLEN-1){1'b0}}, 1'b1};
      Half: o_dm_wstrb <= {{(SLEN-2){1'b0}}, 2'b11};
      Word: o_dm_wstrb <= {{(SLEN-4){1'b0}}, 4'b1111};
      Double: o_dm_wstrb <= {{(SLEN-8){1'b0}}, 8'b11111111};
      unique: begin
        o_dm_wstrb <= 0;
        $warning("Illegal i_width value: 0b%03b", i_width);
      end
    endcase
  end else begin
    o_dm_wstrb <= o_dm_wstrb;
  end
end

// write response control
always_ff @(posedge clk) begin
  if (!rstn) begin
    o_dm_bready <= 0;
  end else begin
    if (o_dm_bready) begin
      o_dm_bready <= ~i_dm_bvalid;
    end else begin
      o_dm_bready <= en;
    end
  end
end

// data path ready
always_ff @(posedge clk) begin
  if (!rstn) begin
    o_tready <= 1;
  end else begin
    if (o_tready) begin
      o_tready <= ~i_valid;
    end else begin
      o_tready <= aw_done & w_done & b_done;
    end
  end
end

endmodule
