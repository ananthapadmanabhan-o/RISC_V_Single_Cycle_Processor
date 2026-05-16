module imm_gen (
	input logic [31:0] instr,
	input logic [6:0] opcode,
	
	output logic [31:0] imm_out
);

localparam OPCODE_ITYPE  = 7'b0010011;
localparam OPCODE_LOAD   = 7'b0000011;
localparam OPCODE_STORE  = 7'b0100011;
localparam OPCODE_BRANCH = 7'b1100011;


always_comb begin
	case (opcode) 
		OPCODE_ITYPE,OPCODE_LOAD: imm_out = {{21{instr[31]}},instr[30:20]};
		OPCODE_STORE: imm_out = {{21{instr[31]}},instr[30:25],instr[11:7]};
		OPCODE_BRANCH: imm_out = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
		default: imm_out = 32'd0;
	endcase
end

endmodule
