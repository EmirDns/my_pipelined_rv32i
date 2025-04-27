`timescale 1ns / 1ps

module Sign_Extend(
    input logic [2:0] ImmSrc,    // Control signal for selecting immediate type
    input logic [31:0] Instr,    // Input instruction
    output logic [31:0] ExtImm    // 32-bit extended immediate output
);

    always_comb begin
        case (ImmSrc)
            3'b000:    ExtImm = {{20{Instr[31]}}, Instr[31:20]};                                         // I-Type
            3'b001:    ExtImm = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};                            // S-Type
            3'b010:    ExtImm = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-Type
            3'b011:    ExtImm = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};          // J-Type
            3'b100:    ExtImm = Instr[31:12] << 12;                                                      // lui
            default:   ExtImm = 32'b0;  // Default case for safety
        endcase
    end

endmodule
