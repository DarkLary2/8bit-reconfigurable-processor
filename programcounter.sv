module program_counter(
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic next_step, 
    output logic [3:0] pc_out 
);

    logic [3:0] count_reg;
    logic step_delay; // Aici ținem minte starea butonului de la pasul anterior

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count_reg  <= 4'b0000;
            step_delay <= 1'b0;
        end else begin
            step_delay <= next_step; // Salvăm starea curentă
            
            // Creștem DOAR dacă acum e "1", dar înainte a fost "0" (front crescător)
            if (en && next_step && !step_delay) begin
                count_reg <= count_reg + 1'b1;
            end
        end
    end

    assign pc_out = count_reg;
endmodule