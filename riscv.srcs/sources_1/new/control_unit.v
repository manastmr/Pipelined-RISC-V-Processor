`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire       funct7_5,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        branch,
    output reg        jump,
    output reg  [2:0] alu_control
);

    always @(*) begin
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        alu_control = 3'b000;

        case (opcode)
            7'b0110011: begin
                reg_write   = 1'b1;
                alu_control = (funct7_5) ? 3'b001 : 3'b000;
            end

            7'b0010011: begin
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 3'b000;
            end

            7'b0000011: begin
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_to_reg  = 1'b1;
                alu_control = 3'b000;
            end

            7'b0100011: begin
                mem_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = 3'b000;
            end

            7'b1100011: begin
                branch      = 1'b1;
                alu_control = 3'b001;
            end

            7'b1101111: begin
                reg_write   = 1'b1;
                jump        = 1'b1;
            end

            default: ;
        endcase
    end

endmodule