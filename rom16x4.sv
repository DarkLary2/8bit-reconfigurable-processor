module rom16x4(
    input  logic [3:0] address,    // 4 biți = 16 locații (0-15)
    output logic [3:0] alu_opcode  // 4 biți = instrucțiunea propriu-zisă
);

    // Declarația memoriei: 16 rânduri de câte 4 biți
    logic [3:0] mem [0:15];

    initial begin
        // --- Lista de instrucțiuni (Opcodes) ---
        mem[0]  = 4'h0; // ADD (Dual sau 8-bit, depinde de starea ALU)
        mem[1]  = 4'h1; // SUB
        mem[2]  = 4'h2; // MUL AB
        mem[3]  = 4'h3; // MUL CD
        mem[4]  = 4'h4; // DIV AB
        mem[5]  = 4'h5; // DIV CD
        mem[6]  = 4'h6; // AND/OR
        mem[7]  = 4'h7; // OR/AND
        mem[8]  = 4'h8; // NAND/NOR
        mem[9]  = 4'h9; // NOR/NAND
        mem[10] = 4'hA; // XOR/XNOR
        mem[11] = 4'hB; // XNOR/XOR
        mem[12] = 4'hC; // Rezervat
        mem[13] = 4'hD; // Rezervat
        mem[14] = 4'hE; // Switch to Nibble Mode
        mem[15] = 4'hF; // Switch to 8-bit Mode
    end

    // Citirea asincronă: ieșirea se schimbă imediat ce se schimbă adresa
    assign alu_opcode = mem[address];

endmodule