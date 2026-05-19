module instr_mem (
	input [31:0] addr,
	output [31:0] instr
);

logic [31:0] mem [0:255];

assign instr = mem[addr[9:2]];

initial begin

    mem[0]  = 32'h00500093; // addi x1,x0,5
    mem[1]  = 32'h00500113; // addi x2,x0,5
    mem[2]  = 32'h00A00193; // addi x3,x0,10

    // BEQ
    mem[3]  = 32'h00208463; // beq x1,x2,+8
    mem[4]  = 32'h06300213; // addi x4,x0,99
    mem[5]  = 32'h00100213; // addi x4,x0,1

    // BNE
    mem[6]  = 32'h00309463; // bne x1,x3,+8
    mem[7]  = 32'h06300293; // addi x5,x0,99
    mem[8]  = 32'h00200293; // addi x5,x0,2

    // BLT
    mem[9]  = 32'h0030C463; // blt x1,x3,+8
    mem[10] = 32'h06300313; // addi x6,x0,99
    mem[11] = 32'h00300313; // addi x6,x0,3

    // BGE
    mem[12] = 32'h0011D463; // bge x3,x1,+8
    mem[13] = 32'h06300393; // addi x7,x0,99
    mem[14] = 32'h00400393; // addi x7,x0,4

    // BLTU
    mem[15] = 32'h0030E463; // bltu x1,x3,+8
    mem[16] = 32'h06300413; // addi x8,x0,99
    mem[17] = 32'h00500413; // addi x8,x0,5

    // BGEU
    mem[18] = 32'h0011F463; // bgeu x3,x1,+8
    mem[19] = 32'h06300493; // addi x9,x0,99
    mem[20] = 32'h00600493; // addi x9,x0,6

end
endmodule
