// axi_lite_seq_item.sv

`ifndef __AXI_LITE_SEQ_ITEM
`define __AXI_LITE_SEQ_ITEM

class axi_lite_seq_item # (
  int ALEN = 64,
  int DLEN = 64
) extends uvm_sequence_item;

`uvm_object_utils(axi_lite_seq_item#(ALEN,DLEN))

rand int ardelay;
rand bit arvalid;
rand bit arready;
rand bit [ALEN-1:0] araddr;
rand bit [2:0]  arprot;

// rand bit [DLEN-1:0] rdata;
// rand bit [1:0]  rresp;

function new(string name="axi_lite_seq_item");
  super.new(name);
  `uvm_info("AXI LITE SEQ ITEM", "constructor", UVM_LOW)
endfunction

function string convert2string();
  string s;
  s = super.convert2string();
  $sformat(s,"%sardelay: %0d\taraddr: 0x%08h\tarprot: 0b%03b", s, this.ardelay, this.araddr, this.arprot);
  // $sformat(s,"%srdata: 0x%08h\trresp: 0b%02b", s, this.rdata, rresp);
  return s;
endfunction

function void do_print(uvm_printer printer);
  printer.m_string = convert2string();
endfunction

endclass

`endif
