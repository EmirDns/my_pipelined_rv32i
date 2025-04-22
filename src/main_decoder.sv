`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 12:59:41 AM
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
    input logic [6:0] op,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [11:0] imm12,
    output logic Branch,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [1:0] ResultSrc,
    output logic [1:0] ALUOp,
    output logic [1:0] ImmSrc,
    output logic Jump
    );
    
    always_comb begin
    
        // Branch: Set high for branch (B-type) instructions
        Branch = (op == 7'b1100011);  
    
        // MemWrite: Set high for store instructions
        MemWrite = (op == 7'b0100011);
    
        // ALUSrc: Set high for load or store or I-type (for zbb set low but for addi etc. set high)
        case(op)
            7'b0000011: ALUSrc = 1'b1;
            7'b0100011: ALUSrc = 1'b1;
            7'b0010011: begin
                if(((imm12 == 12'b011000000001) || (imm12 == 12'b011000000000) || (imm12 == 12'b011000000010)) && (funct3 == 3'b001))
                    ALUSrc = 1'b0; // For zbb  
                
                else   
                    ALUSrc = 1'b1; // For I-type
            end
            default ALUSrc = 1'b0;
        endcase

    
        // RegWrite: Set high for load or R-type(ADD, SUB ...) or I-type or J-type
        RegWrite = (op == 7'b0000011 || op == 7'b0110011 || op == 7'b0010011 || op == 7'b1101111);
    
        // ResultSrc: Set high for load instructions
        case(op)
            7'b0110011: ResultSrc = 2'b00; // For R-type
            7'b0010011: ResultSrc = 2'b00; // For I-type
            7'b0000011: ResultSrc = 2'b01; // For lw
            7'b1101111: ResultSrc = 2'b10; // For J-type
            default:    ResultSrc = 2'b00;
        endcase
    
        // ALUOp: Set operation based on opcode
        case(op)
            7'b0110011: ALUOp = 2'b10;  // R-type (arithmetic)
            7'b0010011: ALUOp = 2'b10;  // I-type 
            7'b1100011: ALUOp = 2'b01;  // for beq and bne
            default:    ALUOp = 2'b00;  // Default (load or store instructions)
        endcase
    
        case(op)
            7'b0100011: ImmSrc = 2'b01;  // Store
            7'b1100011: ImmSrc = 2'b10;  // Branch (B-type)
            7'b1101111: ImmSrc = 2'b11;  // J-type
            default:    ImmSrc = 2'b00;  // Default (R-type, I-type or load instructions)
        endcase

        Jump = (op == 7'b1101111);

    end
    
    
endmodule
