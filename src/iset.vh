// iset.vh
// Common helper logic

// reg_write_fn
// Return 1 when the combination of instruction set and opcode
// writes to the general purpose register file.  Modules that
// require this function should define `DEFINE_REG_WRITE_FN` before
// including this header inside their scope.
`ifdef DEFINE_REG_WRITE_FN
function automatic reg_write_fn;
    input [7:0] opc;
    begin
        reg_write_fn = (opc == `OPC_R_MOV)  ||
                       (opc == `OPC_I_MOVi) ||
                       (opc == `OPC_IS_MOVis) ||
                       (opc == `OPC_R_ADD)  ||
                       (opc == `OPC_I_ADDi) ||
                       (opc == `OPC_RS_ADDs) ||
                       (opc == `OPC_IS_ADDis)||
                       (opc == `OPC_R_SUB)  ||
                       (opc == `OPC_I_SUBi) ||
                       (opc == `OPC_RS_SUBs) ||
                       (opc == `OPC_IS_SUBis)||
                       (opc == `OPC_R_NOT)  ||
                       (opc == `OPC_R_AND)  ||
                       (opc == `OPC_I_ANDi) ||
                       (opc == `OPC_R_OR)   ||
                       (opc == `OPC_I_ORi)  ||
                       (opc == `OPC_R_XOR)  ||
                       (opc == `OPC_I_XORi) ||
                       (opc == `OPC_R_SL)   ||
                       (opc == `OPC_I_SLi)  ||
                       (opc == `OPC_R_SR)   ||
                       (opc == `OPC_I_SRi)  ||
                       (opc == `OPC_RS_SRs) ||
                       (opc == `OPC_IS_SRis)||
                       (opc == `OPC_R_LD)   ||
                       (opc == `OPC_I_LDi);
    end
endfunction
`endif // DEFINE_REG_WRITE_FN

// reg_src_read_fn
// Return 1 when the source general purpose register is read by the
// given instruction. Modules should define `DEFINE_REG_SRC_READ_FN`
// before including this header.
`ifdef DEFINE_REG_SRC_READ_FN
function automatic reg_src_read_fn;
    input [7:0] opc;
    begin
        reg_src_read_fn = (opc == `OPC_R_MOV)  ||
                          (opc == `OPC_R_ADD)  ||
                          (opc == `OPC_RS_ADDs) ||
                          (opc == `OPC_R_SUB)  ||
                          (opc == `OPC_RS_SUBs) ||
                          (opc == `OPC_R_CMP)  ||
                          (opc == `OPC_RS_CMPs) ||
                          (opc == `OPC_R_AND)  ||
                          (opc == `OPC_R_OR)   ||
                          (opc == `OPC_R_XOR)  ||
                          (opc == `OPC_R_SL)   ||
                          (opc == `OPC_R_SR)   ||
                          (opc == `OPC_RS_SRs) ||
                          (opc == `OPC_R_LD)   ||
                          (opc == `OPC_I_LDi)  ||
                          (opc == `OPC_R_ST);
    end
endfunction
`endif // DEFINE_REG_SRC_READ_FN

// reg_tgt_read_fn
// Return 1 when the target general purpose register is read by the
// given instruction. Modules should define `DEFINE_REG_TGT_READ_FN`
// before including this header.
`ifdef DEFINE_REG_TGT_READ_FN
function automatic reg_tgt_read_fn;
    input [7:0] opc;
    begin
        reg_tgt_read_fn = (opc == `OPC_R_ADD)  ||
                          (opc == `OPC_I_ADDi) ||
                          (opc == `OPC_RS_ADDs) ||
                          (opc == `OPC_IS_ADDis)||
                          (opc == `OPC_R_SUB)  ||
                          (opc == `OPC_I_SUBi) ||
                          (opc == `OPC_RS_SUBs) ||
                          (opc == `OPC_IS_SUBis)||
                          (opc == `OPC_R_CMP)  ||
                          (opc == `OPC_I_CMPi) ||
                          (opc == `OPC_RS_CMPs) ||
                          (opc == `OPC_IS_CMPis)||
                          (opc == `OPC_R_NOT)  ||
                          (opc == `OPC_R_AND)  ||
                          (opc == `OPC_I_ANDi) ||
                          (opc == `OPC_R_OR)   ||
                          (opc == `OPC_I_ORi)  ||
                          (opc == `OPC_R_XOR)  ||
                          (opc == `OPC_I_XORi) ||
                          (opc == `OPC_R_SL)   ||
                          (opc == `OPC_I_SLi)  ||
                          (opc == `OPC_R_SR)   ||
                          (opc == `OPC_I_SRi)  ||
                          (opc == `OPC_RS_SRs) ||
                          (opc == `OPC_IS_SRis)||
                          (opc == `OPC_R_BCC)  ||
                          (opc == `OPC_R_ST)   ||
                          (opc == `OPC_I_STi);
    end
endfunction
`endif // DEFINE_REG_TGT_READ_FN
