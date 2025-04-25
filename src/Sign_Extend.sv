`timescale 1ns / 1ps

module Sign_Extend(
    input logic [1:0] ImmSrc,    // Control signal for selecting immediate type
    input logic [31:0] Instr,    // Input instruction
    output logic [31:0] ExtImm    // 32-bit extended immediate output
);

    always_comb begin
        case (ImmSrc)
            2'b00:    ExtImm = {{20{Instr[31]}}, Instr[31:20]};                                         // I-Type
            2'b01:    ExtImm = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};                            // S-Type
            2'b10:    ExtImm = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-Type
            2'b11:    ExtImm = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};          // J-Type
            default:   ExtImm = 32'b0;  // Default case for safety
        endcase
    end

endmodule
