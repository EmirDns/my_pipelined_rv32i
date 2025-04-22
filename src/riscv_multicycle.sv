`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 02:49:40 AM
// Design Name: 
// Module Name: riscv_singlecycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// `include "program_counter.sv"
// `include "instruction_memory.sv"
// `include "register_file.sv"
// `include "Sign_Extend.sv"
// `include "ALU.sv"
// `include "ControlUnit_Top.sv"
// `include "data_memory.sv"
// `include "PC_Adder.sv"
// `include "MUX.sv"
//`include "riscv_pkg.sv"

module riscv_multicycle
    import riscv_pkg::*;
#(  // Parameter declaration should be here, within #(
        parameter DMemInitFile  = "src/dmem.mem",  // Data memory initialization file
        parameter IMemInitFile  = "test/branch_test.mem"  // Instruction memory initialization file
    )  (
    input  logic             clk_i,       // system clock
    input  logic             rstn_i,      // system reset
    input  logic  [XLEN-1:0] addr_i,      // memory adddres input for reading
    output logic  [XLEN-1:0] data_o,      // memory data output for reading
    output logic             update_o,    // retire signal
    output logic  [XLEN-1:0] pc_o,        // retired program counter
    output logic  [XLEN-1:0] instr_o,     // retired instruction
    output logic  [     4:0] reg_addr_o,  // retired register address
    output logic  [XLEN-1:0] reg_data_o,  // retired register data
    output logic  [XLEN-1:0] mem_addr_o,  // retired memory address
    output logic  [XLEN-1:0] mem_data_o,  // retired memory data
    output logic             mem_wrt_o   // retired memory write enable signal
);
    

    // Fetch stage variables
    logic [31:0] nextPC_f, PCplus4_f, instr_f;

    // Decode stage variables
    logic [31:0] instr_d, pc_d, PCplus_d, RD1_d, RD2_d, Imm_Ext_d;
    logic [4:0] RS1_d, RS2_d, RD_d;
    logic [3:0] ALUControl_d;
    logic [1:0] ResultSrc_d, ImmSrc_d;
    logic RegWrite_d, ALU_Src_d, MemWrite_d, Branch_d, Jump_d;

    // Execute stage variables
    logic [31:0] RD1_e, RD2_e, pc_e, Imm_Ext_e, PCplus4_e, WriteData_e, SrcA_e, SrcB_e, ALUResult_e, PCTarget_e;
    logic [4:0] RS1_e, RS2_e, RD_e;
    logic [3:0] ALUControl_e;
    logic [1:0] ResultSrc_e;
    logic RegWrite_e, ALU_Src_e, MemWrite_e, Branch_e, Jump_e, Zero_e, PCSrc_e;

    // Memory stage variables
    logic [31:0] ALUResult_m, WriteData_m, PCplus4_m, ReadData_m;
    logic [4:0] RD_m;
    logic [1:0] ResultSrc_m;
    logic RegWrite_m, MemWrite_m;

    // Write-back stage variables
    logic [31:0] ALUResult_w, ReadData_w, PCplus4_w, Result_w;
    logic [4:0] RD_w;
    logic [1:0] ResultSrc_w;
    logic RegWrite_w;

    // Hazard unit variables
    logic [1:0] ForwardA_e, ForwardB_e;
    logic Stall_f, Stall_d, Flush_e, Flush_d;

    MUX nextPC_MUX(
        .A(PCplus4_f),
        .B(PCTarget_e),
        .S(PCSrc_e), 
        .C(nextPC_f)
    );

    program_counter program_counter(
        .clk(clk_i),
        .rst_n(rstn_i),
        .enable(!Stall_f),
        .PC_next(nextPC_f),
        .PC(pc_o) 
    );
    
    PC_Adder PC_Adder(
        .a(pc_o),
        .b(32'd4),
        .c(PCplus4_f)
    );
    
    instruction_memory instruction_memory(
        .rst_n(rstn_i),
        .addr(pc_o),
        .instruction(instr_f)
    );
    
    f_d_pipeline f_d_pipeline(
        .clk(clk_i),
        .rst_n(rstn_i),
        .clear(Flush_d),  
        .enable(!Stall_d), 
        .instr_f(instr_f),
        .pc_f(pc_o),
        .pcplus4_f(PCplus4_f),

        .instr_d(instr_d),
        .pc_d(pc_d),
        .pcplus4_d(PCplus_d)
    );

    assign RS1_d = instr_d[19:15];
    assign RS2_d = instr_d[24:20];
    assign RD_d  = instr_d[11:7]; 

    register_file register_file(
        .clk(clk_i),
        .rst_n(rstn_i),
        .rs1(RS1_d),
        .rs2(RS2_d),
        .rd(RD_w),
        .write_data(Result_w), 
        .write_enable(RegWrite_w), 
        .read_data1(RD1_d),
        .read_data2(RD2_d)     
    );

    

    ControlUnit_Top ControlUnit_d(
        .op(instr_d[6:0]),
        .funct7(instr_d[31:25]),
        .funct3(instr_d[14:12]),
        .imm12(instr_d[31:20]),
        .RegWrite(RegWrite_d),
        .ALUSrc(ALU_Src_d),
        .MemWrite(MemWrite_d),
        .ResultSrc(ResultSrc_d),
        .ImmSrc(ImmSrc_d),
        .ALUControl(ALUControl_d),
        .Branch(Branch_d),
        .Jump(Jump_d)
    );
    
    Sign_Extend Sign_Extend(
        .ImmSrc(ImmSrc_d),
        .Instr(instr_d),
        .ExtImm(Imm_Ext_d)
    );

    d_e_pipeline d_e_pipeline(
        .clk(clk_i),
        .rst_n(rstn_i),
        .clear(Flush_e),
        .enable(1'b1),
        .rd1_d(RD1_d),
        .rd2_d(RD2_d),
        .pc_d(pc_d),
        .rs1_d(RS1_d),
        .rs2_d(RS2_d),
        .rd_d(RD_d),
        .ext_imm_d(Imm_Ext_d),
        .pcplus4_d(PCplus_d),
        .RegWrite_d(RegWrite_d),
        .ResultSrc_d(ResultSrc_d),
        .MemWrite_d(MemWrite_d),
        .Jump_d(Jump_d),
        .Branch_d(Branch_d),
        .ALUControl_d(ALUControl_d),
        .ALUSrc_d(ALU_Src_d),


        .rd1_e(RD1_e),
        .rd2_e(RD2_e),
        .pc_e(pc_e),
        .rs1_e(RS1_e),
        .rs2_e(RS2_e),
        .rd_e(RD_e),
        .ext_imm_e(Imm_Ext_e),
        .pcplus4_e(PCplus4_e),
        .RegWrite_e(RegWrite_e),
        .ResultSrc_e(ResultSrc_e),
        .MemWrite_e(MemWrite_e),
        .Jump_e(Jump_e),
        .Branch_e(Branch_e),
        .ALUControl_e(ALUControl_e),
        .ALUSrc_e(ALU_Src_e)
    ); 

    state3_MUX srcB_hazard_mux(
        .A(RD2_e),
        .B(Result_w),
        .C(ALUResult_m),
        .S(ForwardB_e),
        .R(WriteData_e)
    );

    MUX mux_register_to_ALU(
        .A(WriteData_e), 
        .B(Imm_Ext_e),
        .S(ALU_Src_e),
        .C(SrcB_e)
    );

    state3_MUX srcA_hazard_mux(
        .A(RD1_e),
        .B(Result_w),
        .C(ALUResult_m),
        .S(ForwardA_e),
        .R(SrcA_e)
    );
    
    ALU ALU(
        .A(SrcA_e), 
        .B(SrcB_e),
        .ALU_control(ALUControl_e),
        .result(ALUResult_e),
        .Zero(Zero_e)
    );

    assign PCSrc_e = ((Zero_e & Branch_e) | (Jump_e));

    PC_Adder Target_PC_Adder_e(
        .a(pc_e),
        .b(Imm_Ext_e),
        .c(PCTarget_e)
    );


    e_m_pipeline e_m_pipeline(
        .clk(clk_i),
        .rst_n(rstn_i),
        .clear(1'b0),  
        .enable(1'b1), 
        .ALUResult_e(ALUResult_e),
        .WriteData_e(WriteData_e), // ALU'nun SrcA'sı. Hazard MUX'la ilgili
        .rd_e(RD_e),
        .pcplus4_e(PCplus4_e),
        .RegWrite_e(RegWrite_e),
        .ResultSrc_e(ResultSrc_e),
        .MemWrite_e(MemWrite_e),

        .ALUResult_m(ALUResult_m),
        .WriteData_m(WriteData_m), //WriteData_e'nin devamı
        .rd_m(RD_m),
        .pcplus4_m(PCplus4_m),
        .RegWrite_m(RegWrite_m),
        .ResultSrc_m(ResultSrc_m),
        .MemWrite_m(MemWrite_m)
    );
    
    
    data_memory data_memory(
        .clk(clk_i),
        .rst_n(rstn_i),
        .A(ALUResult_m),
        .write_data(WriteData_m),
        .write_enable(MemWrite_m),
        .read_data(ReadData_m)
    );

    m_w_pipeline m_w_pipeline(
        .clk(clk_i),
        .rst_n(rstn_i),
        .clear(1'b0),  
        .enable(1'b1), 
        .ALUResult_m(ALUResult_m),
        .ReadData_m(ReadData_m),
        .rd_m(RD_m),
        .pcplus4_m(PCplus4_m),
        .RegWrite_m(RegWrite_m),
        .ResultSrc_m(ResultSrc_m),
        
        .ALUResult_w(ALUResult_w),
        .ReadData_w(ReadData_w),
        .rd_w(RD_w),
        .pcplus4_w(PCplus4_w),
        .RegWrite_w(RegWrite_w),
        .ResultSrc_w(ResultSrc_w)
    );

    state3_MUX mux_dmemory_to_registerfile(
        .A(ALUResult_w),
        .B(ReadData_w),
        .C(PCplus4_w),
        .S(ResultSrc_w),
        .R(Result_w)
    );
    
    hazard_unit hazard_unit(
        .RS1_e(RS1_e),
        .RS2_e(RS2_e),
        .RD_m(RD_m),
        .RD_w(RD_w),
        .RegWrite_m(RegWrite_m),
        .RegWrite_w(RegWrite_w),
        .RS1_d(RS1_d),
        .RS2_d(RS2_d),
        .RD_e(RD_e),
        .ResultSrc_e(ResultSrc_e),
        .PCSrc_e(PCSrc_e),
        .ForwardA_e(ForwardA_e),
        .ForwardB_e(ForwardB_e),
        .Stall_f(Stall_f),
        .Stall_d(Stall_d),
        .Flush_e(Flush_e), 
        .Flush_d(Flush_d)
    ); 
    
    
    // === Top-Level Output Assignments ===
    assign instr_o     = instr_f;              // Retired instruction
    assign reg_addr_o  = instr_d[11:7];        // Destination register address
    assign reg_data_o  = Result_w;                // Data written to register file
    //assign addr_i      = ALUResult;
    assign mem_addr_o  = ALUResult_m;             // Address accessed in data memory
    assign mem_data_o  = WriteData_m;               // Data written to data memory
    assign data_o      = ReadData_m;              // Simple debug read output (can be enhanced)
    assign update_o    = clk_i;               // Retire signal (simple: high when not in reset)
    assign mem_wrt_o   = MemWrite_m; 

endmodule
