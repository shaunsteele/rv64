// decode_monitor.sv

`ifndef __DECODE_MONITOR
`define __DECODE_MONITOR

class decode_monitor extends uvm_monitor;

`uvm_component_utils(decode_monitor)

virtual decode_if #(64) vif_d;
virtual exception_if vif_e;
virtual axi_lite_if #(.ALEN(64),.DLEN(32)) vif_im;

uvm_analysis_port #(decode_seq_item) ap;

function new(string name="decode_monitor", uvm_component parent);
  super.new(name, parent);
  `uvm_info("MON","constructor",UVM_LOW)
  ap = new("decode_ap",this);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual decode_if#(64))::get(null,"*","vif_d",vif_d)) begin
    `uvm_fatal("MON","failed to get vif_d")
  end
  if (!uvm_config_db #(virtual exception_if)::get(null,"*","vif_e",vif_e)) begin
    `uvm_fatal("MON","failed to get vif_e")
  end
  if (!uvm_config_db #(virtual axi_lite_if#(.ALEN(64),.DLEN(32)))::get(null,"*","vif_im",vif_im)) begin
    `uvm_fatal("MON","failed to get vif_im")
  end
  `uvm_info("MON","build_phase",UVM_LOW)
endfunction

task run_phase(uvm_phase phase);
  decode_seq_item txn;
  super.run_phase(phase);
  `uvm_info("MON","run_phase",UVM_LOW)
  forever begin
    txn = decode_seq_item::type_id::create("txn",this);
    
    wait (vif_d.rstn);
    wait (vif_im.rvalid);
    @(negedge vif_d.clk);
    txn.im_arvalid = vif_im.arvalid;
    txn.im_araddr = vif_im.araddr;
    txn.im_rvalid = vif_im.rvalid;
    txn.im_rready = vif_im.rready;
    txn.im_rdata = vif_im.rdata;
    txn.im_rresp = vif_im.rresp;
    txn.dm_ready = vif_d.dm_ready;
    txn.int_comp_r = vif_d.int_comp_r;
    txn.int_comp_i = vif_d.int_comp_i;
    txn.lui = vif_d.lui;
    txn.auipc = vif_d.auipc;
    txn.jal = vif_d.jal;
    txn.jalr = vif_d.jalr;
    txn.branch_check = vif_d.branch_check;
    txn.load = vif_d.load;
    txn.store = vif_d.store;
    txn.invalid_opcode = vif_e.invalid_opcode;
    txn.rd = vif_d.rd;
    txn.funct3 = vif_d.funct3;
    txn.funct7 = vif_d.funct7;
    txn.immediate = vif_d.immediate;
    txn.int_src1 = vif_d.int_src1;
    txn.int_src2 = vif_d.int_src2;
    txn.pc = vif_d.pc;
    txn.rf_wvalid = vif_d.rf_wvalid;
    txn.rf_waddr = vif_d.rf_waddr;
    txn.rf_wdata = vif_d.rf_wdata;

    ap.write(txn);
  end
endtask


endclass

`endif
