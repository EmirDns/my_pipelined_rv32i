`timescale 1ns / 1ps

module m_w_pipeline(
    input logic clk,
    input logic rst_n,
    input logic clear,  
    input logic enable, 
    input logic [31:0] ALUResult_m,
    input logic [31:0] ReadData_m,
    input logic [4:0] rd_m,
    input logic [31:0] pcplus4_m,
    input logic [31:0] pc_m,

    input logic RegWrite_m,
    input logic [1:0] ResultSrc_m,

    output logic [31:0] ALUResult_w,
    output logic [31:0] ReadData_w,
    output logic [4:0] rd_w,
    output logic [31:0] pcplus4_w,
    output logic [31:0] pc_w,

    output logic RegWrite_w,
    output logic [1:0] ResultSrc_w
);

    always_ff @(posedge clk) begin
        // Reset condition
        if (!rst_n) begin
            ALUResult_w   <= 32'b0; 
            ReadData_w    <= 32'b0;
            rd_w          <= 5'b0;
            pcplus4_w     <= 32'b0;
            pc_w          <= 32'b0;

            RegWrite_w     <= 1'b0;
            ResultSrc_w    <= 2'b00;
        end

        // Flush condition
        else if (clear) begin
            ALUResult_w   <= 32'b0; 
            ReadData_w    <= 32'b0;
            rd_w          <= 5'b0;
            pcplus4_w     <= 32'hFFFFFFFF;
            pc_w          <= 32'hFFFFFFFF;

            RegWrite_w     <= 1'b0;
            ResultSrc_w    <= 2'b00;
        end

        else if (enable) begin
            ALUResult_w   <= ALUResult_m;
            ReadData_w    <= ReadData_m;
            rd_w          <= rd_m;
            pcplus4_w     <= pcplus4_m;
            pc_w          <= pc_m;

            RegWrite_w     <= RegWrite_m;
            ResultSrc_w    <= ResultSrc_m;
        end
    end

endmodule
