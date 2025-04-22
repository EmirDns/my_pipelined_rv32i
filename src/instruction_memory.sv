`timescale 1ns / 1ps
module instruction_memory #(
    parameter MEM_SIZE = 2000,
    parameter IMemInitFile = "test/branch_test.mem"
)(
    input logic [31:0] addr,
    input logic rst_n,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:MEM_SIZE-1];

    initial begin
        $readmemh(IMemInitFile, memory);
    end

    always_comb begin
        if (!rst_n)
            instruction = 32'b0;
        else
            instruction = memory[addr >> 2]; // Combinational word-addressed read
    end

endmodule
