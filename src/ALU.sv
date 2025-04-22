`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2025 12:10:29 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [3:0] ALU_control,
    output logic [31:0] result,
    output logic Zero
    );
    
    integer i;

    localparam [3:0]
        ALU_ADD  = 4'b0000,
        ALU_SUB  = 4'b0001,
        ALU_AND  = 4'b0010,
        ALU_OR   = 4'b0011,
        ALU_XOR  = 4'b0100,
        ALU_SLT  = 4'b0101,
        ALU_CTZ  = 4'b0110,
        ALU_CLZ  = 4'b0111,
        ALU_CPOP = 4'b1000;

    
    always_comb begin
        case(ALU_control)
            ALU_ADD: result = A + B;
            ALU_SUB: result = A - B;
            ALU_AND: result = A & B;
            ALU_OR:  result = A | B;
            ALU_XOR: result = A ^ B; 
            ALU_SLT: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;  
            ALU_CTZ: begin
                result = 32'd32;
                for (i = 0; i < 32; i++) begin
                    if (A[i] == 1'b1 && result == 32)
                        result = i;
                end
            end
            ALU_CLZ: begin
                result = 32'd32;
                for (i = 31; i >= 0; i--) begin
                    if (A[i] == 1'b1 && result == 32)
                        result = 31 - i;
                end
            end
            ALU_CPOP: begin
                result = 32'b0;
                for (i = 0; i < 32; i++) begin
                    if (A[i])
                        result += 1;
                end
            end

            default: result = 32'd0;
        endcase
    

    case (ALU_control)
        ALU_SUB:   Zero = (result == 0);                       // BEQ/BNE
        ALU_SLT:   Zero = ($signed(A) < $signed(B));           // BLT/BGE
        //ALU_SLTU:  Zero = (A < B);                             // BLTU/BGEU
        default:   Zero = 0;
    endcase
    
    end
    
endmodule
