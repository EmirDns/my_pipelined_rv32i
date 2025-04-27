`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 01:01:25 AM
// Design Name: 
// Module Name: ALU_decoder
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


module ALU_decoder(
    input logic [1:0] ALUOp,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [11:0] imm12,
    input logic [6:0] op,
    output logic [3:0] ALUControl
    );
    
    always_comb begin
    case(ALUOp)
        2'b00: ALUControl = 4'b0000; // store or load or lui instructions (ADD)
        2'b01: ALUControl = 4'b0001; // SUB (for beq and bne)
        2'b10: begin
            case(funct3)
                3'b000: 
                    ALUControl = ({op[5], funct7[5]} == 2'b11) ? 4'b0001 : 4'b0000;
                3'b010: ALUControl = 4'b0101;  // SLT
                3'b001: begin
                    case(imm12)
                        12'b011000000000: ALUControl = 4'b0111; // CLZ
                        12'b011000000001: ALUControl = 4'b0110; // CTZ
                        12'b011000000010: ALUControl = 4'b1000; // CPOP       
                    endcase

                end
                   
                3'b110: ALUControl = 4'b0011;  // OR
                3'b111: ALUControl = 4'b0010;  // AND
                default: ALUControl = 4'b0000; // Default ADD
            endcase
        end
        default: ALUControl = 4'b0000;         // Default ADD
    endcase
end
    
endmodule
