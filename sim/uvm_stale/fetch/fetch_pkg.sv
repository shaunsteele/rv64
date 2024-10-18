// fetch_pkg.sv

`include "uvm_macros.svh"

package fetch_pkg;

import uvm_pkg::*;
import axi_lite_pkg::*;

`include "fetch_seq_item.sv"

`include "fetch_agent.sv"
`include "fetch_env.sv"
`include "fetch_test_base.sv"

endpackage
