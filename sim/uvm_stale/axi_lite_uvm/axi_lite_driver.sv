// axi_lite_driver.sv

`ifndef __AXI_LITE_DRIVER
`define __AXI_LITE_DRIVER

class axi_lite_driver # (
  int ALEN = 64,
  int DLEN = 64,
  string IF_NAME = "axi"
) extends uvm_driver;

`uvm_component_utils(axi_lite_driver#(ALEN,DLEN))

virtual axi_lite_if#(ALEN,DLEN) vif;

function new(string name="axi_lite_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual axi_lite_if#(ALEN,DLEN))::get(null,"*",IF_NAME,vif)) begin
    `uvm_fatal(get_name(), "Failed to get interface")
  end
endfunction

task run_phase(uvm_phase phase);
  axi_lite_seq_item#(ALEN,DLEN) txn;
  super.run_phase(phase);
  `uvm_info(get_name(), "run_phase", UVM_LOW)
  forever begin
    txn = axi_lite_seq_item#(ALEN,DLEN)::type_id::create("txn");
    // seq_item_port stuff
  end
endtask

endclass

`endif
