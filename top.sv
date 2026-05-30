module top(
    input  logic clk,
    input logic [3:0] sw_data,      // sw[3:0]
    input logic [3:0] sw_addr,      // sw[11:8]
    input logic [1:0] sw_bank,      // sw[15:14]
    input logic sw_we,              // sw[13]
    input logic sw_mux,              // sw[12] 
    input  logic [1:0]  btn,    // btn[0] = Reset, btn[1] = Step
    output logic [6:0]  seg,    // Segmentele display-ului
    output logic [3:0]  an      // Anozii display-ului
);

    // --- 1. Semnale Interne (Firele de legătură) ---
    logic rst_clean, step_clean;
    logic [3:0] pc_addr;        // Adresa de la Program Counter (4 biți)
    logic [3:0] opcode;         // Instrucțiunea de la ROM
    logic [3:0] regA, regB, regC, regD; // Datele de la RWM către ALU
    logic [3:0] alu_out_h, alu_out_l;   // Rezultatele de la ALU
    logic [7:0] alu_result_full;        // Rezultatul ALU combinat (8 biți)
    
    assign alu_result_full = {alu_out_h, alu_out_l};
    assign rst_clean = btn[0];
    // --- 2. Debouncing (Curățarea semnalului de la butoane) ---
    // Prevenim trecerea prin mai multe instrucțiuni la o singură apăsare
    debouncer db_step (.clk(clk), .rst(1'b0), .b(btn[1]), .bo(step_clean));

    // --- 3. Program Counter (Motorul) ---
    // Numără de la 0 la 15 la fiecare apăsare de buton
    program_counter pc_inst (
        .clk(clk),
        .rst(rst_clean),
        .en(1'b1),
        .next_step(step_clean),
        .pc_out(pc_addr)
    );

    // --- 4. ROM (Caietul de instrucțiuni) ---
    // Trimite opcode-ul de 4 biți către ALU pe baza adresei de la PC
    rom16x4 rom_inst (
        .address(pc_addr),
        .alu_opcode(opcode)
    );

    // --- 5. RWM / Unified Registers (Memoria de lucru) ---
    // bank_sel vine de la switch-urile 15 și 14
    // addr_in (pentru scriere) vine de la switch-urile 3 și 2
    // we (Write Enable) este legat la switch-ul 13
    rwm64x8 ram_inst (
        .clk(clk),
        .rst(rst_clean),
        .bank_sel(sw_bank),      // Alegem banca manual
        .we(sw_we),               // Activăm salvarea datelor manual
        .use_ext_data(sw_mux),     // 1 = Date de la switch-uri, 0 = Date de la ALU
        .addr_in(sw_addr),        // Adresa unde salvăm în RAM
        .alu_result(alu_result_full),
        .sw_data({4'b0000, sw_data}), // Datele de pe primele 4 switch-uri
        .A(regA), .B(regB), .C(regC), .D(regD),
        .data_out()                // Putem lăsa neconectat dacă nu afișăm memoria direct
    );

    // --- 6. ALU (Soldatul care calculează) ---
    alu my_alu (
        .clk(clk),
        .rst(rst_clean),
        .opcode(opcode),
        .A(regA), .B(regB), .C(regC), .D(regD),
        .out_higher(alu_out_h),
        .out_lower(alu_out_l),
        .CF(),
        .BF(),
        .ZF(),
        .PF(),
        .SF(),
        .OF_AB(),
        .OF_CD()
    );

    // --- 7. Display Controller (Interfața vizuală) ---
    // Afișează hexazecimal rezultatul curent al ALU
    display disp_inst (
        .clk(clk),
        .val_high(alu_out_h),
        .val_low(alu_out_l),
        .seg(seg),
        .an(an)
    );

endmodule