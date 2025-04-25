`timescale 1ns / 1ps
module instruction_memory #(
    parameter MEM_SIZE = 16_000,
    parameter IMemInitFile = "test/data_forw.mem"
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
        if (!rst_n || addr < 32'h80000000)
            instruction = 32'b0;
        else
            instruction = memory[(addr - 32'h80000000) >> 2];
    end

endmodule
