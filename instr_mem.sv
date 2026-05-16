module instr_mem (
	input [31:0] addr,
	output [31:0] instr
);

logic [31:0] mem [0:255];

assign instr = mem[addr[9:2]];

initial begin 
    mem[0] = 32'h00500093; // addi x1, x0, 5
    mem[1] = 32'h00300113; // addi x2, x0, 3
    mem[2] = 32'h002081b3; // add  x3, x1, x2
end


endmodule
