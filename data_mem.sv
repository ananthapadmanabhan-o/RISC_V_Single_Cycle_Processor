module data_mem (
	input logic clk,
	input logic mem_read,
	input logic mem_write,
	input logic [31:0] addr,
	input logic [31:0] write_data,
	output logic [31:0] read_data
);

logic [31:0] data_mem [0:255];

always_ff @(posedge clk) begin
	if (mem_write)
		data_mem[addr[9:2]] <= write_data;
end

assign read_data = (mem_read) ? data_mem[addr[9:2]] : 32'd0;



endmodule
