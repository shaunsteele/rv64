// decode_seq_item.sv

`ifndef __DECODE_SEQ_ITEM
`define __DECODE_SEQ_ITEM

class decode_seq_item extends uvm_sequence_item;

`uvm_object_utils(decode_seq_item)

rand bit          im_arvalid;
rand bit  [63:0]  im_araddr;

rand bit          im_rvalid;
bit               im_rready;
rand bit  [31:0]  im_rdata;
rand bit  [1:0]   im_rresp;

rand bit          dm_ready;

bit               int_comp_r;
bit               int_comp_i;
bit               lui;
bit               auipc;
bit               jal;
bit               jalr;
bit               branch_check;
bit               load;
bit               store;
bit               invalid_opcode;

bit       [4:0]   rd;
bit       [2:0]   funct3;
bit       [6:0]   funct7;
bit       [63:0]  immediate;
bit       [63:0]  int_src1;
bit       [63:0]  int_src2;
bit       [63:0]  pc;

rand bit         rf_wvalid;
rand bit  [4:0]  rf_waddr;
rand bit  [63:0] rf_wdata;

function new(string name="decode_seq_item");
  super.new(name);
endfunction

function string convert2string();
  string s;
  s = super.convert2string();
  $sformat(s,"%sim_rvalid: %0b im_rready: %0b im_rdata: 0x%08x im_rresp: 0b%02b ",s,im_rvalid,im_rready,im_rdata,im_rresp);
  $sformat(s,"%sim_arvalid: %0b im_araddr: 0x%016x dm_ready: %0b ",s,im_arvalid,im_araddr,dm_ready);
  if (int_comp_r)     $sformat(s,"%sint_comp_r ",s,int_comp_r);
  if (int_comp_i)     $sformat(s,"%sint_comp_i ",s,int_comp_i);
  if (lui)            $sformat(s,"%slui ",s,lui);
  if (auipc)          $sformat(s,"%sauipc ",s,auipc);
  if (jal)            $sformat(s,"%sjal ",s,jal);
  if (jalr)           $sformat(s,"%sjalr ",s,jalr);
  if (branch_check)   $sformat(s,"%sbranch_check ",s,branch_check);
  if (load)           $sformat(s,"%sload ",s,load);
  if (store)          $sformat(s,"%sstore ",s,store);
  if (invalid_opcode) $sformat(s,"%sinvalid_opcode ",s,invalid_opcode);
  $sformat(s,"%srd: 0x%02x funct3: 0b%03b funct7: 0b%07b immediate: 0x%016x int_src1: 0x%016x int_src2: 0x%016x pc: 0x%016x ",
    s,rd,funct3,funct7,immediate,int_src1,int_src2,pc);
  $sformat(s,"%srf_wvalid: %b rf_waddr: 0x%02x rf_wdata: 0x%016x",s,rf_wvalid,rf_waddr,rf_wdata);
endfunction

function void do_print(uvm_printer printer);
  printer.m_string = convert2string();
endfunction

endclass

`endif
