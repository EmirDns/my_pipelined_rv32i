`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 02:20:12 AM
// Design Name: 
// Module Name: ControlUnit_Top
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

// `include "ALU_decoder.sv"
// `include "main_decoder.sv"

module ControlUnit_Top(
    input logic [6:0] op,
    input logic [6:0] funct7,
    input logic [2:0] funct3,
    input logic [11:0] imm12,
    output logic RegWrite, ALUSrc, MemWrite,
    output logic [1:0] ImmSrc,
    output logic [1:0] ResultSrc,
    output logic [3:0] ALUControl,
    output logic Branch,
    output logic Jump
    );
    
    logic [1:0] ALUOp;
    
    main_decoder main_decoder(
        .op(op),
        .funct3(funct3),
        .funct7(funct7),
        .imm12(imm12),
        .Branch(Branch),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .ALUOp(ALUOp),
        .ImmSrc(ImmSrc),
        .Jump(Jump) 
    );
    
    ALU_decoder ALU_decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .imm12(imm12),
        .op(op),
        .ALUControl(ALUControl)
    );

    
endmodule
