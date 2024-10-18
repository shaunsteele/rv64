// decode_driver.sv

`ifndef __DECODE_DRIVER
`define __DECODE_DRIVER

class decode_driver extends uvm_driver #(decode_seq_item);

`uvm_component_utils(decode_driver)

virtual decode_if#(64) vif_d;
virtual exception_if vif_e;
virtual axi_lite_if#(.ALEN(64),.DLEN(32)) vif_im;

function new(string name="decode_driver", uvm_component parent);
  super.new(name, parent);
  `uvm_info("DRV","constructor",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db #(virtual decode_if#(64))::get(null,"*","vif_d",vif_d)) begin
    `uvm_fatal("DRV","failed to get vif_d")
  end
  if (!uvm_config_db #(virtual exception_if)::get(null,"*","vif_e",vif_e)) begin
    `uvm_fatal("DRV","failed to get vif_e")
  end
  if (!uvm_config_db #(virtual axi_lite_if#(.ALEN(64),.DLEN(32)))::get(null,"*","vif_im",vif_im)) begin
    `uvm_fatal("DRV","failed to get vif_im")
  end
  `uvm_info("DRV","build_phase",UVM_LOW)
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("DRV","connect_phase",UVM_LOW)
endfunction

task configure_phase(uvm_phase phase);
  super.configure_phase(phase);
  `uvm_info("DRV","configure_phase",UVM_LOW)
endtask

task run_phase(uvm_phase phase);
  decode_seq_item txn;
  super.run_phase(phase);
  `uvm_info("DRV","run_phase",UVM_LOW)
  forever begin
    txn = decode_seq_item::type_id::create("txn");
    seq_item_port.get_next_item(txn);
    do_txn(txn);
    seq_item_port.item_done();
  end
endtask

task do_txn(ref decode_seq_item txn);
  @(negedge vif_d.clk);
  vif_im.arvalid <= txn.im_arvalid;
  vif_im.araddr <= txn.im_araddr;
  vif_im.rvalid <= txn.im_rvalid;
  vif_im.rresp <= txn.im_rresp;
  vif_d.dm_ready <= txn.dm_ready;
  vif_d.rf_wvalid <= txn.rf_wvalid;
  vif_d.rf_waddr <= txn.rf_waddr;
  vif_d.rf_wdata <= txn.rf_wdata;
endtask

endclass

`endif
