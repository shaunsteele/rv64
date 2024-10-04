// axi_lite_pkg.sv

`include "uvm_macros.svh"

package axi_lite_pkg;

import uvm_pkg::*;

`include "axi_lite_if_base.sv"
`include "axi_lite_if_class.sv"

`include "axi_lite_seq_item.sv"
`include "axi_lite_cfg.sv"
`include "axi_lite_monitor.sv"
`include "axi_lite_agent.sv"

endpackage
