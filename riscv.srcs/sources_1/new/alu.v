`timescale 1ns / 1ps

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  alu_control,
    output reg  [31:0] alu_result,
    output wire        zero
);

    always @(*) begin
        case (alu_control)
            3'b000:  alu_result = a + b;
            3'b001:  alu_result = a - b;
            default: alu_result = 32'b0;
        endcase
    end

    assign zero = (alu_result == 32'b0);

endmodule