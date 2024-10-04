// axi_lite_monitor.sv

`ifndef __AXI_LITE_MONITOR
`define __AXI_LITE_MONITOR

class axi_lite_monitor extends uvm_monitor;

`uvm_component_utils(axi_lite_monitor)

axi_lite_if_base vif;

axi_lite_cfg cfg;

uvm_analysis_port #(axi_lite_seq_item)  mon_ap;

function new(string name="axi_lite_monitor", uvm_component parent);
  super.new(name, parent);
  `uvm_info(get_name(), "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_name(), "build_phase", UVM_LOW)
endfunction

virtual task read_address(ref axi_lite_seq_item txn);
  wait (vif.arvalid && vif.arready);
  @(negedge vif.aclk);
  txn.araddr = vif.araddr;
  txn.arprot = vif.arprot;
endtask

virtual task read_data(ref axi_lite_seq_item txn);
  // if (cfg.ren) begin
  //   wait (vif.rvalid && vif.rready);
  //   @(negedge vif.aclk);
  //   txn.rdata = vif.rdata;
  //   txn.rresp = vif.rresp;
  // end
endtask

virtual task run_phase(uvm_phase phase);
  axi_lite_seq_item txn;
  super.run_phase(phase);
  `uvm_info(get_name(), "run_phase", UVM_LOW)
  forever begin
    txn = axi_lite_seq_item::type_id::create("txn", this);
    // fork
      read_address(txn);
    //   read_data(txn);
    // join
    mon_ap.write(txn);
  end
endtask

endclass

`endif
