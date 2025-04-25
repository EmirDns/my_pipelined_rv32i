`timescale 1ns / 1ps

module register_file #(
)(
    input logic clk,
    input logic rst_n, //Active low reset signal
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] write_data,
    input logic write_enable,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2 
    );
    
    logic [31:0] registers [0:31];
    
    integer LogFile;
    
    // Open the file to write logs (this should be done in an initial block)
    initial begin
        LogFile = $fopen("register_log.txt", "w");  // Open the log file for writing
        if (LogFile == 0) begin
            $display("Error opening file for writing.");
            $finish;  // Terminate simulation if file cannot be opened
        end
    end
   
    always_ff @(negedge clk) begin
        if(!rst_n) begin
            for(int i=0; i<32; i++) begin
                registers[i] <= 32'b0;
            end
        end
        
        else if(write_enable && rd != 5'b0) begin   // The x0 register of RV32I must be always "0"
            registers[rd] <= write_data;   
            $fwrite(LogFile, "x%0d 0x%16h\n", rd, write_data);  // Log write data
        end         
    end
    
    // Reading data is a combinational process independent from CLK signal.
    assign read_data1 = registers[rs1];
    assign read_data2 = registers[rs2];
    
endmodule
