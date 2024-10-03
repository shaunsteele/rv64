// axi_lite_seq_item.sv

`ifndef __AXI_LITE_SEQ_ITEM
`define __AXI_LITE_SEQ_ITEM

class axi_lite_seq_item extends uvm_sequence_item;

`uvm_object_utils(axi_lite_seq_item)

local bit [64:0] araddr_mask;
rand bit [64:0] araddr;
rand bit [2:0]  arprot;

local bit [64:0] rdata_mask;
rand bit [64:0] rdata;
rand bit [1:0]  rresp;

function new(string name="axi_lite_seq_item");
  super.new(name);
  `uvm_info("AXI LITE SEQ ITEM", "constructor", UVM_LOW)
  this.araddr_mask = {(64){1'b1}};
endfunction

function void set_alen(int alen);
  if (alen != 64 || alen != 32) begin
    `uvm_fatal("AXI LITE SEQ ITEM", "ALEN must be 32 or 64")
  end else if (alen == 32) begin
    this.araddr_mask = {32'b0, {(32){1'b1}}};
  end
endfunction

function void set_dlen(int dlen);
  if (dlen != 64 || dlen != 32) begin
    `uvm_fatal("AXI LITE SEQ ITEM", "DLEN must be 32 or 64")
  end else if (dlen == 32) begin
    this.rdata_mask = {32'b0, {(32){1'b1}}};
  end
endfunction

function void get_araddr(output bit [64:0] araddr_out);
  araddr_out = this.araddr & this.araddr_mask;
endfunction

function void get_rdata(output bit [64:0] rdata_out);
  rdata_out = this.rdata & this.rdata_mask;
endfunction

function string convert2string();
  string s;
  s = super.convert2string();
  $sformat(s,"%saraddr: 0x%08h\tarprot: 0b%03b", s, this.araddr & this.araddr_mask, this.arprot);
  $sformat(s,"%srdata: 0x%08h\trresp: 0b%02b", s, this.rdata & this.rdata_mask, rresp);
  return s;
endfunction

endclass

`endif
