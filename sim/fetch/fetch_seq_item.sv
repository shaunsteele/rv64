// fetch_seq_item.sv

`ifndef __FETCH_SEQ_ITEM
`define __FETCH_SEQ_ITEM

class fetch_seq_item # (
  int XLEN = 64
) extends uvm_object;

`uvm_object_utils(fetch_seq_item#(XLEN))

rand bit            halt_n;
rand bit            jump_valid;
rand bit [XLEN-1:0] jump_addr;
rand bit            branch_valid;
rand bit [XLEN-1:0] branch_addr;
bit                 pc_valid;
bit      [XLEN-1:0] pc;
bit                 pc_addr_misalign;

function new(string name="fetch_seq_item");
  super.new(name);
  `uvm_info("FETCH SEQ ITEM", "constructor", UVM_LOW)
endfunction

function string convert2string();
  string s;
  s = super.convert2string();
  $sformat(s,"%shalt_n: %0b\tjump_valid: %0b\tjump_addr: 0x%016x\tbranch_valid: %0b\tbranch_addr: 0x%016x\t",s,halt_n,jump_valid,jump_addr,branch_valid,branch_addr);
  $sformat(s,"%spc_valid: %0b\tpc: 0x%016x\tpc_addr_misalign: %0b",s,pc_valid,pc,pc_addr_misalign);
  return s;
endfunction

function void do_print(uvm_printer printer);
  printer.m_string = convert2string();
endfunction

endclass

`endif
