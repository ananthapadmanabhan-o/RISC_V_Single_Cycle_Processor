module instr_mem (
	input [31:0] addr,
	output [31:0] instr
);

logic [31:0] mem [0:255];

assign instr = mem[addr[9:2]];

//initial begin

//    mem[0]  = 32'h01400093; // addi x1, x0, 20
//    mem[1]  = 32'h00500113; // addi x2, x0, 5

//    mem[2]  = 32'h002081B3; // add  x3, x1, x2
//    mem[3]  = 32'h40208233; // sub  x4, x1, x2
//    mem[4]  = 32'h0020C2B3; // xor  x5, x1, x2
//    mem[5]  = 32'h0020E333; // or   x6, x1, x2
//    mem[6]  = 32'h0020F3B3; // and  x7, x1, x2

//    mem[7]  = 32'h00100413; // addi x8, x0, 1

//    mem[8]  = 32'h008114B3; // sll  x9, x2, x8
//    mem[9]  = 32'h0080D533; // srl  x10, x1, x8

//    mem[10] = 32'hFF800593; // addi x11, x0, -8
//    mem[11] = 32'h4085D633; // sra  x12, x11, x8

//    mem[12] = 32'h001126B3; // slt  x13, x2, x1
//    mem[13] = 32'h00113733; // sltu x14, x2, x1

//end

initial begin

    mem[0] = 32'h01400093; // addi  x1,  x0, 20

    mem[1] = 32'h0050C113; // xori  x2,  x1, 5
    mem[2] = 32'h0020E193; // ori   x3,  x1, 2
    mem[3] = 32'h0070F213; // andi  x4,  x1, 7

    mem[4] = 32'h00109293; // slli  x5,  x1, 1
    mem[5] = 32'h0010D313; // srli  x6,  x1, 1

    mem[6] = 32'hFF800393; // addi  x7,  x0, -8
    mem[7] = 32'h4013D413; // srai  x8,  x7, 1

    mem[8] = 32'h0190A493; // slti  x9,  x1, 25
    mem[9] = 32'h0190B513; // sltiu x10, x1, 25

end
endmodule
