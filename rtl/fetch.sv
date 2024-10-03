// fetch.sv

`default_nettype none

module fetch # (
  parameter int XLEN = 64,
  parameter int RESET_ADDR = 'h1000,
  parameter int IALIGN = 4
)(
  input var                     clk,
  input var                     rstn,

  input var                     i_jump_valid,
  input var         [XLEN-1:0]  i_jump_addr,
  input var                     i_branch_valid,
  input var         [XLEN-1:0]  i_branch_addr,

  input var                     i_halt_n,
  output var logic  [XLEN-1:0]  o_pc,
  output var logic              o_pc_misalign,

  axi_lite_if.M                 im_if
);

// TODO: think out halt logic
/* program counter */
logic [XLEN-1:0]  next_pc;
logic [XLEN-1:0]  pc;
always_comb begin
  if (!i_halt_n) begin
    next_pc = pc;
  end else begin
    if (i_jump_valid) begin
      next_pc = i_jump_addr;
    end else if (i_branch_valid) begin
      next_pc = pc + i_branch_addr;
    end else begin
      next_pc = pc + 4;
    end
  end
end

always_ff @(posedge clk) begin
  if (!rstn) begin
    pc <= RESET_ADDR;
  end else begin
    if (im_if.arvalid && !im_if.arready) begin
      pc <= pc;
    end else begin
      pc <= next_pc;
    end
  end
end

assign o_pc = pc;

always_comb begin
  o_pc_misalign = |pc[1:0];
end


/* instruction fetch */
always_ff @(posedge clk) begin
  if (!rstn) begin
    im_if.arvalid <= 0;
  end else begin
    if (im_if.arvalid) begin
      im_if.arvalid <= im_if.arready | i_halt_n;
    end else begin
      im_if.arvalid <= i_halt_n;
    end
  end
end

assign im_if.araddr = pc;
assign im_if.arprot = 3'b100; // instruction protection



endmodule
