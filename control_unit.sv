module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    
    output logic       reg_write,
    output logic       alu_src,
    output logic       mem_read,
    output logic       mem_write,
    output logic       branch,
    output logic [2:0] alu_op
);

localparam OPCODE_RTYPE  = 7'b0110011;
localparam OPCODE_ITYPE  = 7'b0010011;
localparam OPCODE_LOAD   = 7'b0000011;
localparam OPCODE_STORE  = 7'b0100011;
localparam OPCODE_BRANCH = 7'b1100011;

localparam ALU_ADD = 3'b000;
localparam ALU_SUB = 3'b001;
localparam ALU_AND = 3'b010;
localparam ALU_OR  = 3'b011;

always_comb begin
    reg_write = 1'b0;
    alu_src   = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    branch    = 1'b0;
    alu_op    = ALU_ADD;

    case (opcode)

        OPCODE_RTYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            case ({funct7, funct3})
                10'b0000000_000: alu_op = ALU_ADD;
                10'b0100000_000: alu_op = ALU_SUB;
                10'b0000000_111: alu_op = ALU_AND;
                10'b0000000_110: alu_op = ALU_OR;
                default:         alu_op = ALU_ADD;
            endcase
        end

        OPCODE_ITYPE: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = ALU_ADD;
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
            branch = 1'b1;
            alu_op = ALU_SUB;
        end
        
        default: begin
            reg_write = 1'b0;
            alu_src   = 1'b0;
            mem_read  = 1'b0;
            mem_write = 1'b0;
            branch    = 1'b0;
            alu_op    = ALU_ADD;
        
        end

    endcase
end

endmodule
