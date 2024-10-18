// decode_sequence.sv

`ifndef __DECODE_SEQUENCE
`define __DECODE_SEQUENCE

class decode_sequence extends uvm_sequence#(decode_seq_item);

`uvm_object_utils(decode_sequence)

function new(string name="decode_sequence");
  super.new(name);
  `uvm_info("SEQ","constructor",UVM_LOW)
endfunction

task body();
  decode_seq_item txn;
  txn = decode_seq_item::type_id::create("txn");
  start_item(txn);
  txn.randomize();
  finish_item(txn);
endtask

endclass

`endif
