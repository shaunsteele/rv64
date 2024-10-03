// s_axi_lite_monitor.sv

`ifndef __S_AXI_LITE_MONITOR
`define __S_AXI_LITE_MONITOR

class s_axi_lite_monitor extends uvm_monitor;

`uvm_component_utils(s_axi_lite_monitor)

virtual axi_lite_if vif;

axi_lite_cfg cfg;

uvm_analysis_port #(axi_lite_seq_item)  mon_ap;

function new(string name="s_axi_lite_monitor", uvm_component parent);
  super.new(name, parent);
  `uvm_info("S AXI LITE MONITOR", "constructor", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("S AXI LITE MONITOR", "build_phase", UVM_LOW)
  if (!uvm_config_db #(virtual axi_lite_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal("S AXI LITE MONITOR", "Failed to get vif instance")
  end
  if (!uvm_config_db#(axi_lite_cfg)::get(this,"*","axi_lite_cfg",cfg)) begin
    `uvm_fatal("S AXI LITE MONITOR", "Failed to get configuration")
  end
endfunction

virtual task read_address(ref axi_lite_seq_item txn);
  if (cfg.aren) begin
    wait (vif.arvalid && vif.arready);
    @(negedge vif.aclk);
    txn.araddr = vif.araddr;
    txn.arprot = vif.arprot;
  end
endtask

virtual task read_data(ref axi_lite_seq_item txn);
  if (cfg.ren) begin
    wait (vif.rvalid && vif.rready);
    @(negedge vif.aclk);
    txn.rdata = vif.rdata;
    txn.rresp = vif.rresp;
  end
endtask

virtual task run_phase(uvm_phase phase);
  axi_lite_seq_item txn;
  super.run_phase(phase);
  `uvm_info("S AXI LITE MONITOR", "run_phase", UVM_LOW)
  forever begin
    txn = axi_lite_seq_item::type_id::create("txn", this);
    fork
      read_address(txn);
      read_data(txn);
    join
    mon_ap.write(txn);
  end
endtask

endclass

`endif
