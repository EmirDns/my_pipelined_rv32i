module hazard_unit(
    input logic [4:0] RS1_e,
    input logic [4:0] RS2_e,
    input logic [4:0] RD_m,
    input logic [4:0] RD_w,
    input logic RegWrite_m,
    input logic RegWrite_w,

    input logic [4:0] RS1_d,
    input logic [4:0] RS2_d,
    input logic [4:0] RD_e,
    input logic [1:0] ResultSrc_e,

    input logic PCSrc_e,

    output logic [1:0] ForwardA_e,
    output logic [1:0] ForwardB_e,
    output logic Stall_f,
    output logic Stall_d,
    output logic Flush_e, 
    output logic Flush_d
);
    logic lw_stall;

    always_comb begin
        // ForwardA
        if((RS1_e == RD_m) && (RegWrite_m) && (RD_m != 0)) begin
            ForwardA_e = 2'b10;
        end

        else if((RS1_e == RD_w) && (RegWrite_w) && (RD_m != 0)) begin
            ForwardA_e = 2'b01;
        end
        else begin
            ForwardA_e = 2'b00;
        end

        // ForwardB
        if((RS2_e == RD_m) && (RegWrite_m) && (RD_m != 0)) begin
            ForwardB_e = 2'b10;
        end

        else if((RS2_e == RD_w) && (RegWrite_w) && (RD_m != 0)) begin
            ForwardB_e = 2'b01;
        end
        else begin
            ForwardB_e = 2'b00;
        end
                                                
        // Stall the Fetch and Decode, flush de Execute stages
        if(((RS1_d == RD_e) || (RS2_d == RD_e)) && (ResultSrc_e == 2'b01)) begin
            lw_stall = 1'b1;
        end
        else begin
            lw_stall = 1'b0;
        end
        
        Stall_f = lw_stall;
        Stall_d = lw_stall;
        Flush_e = (lw_stall | PCSrc_e);
        Flush_d = PCSrc_e;       
    
    end



endmodule
