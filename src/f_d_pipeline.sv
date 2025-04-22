module f_d_pipeline(
    input logic clk,
    input logic rst_n,
    input logic clear,  
    input logic enable, 
    input logic [31:0] instr_f,
    input logic [31:0] pc_f,
    input logic [31:0] pcplus4_f,
    
    output logic [31:0] instr_d,
    output logic [31:0] pc_d,
    output logic [31:0] pcplus4_d
);

    always_ff @(posedge clk) begin
        if ((!rst_n) || clear) begin
            instr_d   <= 32'h00000013; // NOP (ADDI x0, x0, 0)
            pc_d      <= 32'b0;
            pcplus4_d <= 32'b0;
        end

        else if (enable) begin
            instr_d   <= instr_f;
            pc_d      <= pc_f;
            pcplus4_d <= pcplus4_f;
        end
    end

endmodule
