module riscv32_single_cycle_processor (
	input logic clk,
	input logic rst,
	
	output logic [31:0] pc_debug
);




//////////////////////////////////////////////////////////////////
// Program Counter logic
//////////////////////////////////////////////////////////////////

logic [31:0] pc_next;
logic [31:0] pc_out;

pc pc_inst (
	.clk(clk),
	.rst(rst),
	.pc_next(pc_next),
	.pc_out(pc_out)
);

assign pc_debug  = pc_out;


//////////////////////////////////////////////////////////////////
// Instruction Memory logic
//////////////////////////////////////////////////////////////////

logic [31:0] instr;

instr_mem instr_mem_inst (
	.addr(pc_out),
	.instr(instr)
);

//////////////////////////////////////////////////////////////////
// Instruction Decode logic
//////////////////////////////////////////////////////////////////


logic [6:0] opcode;
logic [4:0] rd;
logic [2:0] funct3;
logic [4:0] rs1;
logic [4:0] rs2;
logic [6:0] funct7;


instr_decode instr_decode_inst (
	.instr(instr),
	
	.opcode(opcode),
	.rd(rd),
	.funct3(funct3),
	.rs1(rs1),
	.rs2(rs2),
	.funct7(funct7)
);


//////////////////////////////////////////////////////////////////
// Immediate Generator logic
//////////////////////////////////////////////////////////////////

logic [31:0] imm_out;


imm_gen imm_gen_inst (
	.instr(instr),
	.opcode(opcode),
	
	.imm_out(imm_out)
);


//////////////////////////////////////////////////////////////////
// Control Unit logic
//////////////////////////////////////////////////////////////////


logic reg_write;
logic alu_src;
logic mem_read;
logic mem_write;
logic branch_en;
logic [3:0] alu_op;
logic [2:0] branch_type;
logic jump;
logic jump_lr;


control_unit control_unit_inst (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    
	.reg_write(reg_write),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .branch_en(branch_en),
    .alu_op(alu_op),
    .branch_type(branch_type),
    .jump(jump),
    .jump_lr(jump_lr)
);


//////////////////////////////////////////////////////////////////
// Register File logic
//////////////////////////////////////////////////////////////////


logic [31:0] rs1_data;	
logic [31:0] rs2_data; 

logic [31:0] writeback_data;


reg_file reg_file_inst (
	.clk(clk),
	.rs1_addr(rs1),	
	.rs2_addr(rs2),	
	.rd_addr(rd),	
	.rd_data(writeback_data), 	
	.reg_write(reg_write),
	
	.rs1_data(rs1_data),	
	.rs2_data(rs2_data) 	
);




//////////////////////////////////////////////////////////////////
// Data Memory logic
//////////////////////////////////////////////////////////////////

logic [31:0] alu_result;


logic [31:0] read_data;
	
	
data_mem data_mem_inst (
	.clk(clk),
	.mem_read(mem_read),
	.mem_write(mem_write),
	.addr(alu_result),
	.write_data(rs2_data),
	
	.read_data(read_data)
);




//////////////////////////////////////////////////////////////////
// ALU Mux logic
//////////////////////////////////////////////////////////////////
logic [31:0] alu_b; 

assign alu_b = (alu_src) ? imm_out: rs2_data;

//////////////////////////////////////////////////////////////////
// ALU logic
//////////////////////////////////////////////////////////////////

logic zero;


alu alu_inst (
	.a(rs1_data),
	.b(alu_b),
	.alu_op(alu_op),
	
	.result(alu_result),
	.zero(zero)
);


//////////////////////////////////////////////////////////////////
// Write Back logic
//////////////////////////////////////////////////////////////////


assign writeback_data = (jump||jump_lr) ? (pc_out + 32'd4):
                        (mem_read) ? read_data: 
                        alu_result;


//////////////////////////////////////////////////////////////////
// Branch logic
//////////////////////////////////////////////////////////////////
localparam BR_EQ    = 3'b000;
localparam BR_NE    = 3'b001;
localparam BR_LT    = 3'b010;
localparam BR_GE    = 3'b011;
localparam BR_LTU   = 3'b100;
localparam BR_GEU   = 3'b101;

logic branch_valid;
logic branch;

always_comb begin
 case(branch_type)
    BR_EQ  : branch =  zero;
    BR_NE  : branch = ~zero;
    BR_LT  : branch = ~zero;
    BR_GE  : branch =  zero;
    BR_LTU : branch = ~zero;
    BR_GEU : branch =  zero;
    default : branch = 1'b0;
 endcase
end

assign branch_valid = branch_en && branch;

//////////////////////////////////////////////////////////////////
// Branch logic 
//////////////////////////////////////////////////////////////////

assign pc_next =    (jump_lr) ? (alu_result & ~32'd1):
                    (jump)    ? (pc_out + imm_out):
                    (branch_valid) ? (pc_out + imm_out) : 
                    (pc_out + 32'd4);



endmodule
