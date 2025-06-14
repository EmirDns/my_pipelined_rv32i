`timescale 1ns / 1ps

module data_memory #(
    parameter MEM_SIZE = 2000, //Memory is 1024 words (each word is 32-bit[4-byte])
    parameter DMemInitFile  = "src/dmem.mem"      // data memory initialization file
)(
    input logic clk,
    input logic rst_n,
    input logic [31:0] A,
    input logic [31:0] write_data,
    input logic write_enable,
    output logic [31:0] read_data
    );
    
    logic [31:0] mem [0:MEM_SIZE-1];
    
    initial begin
        $readmemh(DMemInitFile, mem);
    end
    
    integer LogFile;
    
    // Open the file to write logs (this should be done in an initial block)
    initial begin
        LogFile = $fopen("data_log.txt", "w");  // Open the log file for writing
        if (LogFile == 0) begin
            $display("Error opening file for writing.");
            $finish;  // Terminate simulation if file cannot be opened
        end
    end
    
    //Divide address to 4 in order to convert byte address to word (memory is word addressable).
    assign read_data = mem[(A-32'h8000_0000) >> 2];
    
    always_ff @(posedge clk) begin
        if(!rst_n) begin
            for(int i=0; i<MEM_SIZE; i++) begin
                mem[i] <= 32'b0;
            end
        end
        
        
        else if(write_enable) begin
            mem[(A-32'h8000_0000) >> 2] <= write_data; 
            $fwrite(LogFile, "mem [%h] = 0x%h\n", (A-32'h8000_0000) >> 2, write_data); // log the data memory writes
        end  
    end

        
endmodule
