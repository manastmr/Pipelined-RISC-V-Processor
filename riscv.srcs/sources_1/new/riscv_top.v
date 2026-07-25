`timescale 1ns / 1ps

module riscv_top (
    input wire clk,
    input wire rst
);

    wire [31:0] pc_if, pc_next_if, pc_plus_4_if;
    wire [31:0] instr_if;

    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next_if),
        .pc_out(pc_if)
    );

    instruction_memory imem_inst (
        .addr(pc_if),
        .instr(instr_if)
    );

    assign pc_plus_4_if = pc_if + 32'd4;

    wire [31:0] pc_id, instr_id;

    if_id_reg if_id_inst (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_if),
        .instr_in(instr_if),
        .pc_out(pc_id),
        .instr_out(instr_id)
    );

    wire [4:0] rs1_id, rs2_id, rd_id;

    assign rs1_id = instr_id[19:15];
    assign rs2_id = instr_id[24:20];
    assign rd_id  = instr_id[11:7];

    wire        reg_write_id, alu_src_id, branch_id;
    wire [2:0]  alu_control_id;
    wire [31:0] reg_rd1_id, reg_rd2_id, imm_ext_id;

    wire        reg_write_wb;
    wire [4:0]  rd_wb;
    wire [31:0] write_data_wb;

    control_unit cu_inst (
        .opcode(instr_id[6:0]),
        .funct3(instr_id[14:12]),
        .funct7_5(instr_id[30]),
        .reg_write(reg_write_id),
        .alu_src(alu_src_id),
        .alu_control(alu_control_id),
        .branch(branch_id)
    );

    register_file rf_inst (
        .clk(clk),
        .rst(rst),
        .reg_write(reg_write_wb),
        .rs1(rs1_id),
        .rs2(rs2_id),
        .rd(rd_wb),
        .write_data(write_data_wb),
        .read_data1(reg_rd1_id),
        .read_data2(reg_rd2_id)
    );

    imm_generator imm_inst (
        .instr(instr_id),
        .imm_ext(imm_ext_id)
    );

    wire        reg_write_ex, alu_src_ex, branch_ex;
    wire [2:0]  alu_control_ex;
    wire [31:0] pc_ex, reg_rd1_ex, reg_rd2_ex, imm_ext_ex;
    wire [4:0]  rs1_ex, rs2_ex, rd_ex;

    id_ex_reg id_ex_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write_id),
        .alu_src_in(alu_src_id),
        .alu_control_in(alu_control_id),
        .branch_in(branch_id),
        .pc_in(pc_id),
        .rd1_in(reg_rd1_id),
        .rd2_in(reg_rd2_id),
        .imm_in(imm_ext_id),
        .rs1_in(rs1_id),
        .rs2_in(rs2_id),
        .rd_in(rd_id),
        .reg_write_out(reg_write_ex),
        .alu_src_out(alu_src_ex),
        .alu_control_out(alu_control_ex),
        .branch_out(branch_ex),
        .pc_out(pc_ex),
        .rd1_out(reg_rd1_ex),
        .rd2_out(reg_rd2_ex),
        .imm_out(imm_ext_ex),
        .rs1_out(rs1_ex),
        .rs2_out(rs2_ex),
        .rd_out(rd_ex)
    );

    wire [1:0] forward_a, forward_b;
    reg  [31:0] alu_a_forwarded, alu_b_forwarded;
    wire [31:0] alu_b_final;
    wire [31:0] alu_result_ex;
    wire zero_ex;
    wire [31:0] branch_target_ex;

    wire reg_write_mem;
    wire [4:0] rd_mem;
    wire [31:0] alu_result_mem;

    forwarding_unit fwd_inst (
        .id_ex_rs1(rs1_ex),
        .id_ex_rs2(rs2_ex),
        .ex_mem_rd(rd_mem),
        .ex_mem_reg_write(reg_write_mem),
        .mem_wb_rd(rd_wb),
        .mem_wb_reg_write(reg_write_wb),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    always @(*) begin
        case (forward_a)
            2'b00: alu_a_forwarded = reg_rd1_ex;
            2'b10: alu_a_forwarded = alu_result_mem;
            2'b01: alu_a_forwarded = write_data_wb;
            default: alu_a_forwarded = reg_rd1_ex;
        endcase
    end

    always @(*) begin
        case (forward_b)
            2'b00: alu_b_forwarded = reg_rd2_ex;
            2'b10: alu_b_forwarded = alu_result_mem;
            2'b01: alu_b_forwarded = write_data_wb;
            default: alu_b_forwarded = reg_rd2_ex;
        endcase
    end

    assign alu_b_final = alu_src_ex ? imm_ext_ex : alu_b_forwarded;

    alu alu_inst (
        .a(alu_a_forwarded),
        .b(alu_b_final),
        .alu_control(alu_control_ex),
        .alu_result(alu_result_ex),
        .zero(zero_ex)
    );

    assign branch_target_ex = pc_ex + imm_ext_ex;

    wire branch_mem, zero_mem;
    wire [31:0] branch_target_mem, rd2_mem;

    ex_mem_reg ex_mem_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write_ex),
        .branch_in(branch_ex),
        .branch_target_in(branch_target_ex),
        .zero_in(zero_ex),
        .alu_result_in(alu_result_ex),
        .rd2_in(alu_b_forwarded),
        .rd_in(rd_ex),
        .reg_write_out(reg_write_mem),
        .branch_out(branch_mem),
        .branch_target_out(branch_target_mem),
        .zero_out(zero_mem),
        .alu_result_out(alu_result_mem),
        .rd2_out(rd2_mem),
        .rd_out(rd_mem)
    );

    wire pcsrc_mem;

    assign pcsrc_mem = branch_mem & zero_mem;
    assign pc_next_if = pcsrc_mem ? branch_target_mem : pc_plus_4_if;

    wire [31:0] alu_result_wb;

    mem_wb_reg mem_wb_inst (
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write_mem),
        .alu_result_in(alu_result_mem),
        .rd_in(rd_mem),
        .reg_write_out(reg_write_wb),
        .alu_result_out(alu_result_wb),
        .rd_out(rd_wb)
    );

    assign write_data_wb = alu_result_wb;

endmodule