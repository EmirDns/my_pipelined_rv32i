`timescale 1ns / 1ps

module e_m_pipeline(
    input logic clk,
    input logic rst_n,
    input logic clear,  
    input logic enable, 
    input logic [31:0] ALUResult_e,
    input logic [31:0] WriteData_e,
    input logic [4:0] rd_e,
    input logic [31:0] pcplus4_e,
    input logic [31:0] pc_e,

    input logic RegWrite_e,
    input logic [1:0] ResultSrc_e,
    input logic MemWrite_e,

    output logic [31:0] ALUResult_m,
    output logic [31:0] WriteData_m,
    output logic [4:0] rd_m,
    output logic [31:0] pcplus4_m,
    output logic [31:0] pc_m,

    output logic RegWrite_m,
    output logic [1:0] ResultSrc_m,
    output logic MemWrite_m
);

    always_ff @(posedge clk) begin
        // Reset condition
        if (!rst_n) begin
            ALUResult_m   <= 32'b0; 
            WriteData_m   <= 32'b0;
            rd_m          <= 5'b0;
            pcplus4_m     <= 32'b0;
            pc_m          <= 32'b0;

            RegWrite_m     <= 1'b0;
            MemWrite_m     <= 1'b0;
            ResultSrc_m    <= 2'b00;
        end

        // Flush condition
        else if (clear) begin
            ALUResult_m   <= 32'b0; 
            WriteData_m   <= 32'b0;
            rd_m          <= 5'b0;
            pcplus4_m     <= 32'hFFFFFFFF;
            pc_m          <= 32'hFFFFFFFF;

            RegWrite_m     <= 1'b0;
            MemWrite_m     <= 1'b0;
            ResultSrc_m    <= 2'b00;
        end
        

        else if (enable) begin
            ALUResult_m   <= ALUResult_e;
            WriteData_m   <= WriteData_e;
            rd_m          <= rd_e;
            pcplus4_m     <= pcplus4_e;
            pc_m          <= pc_e;

            RegWrite_m     <= RegWrite_e;
            ResultSrc_m    <= ResultSrc_e;
            MemWrite_m     <= MemWrite_e;
        end
    end

endmodule
