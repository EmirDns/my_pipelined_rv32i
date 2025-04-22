`timescale 1ns / 1ps

module state3_MUX(
    input logic [31:0] A,
    input logic [31:0] B,
    input logic [31:0] C,
    input logic [1:0] S,
    output logic [31:0] R
    );
    
    always_comb begin
        case(S)
            2'b00: R = A;
            2'b01: R = B;
            2'b10: R = C;
        endcase
    end
endmodule
