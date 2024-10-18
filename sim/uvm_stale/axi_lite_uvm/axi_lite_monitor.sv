// axi_lite_monitor.sv

`ifndef __AXI_LITE_MONITOR
`define __AXI_LITE_MONITOR

class axi_lite_monitor # (
  int ALEN = 64,
  int DLEN = 64,
  string IF_NAME = "axi"
) extends uvm_monitor;

`uvm_component_utils(axi_lite_monitor#(ALEN,DLEN,IF_NAME))

virtual axi_lite_if#(ALEN,DLEN) vif;

uvm_analysis_port #(axi_lite_seq_item#(ALEN,DLEN)) req_ap;
// uvm_analysis_port #(axi_lite_seq_item)  mon_ap;

function new(string name="axi_lite_monitor", uvm_component parent);
  super.new(name, parent);
  `uvm_info(get_name(), "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_name(), "build_phase", UVM_LOW)
  if (!uvm_config_db#(virtual axi_lite_if#(ALEN,DLEN))::get(this,"",IF_NAME,vif)) begin
    `uvm_fatal(get_name(), "failed to get interface")
  end
  req_ap = new("req_ap", this);
endfunction

// virtual task read_address(ref axi_lite_seq_item#(ALEN,DLEN) txn);
//   wait (vif.arvalid && vif.arready);
//   @(negedge vif.aclk);
//   txn.araddr = vif.araddr;
//   txn.arprot = vif.arprot;
// endtask

task run_phase(uvm_phase phase);
  axi_lite_seq_item#(.ALEN(ALEN),.DLEN(DLEN)) txn;
  super.run_phase(phase);
  `uvm_info(get_name(), "run_phase", UVM_LOW)
  forever begin
    txn = axi_lite_seq_item#(.ALEN(ALEN),.DLEN(DLEN))::type_id::create("txn", this);
    wait (vif.arvalid);
    txn.arvalid = vif.arvalid;
    txn.arready = vif.arready;
    txn.araddr = vif.araddr;
    txn.arprot = vif.arprot;
    req_ap.write(txn);
  end
endtask

endclass

`endif
