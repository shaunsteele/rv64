// axi_lite_slave_sequence.sv

`ifndef __AXI_LITE_SLAVE_SEQUENCE
`define __AXI_LITE_SLAVE_SEQUENCE

class axi_lite_slave_sequence # (
  int ALEN = 64,
  int DLEN = 64
) extends uvm_sequence # (axi_lite_seq_item#(ALEN,DLEN));

`uvm_object_utils(axi_lite_slave_sequence#(ALEN,DLEN))

axi_lite_seq_item#(ALEN,DLEN) req;
axi_lite_seq_item#(ALEN,DLEN) rsp;

function new(string name="axi_lite_slave_sequence");
  super.new(name);
endfunction

virtual task body();
  
endtask


endclass

`endif
