`timescale 1ns / 1ps

module d_e_pipeline(
    input logic clk,
    input logic rst_n,
    input logic clear,  
    input logic enable, 
    input logic [31:0] rd1_d,
    input logic [31:0] rd2_d,
    input logic [31:0] pc_d,
    input logic [4:0] rs1_d,
    input logic [4:0] rs2_d,
    input logic [4:0] rd_d,
    input logic [31:0] ext_imm_d,
    input logic [31:0] pcplus4_d,
    
    input logic RegWrite_d,
    input logic [1:0] ResultSrc_d,
    input logic MemWrite_d,
    input logic Jump_d,
    input logic Branch_d,
    input logic [3:0] ALUControl_d,
    input logic ALUSrc_d,


    output logic [31:0] rd1_e,
    output logic [31:0] rd2_e,
    output logic [31:0] pc_e,
    output logic [4:0] rs1_e,
    output logic [4:0] rs2_e,
    output logic [4:0] rd_e,
    output logic [31:0] ext_imm_e,
    output logic [31:0] pcplus4_e,

    output logic RegWrite_e,
    output logic [1:0] ResultSrc_e,
    output logic MemWrite_e,
    output logic Jump_e,
    output logic Branch_e,
    output logic [3:0] ALUControl_e,
    output logic ALUSrc_e
);

    always_ff @(posedge clk) begin
        // Reset condition
        if (!rst_n) begin
            rd1_e      <= 32'b0;
            rd2_e      <= 32'b0;
            pc_e       <= 32'b0;
            rs1_e      <= 5'b0;
            rs2_e      <= 5'b0;
            rd_e       <= 5'b0;
            ext_imm_e  <= 32'b0;
            pcplus4_e  <= 32'b0;

            RegWrite_e     <= 1'b0;
            MemWrite_e     <= 1'b0;
            ResultSrc_e    <= 2'b00;
            ALUControl_e   <= 4'b0000;
            ALUSrc_e       <= 1'b0;
            Jump_e         <= 1'b0;
            Branch_e       <= 1'b0;
        end
        
        // Flush condition
        else if (clear) begin
            rd1_e      <= 32'b0;
            rd2_e      <= 32'b0;
            pc_e       <= 32'hFFFFFFFF;
            rs1_e      <= 5'b0;
            rs2_e      <= 5'b0;
            rd_e       <= 5'b0;
            ext_imm_e  <= 32'b0;
            pcplus4_e  <= 32'hFFFFFFFF;

            RegWrite_e     <= 1'b0;
            MemWrite_e     <= 1'b0;
            ResultSrc_e    <= 2'b00;
            ALUControl_e   <= 4'b0000;
            ALUSrc_e       <= 1'b0;
            Jump_e         <= 1'b0;
            Branch_e       <= 1'b0;
        end

        else if (enable) begin
            rd1_e      <= rd1_d;
            rd2_e      <= rd2_d;
            pc_e       <= pc_d;
            rs1_e      <= rs1_d;
            rs2_e      <= rs2_d;
            rd_e       <= rd_d;
            ext_imm_e  <= ext_imm_d;
            pcplus4_e  <= pcplus4_d;

            RegWrite_e     <= RegWrite_d;
            MemWrite_e     <= MemWrite_d;
            ResultSrc_e    <= ResultSrc_d;
            ALUControl_e   <= ALUControl_d;
            ALUSrc_e       <= ALUSrc_d;
            Jump_e         <= Jump_d;
            Branch_e       <= Branch_d;
        end
    end

endmodule
