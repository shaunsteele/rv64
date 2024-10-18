Execution Notes

ALU
Instructions:
 - integer computation
 - AUIPC
 - JALR return address
 - Branch checking
 - Load address calculation
 - Store address calculation

Execution Input Data
 - immediate
 - rf src1
 - rf src2
 - destination register

Execution Control Signals
 - alu enable
  - integer comp
  - auipc
  - jalr
  - branch
  - load
  - store
 - alu input select
  - immediate or src2 (intcomp imm, jalr, load, store)
  - pc or src1 (auipc)
  - alu op
 - passthrough data
  - destination register (not store)
  - rd valid (not store)
  - src2 (store)
  - funct3 (load and store)

Memory Stage Signals
 - 