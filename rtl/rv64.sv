// rv64.sv

`default_nettype none

module rv64 # (
  parameter int XLEN = 64,
  parameter int I_ALEN = XLEN,
  parameter int I_DLEN = XLEN,
  parameter int D_ALEN = XLEN,
  parameter int D_DLEN = XLEN,
  parameter int INIT_ADDR = 0
)(
  input var             clk,
  input var             rstn,

  axi_lite_if.M         im,
  axi_lite_if.M         dm
);

/* program counter */
// control transfer signals
logic jump_valid;
logic [XLEN-1:0]  jump_addr;
logic branch_valid;
logic [XLEN-1:0]  branch_addr;

// program counter register
logic [XLEN-1:0] pc;
always_comb begin
  if (jump_valid) begin
    pc = jump_addr;
  end else if (branch_valid) begin
    pc = im.araddr + branch_addr;
  end else begin
    pc = im.araddr + 4;
  end
end


/* instruction fetch */
logic fetch_en;

// read address control
always_ff @(posedge clk) begin
  if (!rstn) begin
    im.arvalid <= 0;
  end else begin
    if (im.arvalid) begin
      im.arvalid <= ~im.arready | fetch_en; //// valid lowers when ready is raised and fetching is disabled
    end else begin
      im.arvalid <= fetch_en; //// valid raises when fetching is enabled
    end
  end
end

// read address
always_ff @(posedge clk) begin
  if (!rstn) begin
    im.araddr <= INIT_ADDR;
  end else begin
    im.araddr <= pc;
  end
end

// read address protection
assign im.arprot = 3'b100;

// read data ready
always_ff @(posedge clk) begin
  if (!rstn) begin
    im.rready <= 0;
  end else begin
    if (im.rready) begin
      im.rready <= ~im.rvalid | fetch_en; ////
    end else begin
      im.rready <= fetch_en; ////
    end
  end
end

// read data instruction
logic [31:0] instruction;
always_ff @(posedge clk) begin
  if (im.rvalid) begin
    instruction <= im.rdata;
  end else begin
    instruction <= instruction;
  end
end

// read data information
logic [1:0] im_status;
always_ff @(posedge clk) begin
  if (!rstn) begin
    im_status <= 2'b00;
  end else begin
    if (im.rvalid) begin
      im_status <= im.resp;
    end else begin
      im_status <= im_status;
    end
  end
end


/* instruction decode */
// static values
logic [6:0] opcode;
assign opcode = instruction[6:0];

logic [4:0] rd;
assign rd = instruction[11:7];

logic [2:0] funct3;
assign funct3 = instruction[14:12];

logic [4:0] rs1;
assign rs1 = instruction[19:15];

logic [4:0] rs2;
assign rs2 = instruction[24:20];

logic [7:0] funct7;
assign funct7 = instruction[31:25];

// opcode types
localparam bit [6:0] OpRInt     = 7'b0110011; // x33
localparam bit [6:0] OpIInt     = 7'b0010011; // x13
localparam bit [6:0] OpUImm     = 7'b0110111; // x37
localparam bit [6:0] OpUPc      = 7'b0010111; // x17
localparam bit [6:0] OpUJump    = 7'b1101111; // x6F
localparam bit [6:0] OpIJump    = 7'b1100111; // x67
localparam bit [6:0] OpSBranch  = 7'b1100011; // x63
localparam bit [6:0] OpILoad    = 7'b0000011; // x03
localparam bit [6:0] OpSStore   = 7'b0100011; // x23
// localparam bit [6:0] OpMMem     = 7'b0001111; // x0F
// localparam bit [6:0] OpSystem   = 7'b0;

// immediate decoder
logic [XLEN-1:0]  immediate;
always_comb begin
  unique case (opcode)
    OpRInt: begin
      immediate = 0;
    end

    OpIInt, OpIJump, OpILoad: begin
      immediate = {
        {(XLEN-12){instruction[31]}},
        instruction[31:20]
      };
    end

    OpSBranch: begin
      immediate = {
        {(XLEN-12){instruction[31]}},
        instruction[7],
        instruction[30:25],
        instruction[11:8],
        1'b0
      };
    end

    OpSStore: begin
      immediate = {
        {(XLEN-11){instruction[31]}},
        instruction[30:25],
        instruction[11:7]
      };
    end

    OpUImm, OpUPc: begin
      immediate = {
        instruction [31:12],
        12'b0
      };
    end

    OpUJump: begin
      immediate = {
        {(XLEN-20){instruction[31]}},
        instruction[19:12],
        instruction[20],
        instruction[30:21],
        1'b0
      };
    end

    default: immediate = 0;
  endcase
end


/* register file read */
// register array
logic [XLEN-1:0]  x[32];

// read sources
logic [XLEN-1:0]  src1;
logic [XLEN-1:0]  src2;

always_comb begin
  src1 = x[rs1];
  src2 = x[rs2];  
end


/* integer computation execution */
// integer computation control
logic int_comp_valid;
logic imm_sel;
always_comb begin
  int_comp_valid = opcode == OpRInt | opcode == OpIInt;
  imm_sel = opcode == OpIInt;
end

// integer computation inputs
logic [9:0] int_comp_op;
assign int_comp_op = {funct7, funct3};

logic [XLEN-1:0] a;
assign a = src1;

logic [XLEN-1:0] b;
always_comb begin
  if (imm_sel) begin
    b = immediate;
  end else begin
    b = src2;
  end
end

// integer computation types
localparam bit [9:0] IntCompAdd   = 10'b00_0000_0000;  // 0x000
localparam bit [9:0] IntCompSub   = 10'b01_0000_0000;  // 0x100
localparam bit [9:0] IntCompSll   = 10'b00_0000_0001;  // 0x001
localparam bit [9:0] IntCompSlt   = 10'b00_0000_0010;  // 0x002
localparam bit [9:0] IntCompSltu  = 10'b00_0000_0011;  // 0x003
localparam bit [9:0] IntCompXor   = 10'b00_0000_0100;  // 0x004
localparam bit [9:0] IntCompSrl   = 10'b00_0000_0101;  // 0x005
localparam bit [9:0] IntCompSra   = 10'b01_0000_0101;  // 0x105
localparam bit [9:0] IntCompOr    = 10'b00_0000_0110;  // 0x006
localparam bit [9:0] IntCompAnd   = 10'b00_0000_0111;  // 0x007

// integer computation outputs
logic [4:0] int_comp_dest;
assign int_comp_dest = rd;

logic [XLEN-1:0]  int_comp_res;
always_comb begin
  unique case (int_comp_op)
    IntCompAdd:   int_comp_res = a + b;
    IntCompSub:   int_comp_res = a - b;
    IntCompSlt:   int_comp_res = {{(XLEN-1){1'b0}}, $signed(a) < $signed(b)};
    IntCompSltu:  int_comp_res = {{(XLEN-1){1'b0}}, $unsigned(a) < $unsigned(b)};
    IntCompXor:   int_comp_res = a ^ b;
    IntCompOr:    int_comp_res = a | b;
    IntCompAnd:   int_comp_res = a & b;
    IntCompSll:   int_comp_res = a << b;
    IntCompSrl:   int_comp_res = a >> b;
    IntCompSra:   int_comp_res = $signed(a) >>> b;
    default: int_comp_res = 0;
  endcase
end


/* upper instruction execution */
// upper control
logic upper_valid;
logic pc_sel;
always_comb begin
  upper_valid = opcode == OpUImm | opcode == OpUPc;
  pc_sel = opcode == OpUPc;
end

logic [4:0] upper_dest;
assign upper_dest = rd;

// upper selection
logic [XLEN-1:0]  upper_res;
always_comb begin
  if (pc_sel) begin
    upper_res = immediate + pc; //// look into if correct pc value at execution time
  end else begin
    upper_res = immediate;
  end
end


/* jump instruction execution */
always_comb begin
  jump_valid = opcode == OpUJump | opcode == OpIJump;
  jalr_sel = opcode == OpIJump;
end

always_comb begin
  if (jalr_sel) begin
    jump_addr = src1 + immediate;
  end else begin
    jump_addr = immediate;
  end
end

logic [4:0] jump_dest;
assign jump_dest = rd;

logic [XLEN-1:0] jump_ret_addr;
always_comb begin
  jump_ret_addr = pc + 4;
end


/* branch instruction execution */
logic branch_check;
always_comb begin
  branch_check = opcode == OpSBranch;
end

localparam bit [2:0]  BrEQ  = 3'b000;
localparam bit [2:0]  BrNE  = 3'b001;
localparam bit [2:0]  BrLT  = 3'b100;
localparam bit [2:0]  BrGE  = 3'b101;
localparam bit [2:0]  BrLTU = 3'b110;
localparam bit [2:0]  BrGEU = 3'b111;

logic [2:0] branch_op;
assign branch_op = funct3;

always_comb begin
  unique case (branch_op)
    BrEQ: branch_valid = src1 == src2;
    BrNE: branch_valid = src1 != src2;
    BrLT: branch_valid = $signed(src1) < $signed(src2);
    BrGE: branch_valid = $signed(src1) >= $signed(src2);
    BrLTU: branch_valid = $unsigned(src1) < $unsigned(src2);
    BrGEU: branch_valid = $unsigned(src1) >= $unsigned(src2);
    default: branch_valid = 0;
  endcase
end

always_comb begin
  if (branch_valid) begin
    branch_addr = pc + immediate;
  end else begin
    branch_addr = pc + 4;
  end
end


/* load instruction execution */
logic load_valid;
always_comb begin
  load_valid = opcode == OpILoad;
end

// calculate address
logic [XLEN-1:0]  load_base;
logic assign load_base = src1;

logic [XLEN-1:0]  load_offset;
logic assign load_offset = immediate;

logic [XLEN-1:0]  load_addr;
always_comb begin
  load_addr = load_base + load_offset;
end

logic load_misaligned_address_exception;
assign load_misaligned_address_exception = load_addr[0];

// read address channel
always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.arvalid <= 0;
  end else begin
    if (dm.arvalid) begin
      dm.arvalid <= ~dm.arready;
    end else begin
      dm.arvalid <= load_valid;
    end
  end
end

always_ff @(posedge clk) begin
  if (dm.arvalid && !dm.arvalid) begin
    dm.araddr <= dm.araddr;
  end else begin
    dm.araddr <= load_addr;
  end
end

assign dm.arprot = 3'b000;

// read data channel
always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.rready <= ~dm.rvalid;
  end else begin
    dm.bready <= load_valid;
  end
end

logic [XLEN-1:0]  load_data;
always_ff @(posedge clk) begin
  if (dm.rvalid && dm.rready) begin
    load_data <= dm.rdata;
  end else begin
    load_data <= load_data;
  end
end

logic [1:0] load_memory_read_error_exception;
always_ff @(posedge clk) begin
  if (!rstn) begin
    load_memory_read_error_exception <= 0;
  end else begin
    if (dm.rvalid && dm.rready) begin
      load_memory_read_error_exception <= dm.rresp;
    end else begin
      load_memory_read_error_exception <= load_memory_read_error_exception;
    end
  end
end


/* store instruction execution */
logic store_valid;
always_comb begin
  store_valid = opcode == OpSStore;
end

logic [4:0] load_dest;
assign load_dest = rd;

// calculate address
logic [XLEN-1:0]  store_base;
assign store_base = src1;

logic [XLEN-1:0]  store_offset;
assign store_offset = immediate;

logic [XLEN-1:0]  store_addr;
always_comb begin
  store_addr = store_base + store_offset;
end

logic store_misaligned_address_exception;
assign store_misaligned_address_exception = store_addr[0];

// write address channel
always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.awvalid <= 0;
  end else begin
    if (dm.awvalid) begin
      dm.awvalid <= ~dm.awready;
    end else begin
      dm.awvalid <= store_valid;
    end
  end
end

always_ff @(posedge clk) begin
  if (dm.awvalid && !dm.awready) begin
    dm.awaddr <= dm.awaddr;
  end else begin
    dm.awaddr <= store_addr;
  end
end

assign dm.awprot = 3'b000;

// write data channel
logic [XLEN-1:0] store_data;
assign store_data = src2;

always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.wvalid <= 0;
  end else begin
    if (dm.wvalid) begin
      dm.wvalid <= ~dm.wready;
    end else begin
      dm.wvalid <= store_valid;
    end
  end
end

always_ff @(posedge clk) begin
  if (dm.wvalid && !dm.wready) begin
    dm.wdata <= dm.wdata;
  end else begin
    dm.wdata <= store_data;
  end
end

logic [2:0] store_width;
assign store_width = funct3;

always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.wstrb <= {(XLEN){1'b1}};
  end else begin
    if (dm.wvalid && !dm.wready) begin
      dm.wstrb <= dm.wstrb;
    end else begin
      unique case (store_width)
        3'b000: dm.wstrb <= {(XLEN-1){1'b0}, 1'b1};
        3'b001: dm.wstrb <= {(XLEN-2){1'b0}, 2'b11};
        3'b010: dm.wstrb <= {(XLEN-4){1'b0}, 2'b1111};
        3'b011: dm.wstrb <= {(XLEN){1'b1}};
        default: dm.wstrb <= 0;
      endcase
    end
  end
end

// write response channel
always_ff @(posedge clk) begin
  if (!rstn) begin
    dm.bready <= 0;
  end else begin
    if (dm.bready) begin
      dm.bready <= ~dm.bvalid;
    end else begin
      dm.bready <= store_valid;
    end
  end
end

logic [1:0] store_memory_write_error_exception;
always_ff @(posedge clk) begin
  if (!rstn) begin
    store_data_exception <= 0;
  end else begin
    if (dm.bvalid && dm.bready) begin
      store_memory_write_error_exception <= dm.bresp;
    end else begin
      store_memory_write_error_exception <= store_memory_write_error_exception;
    end
  end
end


/* register file write back */
always_ff @(posedge clk) begin
  if (load_valid && (load_dest != 0)) begin
    x[load_dest] <= load_data;
  end else if (jump_valid && (jump_dest != 0)) begin
    x[jump_dest] <= jump_ret_addr;
  end else if (upper_valid && (upper_dest != 0)) begin
    x[upper_dest] <= upper_res;
  end else if (int_comp_valid && (int_comp_dest != 0)) begin
    x[int_comp_dest] <= int_comp_res;
  end else begin
    x[int_comp_dest] <= x[int_comp_dest];
  end
end

/* fetch control */
always_comb begin
  if (!rstn) begin
    fetch_en = 0;
  end else begin
    if (load_valid && !(dm.rvalid && dm.rready)) begin
      fetch_en = 0;
    end else if (store_valid && !(dm.bvalid && dm.bready)) begin
      fetch_en = 0;
    end else begin
      fetch_en = 1;
    end
  end
end

endmodule
