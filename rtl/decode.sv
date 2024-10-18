// decode.sv

`default_nettype none

module decode # (
  parameter int XLEN = 64
)(
  input var                     clk,
  input var                     rstn,

  axi_lite_if.M                 if_im,

  input var                     i_dm_ready,

  output var logic              o_int_comp_r,
  output var logic              o_int_comp_i,
  output var logic              o_lui,
  output var logic              o_auipc,
  output var logic              o_jal,
  output var logic              o_jalr,
  output var logic              o_branch_check,
  output var logic              o_load,
  output var logic              o_store,
  output var logic              o_invalid_opcode,

  output var logic  [4:0]       o_rd,
  output var logic  [2:0]       o_funct3,
  output var logic  [6:0]       o_funct7,
  output var logic  [XLEN-1:0]  o_immediate,
  output var logic  [XLEN-1:0]  o_int_src1,
  output var logic  [XLEN-1:0]  o_int_src2,
  output var logic  [XLEN-1:0]  o_pc,

  input var                     i_rf_wvalid,
  input var         [4:0]       i_rf_waddr,
  input var         [XLEN-1:0]  i_rf_wdata
);

// recieve instruction data
assign if_im.rready = i_dm_ready;

logic [XLEN-1:0]  instruction;
always_ff @(posedge clk) begin
  if (!rstn) begin
    instruction <= 0;
  end else begin
    if (if_im.rvalid) begin
      instruction <= if_im.rdata;
    end else begin
      instruction <= instruction;
    end
  end
end

logic [1:0] im_status;
always_ff @(posedge clk) begin
  if (!rstn) begin
    im_status <= 0;
  end else begin
    if (if_im.rvalid) begin
      im_status <= if_im.rresp;
    end else begin
      im_status <= 0;
    end
  end
end

// opcode decoder
logic [6:0] opcode;
assign opcode = instruction[6:0];

localparam bit [6:0] OpRInt     = 7'b0110011; // x33
localparam bit [6:0] OpIInt     = 7'b0010011; // x13
localparam bit [6:0] OpUImm     = 7'b0110111; // x37
localparam bit [6:0] OpUPc      = 7'b0010111; // x17
localparam bit [6:0] OpUJump    = 7'b1101111; // x6F
localparam bit [6:0] OpIJump    = 7'b1100111; // x67
localparam bit [6:0] OpSBranch  = 7'b1100011; // x63
localparam bit [6:0] OpILoad    = 7'b0000011; // x03
localparam bit [6:0] OpSStore   = 7'b0100011; // x23

always_comb begin
  o_int_comp_r =    opcode == OpRInt;
  o_int_comp_i =    opcode == OpIInt;
  o_lui =           opcode == OpUImm;
  o_auipc =         opcode == OpUPc;
  o_jal =           opcode == OpUJump;
  o_jalr =          opcode == OpIJump;
  o_branch_check =  opcode == OpSBranch;
  o_load =          opcode == OpILoad;
  o_store =         opcode == OpSStore;
  o_invalid_opcode = ~(o_int_comp_r | o_int_comp_i | o_lui | o_auipc |
    o_jal | o_jalr | o_branch_check | o_load | o_store | (im_status != 0));
end

// immediate formatting
always_comb begin
  unique case (opcode)
    OpRInt: begin
      o_immediate = 0;
    end

    OpIInt, OpIJump, OpILoad: begin
      o_immediate = {
        {(XLEN-12){instruction[31]}},
        instruction[31:20]
      };
    end

    OpSBranch: begin
      o_immediate = {
        {(XLEN-12){instruction[31]}},
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
      };
    end

    OpSStore: begin
      o_immediate = {
        {(XLEN-11){instruction[31]}},
        instruction[30:25],
        instruction[11:7]
      };
    end

    OpUImm, OpUPc: begin
      o_immediate = {
        instruction [31:12],
        12'b0
      };
    end

    OpUJump: begin
      o_immediate = {
        {(XLEN-20){instruction[31]}},
        instruction[19:12],
        instruction[20],
        instruction[30:21],
        1'b0
      };
    end

    default: o_immediate = 0;
  endcase
end

// instruction fields
assign o_rd = instruction[11:7];
assign o_funct3 = instruction[14:12];
assign o_funct7 = instruction[31:25];

logic [4:0] rs1;
assign rs1 = instruction[19:15];

logic [4:0] rs2;
assign rs2 = instruction[24:20];

// register file
logic [XLEN-1:0]  x_int[32];

always_comb begin
  o_int_src1 = x_int[rs1];
  o_int_src2 = x_int[rs2];
end

always_ff @(posedge clk) begin
  if (i_rf_wvalid && (i_rf_waddr != 0)) begin
    x_int[i_rf_waddr] <= i_rf_wdata;
  end else begin
    x_int[0] <= 0;
  end
end

// program counter forwarding
always_ff @(posedge clk) begin
  if (if_im.arvalid) begin
    o_pc <= if_im.araddr;
  end else begin
    o_pc <= o_pc;
  end
end

endmodule
