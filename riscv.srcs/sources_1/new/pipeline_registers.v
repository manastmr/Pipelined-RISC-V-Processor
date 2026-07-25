`timescale 1ns / 1ps

module if_id_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] pc_in,
    input  wire [31:0] instr_in,
    output reg  [31:0] pc_out,
    output reg  [31:0] instr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out    <= 32'b0;
            instr_out <= 32'b0;
        end else begin
            pc_out    <= pc_in;
            instr_out <= instr_in;
        end
    end
endmodule

module id_ex_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write_in,
    input  wire        alu_src_in,
    input  wire [2:0]  alu_control_in,
    input  wire        branch_in,
    input  wire [31:0] pc_in,
    input  wire [31:0] rd1_in,
    input  wire [31:0] rd2_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    output reg         reg_write_out,
    output reg         alu_src_out,
    output reg  [2:0]  alu_control_out,
    output reg         branch_out,
    output reg  [31:0] pc_out,
    output reg  [31:0] rd1_out,
    output reg  [31:0] rd2_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out   <= 1'b0;
            alu_src_out     <= 1'b0;
            alu_control_out <= 3'b0;
            branch_out      <= 1'b0;
            pc_out          <= 32'b0;
            rd1_out         <= 32'b0;
            rd2_out         <= 32'b0;
            imm_out         <= 32'b0;
            rs1_out         <= 5'b0;
            rs2_out         <= 5'b0;
            rd_out          <= 5'b0;
        end else begin
            reg_write_out   <= reg_write_in;
            alu_src_out     <= alu_src_in;
            alu_control_out <= alu_control_in;
            branch_out      <= branch_in;
            pc_out          <= pc_in;
            rd1_out         <= rd1_in;
            rd2_out         <= rd2_in;
            imm_out         <= imm_in;
            rs1_out         <= rs1_in;
            rs2_out         <= rs2_in;
            rd_out          <= rd_in;
        end
    end
endmodule

module ex_mem_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write_in,
    input  wire        branch_in,
    input  wire [31:0] branch_target_in,
    input  wire        zero_in,
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rd2_in,
    input  wire [4:0]  rd_in,
    output reg         reg_write_out,
    output reg         branch_out,
    output reg  [31:0] branch_target_out,
    output reg         zero_out,
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rd2_out,
    output reg  [4:0]  rd_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out     <= 1'b0;
            branch_out        <= 1'b0;
            branch_target_out <= 32'b0;
            zero_out          <= 1'b0;
            alu_result_out    <= 32'b0;
            rd2_out           <= 32'b0;
            rd_out            <= 5'b0;
        end else begin
            reg_write_out     <= reg_write_in;
            branch_out        <= branch_in;
            branch_target_out <= branch_target_in;
            zero_out          <= zero_in;
            alu_result_out    <= alu_result_in;
            rd2_out           <= rd2_in;
            rd_out            <= rd_in;
        end
    end
endmodule

module mem_wb_reg (
    input  wire        clk,
    input  wire        rst,
    input  wire        reg_write_in,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  rd_in,
    output reg         reg_write_out,
    output reg  [31:0] alu_result_out,
    output reg  [4:0]  rd_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_write_out  <= 1'b0;
            alu_result_out <= 32'b0;
            rd_out         <= 5'b0;
        end else begin
            reg_write_out  <= reg_write_in;
            alu_result_out <= alu_result_in;
            rd_out         <= rd_in;
        end
    end
endmodule