module pc (
	input clk,
	input rst,
	input logic [31:0] pc_next,
	output logic [31:0] pc_out
);

always_ff @(posedge clk) begin
	if (rst)
		pc_out <= '0;
	else
		pc_out <= pc_next;
end


endmodule
