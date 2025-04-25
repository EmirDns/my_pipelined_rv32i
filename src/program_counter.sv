`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 04:56:15 PM
// Design Name: 
// Module Name: program_counter
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


module program_counter(
    input logic clk,
    input logic rst_n,
    input logic enable, 
    input logic [31:0] PC_next,
    output logic [31:0] PC 
    );

    always_ff @(posedge clk) begin
    if (!rst_n)
        PC <= 32'h00000000;               // During reset
    else if (PC == 32'h00000000)
        PC <= 32'h80000000;               // First cycle after reset
    else if (enable)
        PC <= PC_next;                    // Normal PC update
end

endmodule
