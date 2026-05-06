module alu (
	input [31:0] a,
	input [31:0] b,
	input [2:0] alu_op,
	output [31:0] result,
	output zero
);

localparam ADD = 3'b000;
localparam SUB = 3'b001;
localparam AND_OP = 3'b010;
localparam OR_OP = 3'b011;



always_comb begin
	case (alu_op)
		ADD: result = a+b;
		SUB: result = a-b;
		AND_OP: result = a & b;
		OR_OP: result = a|b;
		default: result = '0;
	endcase
end

assign zero = (result == '0);

endmodule
