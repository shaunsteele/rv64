
REPO_DIR := /home/shaun/repos/rv64

# project folders
RTL_DIR := $(REPO_DIR)/rtl
SIM_DIR := $(REPO_DIR)/sim
TCL_DIR := $(REPO_DIR)/tcl

SRCS += $(SIM_DIR)/decode/decode_if.sv
SRCS += $(SIM_DIR)/exception/exception_if.sv
SRCS += $(SIM_DIR)/axi_lite_uvm/axi_lite_if.sv

# rtl
SRCS += $(RTL_DIR)/decode.sv

# testbench
SRCS += $(SIM_DIR)/decode/decode_pkg.sv
SRCS += $(SIM_DIR)/decode/decode_seq_item.sv
SRCS += $(SIM_DIR)/decode/decode_sequence.sv
SRCS += $(SIM_DIR)/decode/decode_driver.sv
SRCS += $(SIM_DIR)/decode/decode_monitor.sv
SRCS += $(SIM_DIR)/decode/decode_agent.sv
SRCS += $(SIM_DIR)/decode/decode_env.sv
SRCS += $(SIM_DIR)/decode/decode_test.sv

# testbench top
SRCS += $(SIM_DIR)/decode/tb_decode.sv

TOP = tb_decode

INCLUDES :=
DEFINES := 

COMP_ARGS += --incr --relax
COMP_ARGS += -L uvm

ELAB_ARGS += -L uvm
# ELAB_ARGS += -v 1

SIM_ARGS += -testplusarg UVM_VERBOSITY=UVM_LOW
SIM_ARGS += -testplusarg UVM_CONFIG_TRACE

.PHONY: simulate
simulate: $(TOP)_snapshot.wdb

.PHONY: elaborate
elaborate: .elab.timestamp

.PHONY: compile
compile: .comp.timestamp

.PHONY: waves
waves:
	gtkwave dump.vcd

$(TOP)_snapshot.wdb: .elab.timestamp
	@echo
	@echo "### SIMULATING ###"
	xsim $(TOP)_snapshot -tclbatch $(TCL_DIR)/xsim_cfg.tcl $(SIM_ARGS)

.elab.timestamp: .comp.timestamp
	@echo
	@echo "### ELABORATING ###"
	xelab -debug all $(ELAB_ARGS) -top $(TOP) -snapshot $(TOP)_snapshot
	touch .elab.timestamp

.comp.timestamp: $(SRCS)
	@echo
	@echo "### COMPILING ###"
	xvlog $(COMP_ARGS) $(INCLUDES) $(DEFINES) --sv $(SRCS)
	touch .comp.timestamp

# LINT_RULES += --rules=-line-length
LINT_ARGS += 

.PHONY: lint
lint:
	verilator --lint-only -Wall $(SRCS)
# verible-verilog-lint $(SRCS) $(LINT_RULES)

.PHONY: clean
clean:
	rm -rf *.jou *.log *.pb *.wdb xsim.dir
	rm -rf .*.timestamp
