module (
	input [31:0] addr,
	output [31:0] instr
);

logic [31:0] mem [0:255];

assign instr = mem[addr[9:2]];

initial begin 
    mem[0] = 32'h00000013; // NOP (addi x0, x0, 0)
    mem[1] = 32'h00100093; // addi x1, x0, 1
    mem[2] = 32'h00200113; // addi x2, x0, 2
end


endmodule
