
# project directory
REPO_DIR = /home/shaun/repos/rv64
UVM_DIR := /home/shaun/sw/uvm/1800.2-2020.3.1/src


# source folders
RTL_DIR := $(REPO_DIR)/rtl
SIM_DIR := $(REPO_DIR)/sim/store_unit

# uvm_package
SRCS += $(UVM_DIR)/uvm_pkg.sv
INCLUDE_ARGS += -I$(UVM_DIR)

# test
SRCS += $(SIM_DIR)/store_base_test.sv

# dut rtl
SRCS += $(RTL_DIR)/store_unit.sv

# testbench top
SRCS += $(SIM_DIR)/top.sv

INCLUDE_ARGS += -I$(REPO_DIR)/sim/axi_lite_uvm

all:
	verilator -sv -binary --timing --trace --trace-structs $(INCLUDE_ARGS) $(SRCS)
