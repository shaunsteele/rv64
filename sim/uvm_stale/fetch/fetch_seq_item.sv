// fetch_seq_item.sv

`ifndef __FETCH_SEQ_ITEM
`define __FETCH_SEQ_ITEM

class fetch_seq_item # (
  int XLEN = 64
) extends uvm_object;

`uvm_object_utils(fetch_seq_item#(XLEN))

rand bit            jump_valid;
rand bit [XLEN-1:0] jump_addr;
rand bit            branch_valid;
rand bit [XLEN-1:0] branch_addr;
rand bit            halt_n;
bit      [XLEN-1:0] pc;

function new(string name="fetch_seq_item");
  super.new(name);
  `uvm_info("FETCH SEQ ITEM", "constructor", UVM_LOW)
endfunction

function string convert2string();
  string s;
  s = super.convert2string();
  $sformat(s,"%shalt_n: %0b\tjump_valid: %0b\tjump_addr: 0x%016x\tbranch_valid: %0b\tbranch_addr: 0x%016x\tpc: 0x%016x",s,halt_n,jump_valid,jump_addr,branch_valid,branch_addr,pc);
  return s;
endfunction

function void do_print(uvm_printer printer);
  printer.m_string = convert2string();
endfunction

endclass

`endif
