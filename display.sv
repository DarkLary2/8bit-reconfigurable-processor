module display(
    input  logic clk,
    input  logic [3:0] val_high,
    input  logic [3:0] val_low,  
    output logic [6:0] seg,     
    output logic [3:0] an       
);

    // 1. Un simplu contor care merge la infinit
    logic [16:0] count;
    always_ff @(posedge clk) begin
        count <= count + 1;
    end

    // 2. Alegem cifra: dacă bitul 16 e '0' arătăm o cifră, dacă e '1' o arătăm pe cealaltă
    logic [3:0] cifra_activa;
    
    always_comb begin
        if (count[16] == 1'b0) begin
            an = 4'b1110;          // Aprindem doar prima cifră din dreapta
            cifra_activa = val_low;
        end else begin
            an = 4'b1101;          // Aprindem doar a doua cifră
            cifra_activa = val_high;
        end
    end

    // 3. Tabelul de hexazecimal (păstrăm doar ce e esențial)
    always_comb begin
        case(cifra_activa)
        4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            4'ha: seg = 7'b0001000;
            4'hb: seg = 7'b0000011;
            4'hc: seg = 7'b1000110;
            4'hd: seg = 7'b0100001;
            4'he: seg = 7'b0000110;
            4'hf: seg = 7'b0001110;
            default seg = 7'b1111111;
        endcase
    end

endmodule