// fetch.sv

`default_nettype none

module fetch # (
  parameter int XLEN = 64,
  parameter int RESET_ADDR = 'h1000,
  parameter int IALIGN = 4
)(
  input var                     clk,
  input var                     rstn,

  input var                     i_halt_n,

  input var                     i_jump_valid,
  input var         [XLEN-1:0]  i_jump_addr,
  input var                     i_branch_valid,
  input var         [XLEN-1:0]  i_branch_addr,

  output var logic              o_pc_valid,
  output var logic  [XLEN-1:0]  o_pc,
  output var logic              o_pc_addr_misalign,

  axi_lite_if.M                 if_im
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
    if (if_im.arvalid && !if_im.arready) begin
      pc <= pc;
    end else begin
      pc <= next_pc;
    end
  end
end

assign o_pc_valid = if_im.arvalid;
assign o_pc = pc;

always_comb begin
  o_pc_addr_misalign = |pc[1:0];
end


/* instruction fetch */
always_ff @(posedge clk) begin
  if (!rstn) begin
    if_im.arvalid <= 0;
  end else begin
    if (if_im.arvalid) begin
      if_im.arvalid <= if_im.arready | i_halt_n;
    end else begin
      if_im.arvalid <= i_halt_n;
    end
  end
end

assign if_im.araddr = pc;
assign if_im.arprot = 3'b100; // instruction protection



endmodule
