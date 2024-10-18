// tb_fetch.sv

`default_nettype none

module tb_fetch;

/* DUT Parameter Configuration */
localparam int TClk = 10;
localparam int ResetClks = 10;
localparam int XLen = 64;
localparam int ResetAddr = 'h1000;
localparam int IAlign = 4;


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
fetch_if # (
  .XLEN (XLen)
) if_f (
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
fetch # (
  .XLEN       (XLen),
  .RESET_ADDR (ResetAddr),
  .IALIGN     (IAlign)
) u_DUT (
  .clk                (clk),
  .rstn               (rstn),
  .i_jump_valid       (if_f.jump_valid),
  .i_jump_addr        (if_f.jump_addr),
  .i_branch_valid     (if_f.branch_valid),
  .i_branch_addr      (if_f.branch_addr),
  .i_halt_n           (if_f.halt_n),
  .o_pc_valid         (if_f.pc_valid),
  .o_pc               (if_f.pc),
  .o_pc_addr_misalign (if_e.pc_addr_misalign),
  .if_im              (if_im)
);


/*
  Directed Tests
    1. Increment
      - halt_n is set
      - PC is PC + 2**IALIGN
*/

/* Assertions */
// General Assertions
assert property(disable iff(!rstn) @(posedge clk) if_im.araddr == if_f.pc);
assert property(disable iff(!rstn) @(posedge clk) if_im.arvalid == if_f.pc_valid);
assert property(disable iff(!rstn) @(posedge clk) (if_f.pc[1:0] != 0) |-> if_e.pc_addr_misalign);


// Halt Assertions
// assert property (
//   disable iff(!rstn)
//   @(posedge clk)
//   !if_f.halt_n |->  if_f.pc == $past(if_f.pc, 1) &&
//                     if_im.araddr == $past(if_im.araddr, 1) &&
//                     if_im.arprot == $past(if_im.arprot, 1)
// );

initial begin
  if_f.halt_n = 0;
  if_f.jump_valid = 0;
  if_f.jump_addr = 0;
  if_f.branch_valid = 0;
  if_f.branch_addr = 0;
  if_im.arready = 0;

  wait (rstn);

  increment(2);

  repeat (10) @(posedge clk);
  $display("Testing Completed");
  $finish;
end

task increment(input int cycles);
  int last_pc;
  int expected_pc;

  @(negedge clk);
  if_f.halt_n <= 1;

  for (int i=0; i < cycles; i++) begin
    last_pc = if_f.pc;
    expected_pc = last_pc + IAlign;
    @(negedge clk);
    assert (if_f.pc == expected_pc)
    else $error("pc - expected: 0x%016x\treal: 0x%016x", expected_pc, if_f.pc);
    
    assert (if_f.pc_valid) else $display("pc_valid still 0");
  end

  if_f.halt_n <= 0;
endtask

endmodule
