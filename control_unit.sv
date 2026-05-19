module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch_en,
    output logic [3:0] alu_op,
    output logic [2:0] branch_type
);

localparam OPCODE_RTYPE  = 7'b0110011;
localparam OPCODE_ITYPE  = 7'b0010011;
localparam OPCODE_LOAD   = 7'b0000011;
localparam OPCODE_STORE  = 7'b0100011;
localparam OPCODE_BRANCH = 7'b1100011;

localparam ALU_ADD 		= 4'b0000;
localparam ALU_SUB 		= 4'b0001;
localparam ALU_XOR_OP 	= 4'b0010;
localparam ALU_OR_OP 	= 4'b0011;
localparam ALU_AND_OP 	= 4'b0100;
localparam ALU_SLL 		= 4'b0101;
localparam ALU_SRL 		= 4'b0110;
localparam ALU_SRA		= 4'b0111;
localparam ALU_SLT 		= 4'b1000;
localparam ALU_SLTU		= 4'b1001;

localparam BR_EQ    = 3'b000;
localparam BR_NE    = 3'b001;
localparam BR_LT    = 3'b010;
localparam BR_GE    = 3'b011;
localparam BR_LTU   = 3'b100;
localparam BR_GEU   = 3'b101;




always_comb begin
    reg_write = 1'b0;
    alu_src   = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    branch_en    = 1'b0;
    alu_op    = ALU_ADD;
    branch_type = 3'b111;
    case (opcode)
        OPCODE_RTYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            case ({funct7, funct3})
                10'b0000000_000: alu_op = ALU_ADD;
                10'b0100000_000: alu_op = ALU_SUB;
                10'b0000000_100: alu_op = ALU_XOR_OP;
                10'b0000000_110: alu_op = ALU_OR_OP;
                10'b0000000_111: alu_op = ALU_AND_OP;
                10'b0000000_001: alu_op = ALU_SLL;
                10'b0000000_101: alu_op = ALU_SRL;
                10'b0100000_101: alu_op = ALU_SRA;
                10'b0000000_010: alu_op = ALU_SLT;
                10'b0000000_011: alu_op = ALU_SLTU;
                default:         alu_op = ALU_ADD;
            endcase
        end

        OPCODE_ITYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            case (funct3)
                3'b000: alu_op = ALU_ADD;
                3'b100: alu_op = ALU_XOR_OP;
                3'b110: alu_op = ALU_OR_OP;
                3'b111: alu_op = ALU_AND_OP;
                3'b001: alu_op = ALU_SLL;
                3'b101: begin
                    if (funct7 == 7'b0000000)
                        alu_op = ALU_SRL;
                    else if (funct7 == 7'b0100000)
                        alu_op = ALU_SRA;
                end
                3'b010: alu_op = ALU_SLT;
                3'b011: alu_op = ALU_SLTU;
                default:alu_op = ALU_ADD;
            endcase
        end

        OPCODE_LOAD: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            mem_read  = 1'b1;
            alu_op    = ALU_ADD;
        end

        OPCODE_STORE: begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_op    = ALU_ADD;
        end

        OPCODE_BRANCH: begin
            branch_en = 1'b1;
            case(funct3)
                3'b000: begin
                    alu_op = ALU_SUB;
                    branch_type = BR_EQ;
                end
                3'b001: begin
                    alu_op = ALU_SUB;
                    branch_type = BR_NE;
                end
                3'b100: begin
                    alu_op = ALU_SLT;
                    branch_type = BR_LT;
                end
                3'b101: begin
                    alu_op = ALU_SLT;
                    branch_type = BR_GE;
                end
                3'b110: begin 
                    alu_op = ALU_SLTU;
                    branch_type = BR_LTU;
                end
                3'b111: begin 
                    alu_op = ALU_SLTU;
                    branch_type = BR_GEU;
                end
                default: begin
                    alu_op = ALU_ADD;
                    branch_type = 3'b111;
                end
            endcase            
        end
        
        default: begin
            reg_write = 1'b0;
            alu_src   = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            branch_en = 1'b0;
            alu_op    = ALU_ADD;
            branch_type = 3'b111;
        end

    endcase
end

endmodule
