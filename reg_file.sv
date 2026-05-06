module reg_file (
	input clk,
	input [4:0] rs1_addr,	//read register
	input [4:0] rs2_addr,	//read register
	input [4:0] rd_addr,	//write register
	input [31:0] rd_data, 	//write data
	input reg_write,
	
	output [31:0] rs1_data,	//read data rs1
	output [31:0] rs2_data 	//read data rs2
);


// 32 register
logic [31:0] registers [31:0];

//write to register
always_ff @(posedge clk) begin
	if (reg_write && rd_addr != 0)
		registers[rd_addr] <= rd_data;
end


//read from register
assign rs1_data = (rs1_addr == 0) ? 32'd0: registers[rs1_addr];
assign rs2_data = (rs2_addr == 0) ? 32'd0: registers[rs2_addr];

endmodule
