module rwm64x8(
    input  logic clk,
    input  logic rst,
    input  logic [1:0] bank_sel,
    input  logic we,           
    input  logic use_ext_data,  // Un bit nou din ROM sau un buton care zice "ia de la switch-uri"
    input  logic [3:0] addr_in,
    input  logic [7:0] alu_result,
    input  logic [7:0] sw_data,     // Datele de la switch-urile fizice
    output logic [3:0] A, B, C, D,
    output logic [7:0] data_out
);

    logic [7:0] rwm [0:63];
    logic [5:0] real_addr;
    assign real_addr = {bank_sel, addr_in};

    // --- LOGICA DE TRIAJ (Multiplexorul) ---
    logic [7:0] data_to_write;
    assign data_to_write = (use_ext_data) ? sw_data : alu_result;

    assign A = rwm[{bank_sel, 4'd0}][3:0];
    assign B = rwm[{bank_sel, 4'd1}][3:0];
    assign C = rwm[{bank_sel, 4'd2}][3:0];
    assign D = rwm[{bank_sel, 4'd3}][3:0];
    assign data_out = rwm[real_addr];

   always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        // 1. Mai întâi ștergem tot (Buretele)
        for (int i = 0; i < 64; i++) begin
            rwm[i] <= 8'h00;
        end
        
        // 2. ABIA ACUM punem valorile de test (Creta)
        // Acestea trebuie să fie sub bucla for, dar tot în "if (rst)"
        rwm[0] <= 8'h05; // Registrul A = 5
        rwm[1] <= 8'h03; // Registrul B = 3
        rwm[2] <= 8'h0A; // Registrul C = 10
        rwm[3] <= 8'h02; // Registrul D = 2
    end 
    else if (we) begin
        rwm[real_addr] <= data_to_write;
    end
end
    initial begin
    // Resetăm toată memoria cu 0
    for (int i = 0; i < 64; i++) rwm[i] = 8'h00;
    
    // Punem valori de test în Banca 0
    rwm[0] = 8'h05; // Registrul A = 5
    rwm[1] = 8'h03; // Registrul B = 3
    rwm[2] = 8'h0A; // Registrul C = 10
    rwm[3] = 4'h02; // Registrul D = 2
end
endmodule