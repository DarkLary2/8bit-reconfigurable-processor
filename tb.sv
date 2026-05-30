

module top_tb();

    // Semnale de control
    logic clk;
    logic [3:0] sw_data;     // sw[3:0]
     logic [3:0] sw_addr;     // sw[11:8]
    logic [1:0] sw_bank;      // sw[15:14]
     logic sw_we;       
    logic [1:0]  btn;

    // Semnale de monitorizare
    logic [6:0] seg;
    logic [3:0] an;

    // Instanțierea modulului TOP
    top dut (
        .clk(clk),
        .sw_data(sw_data),
        .sw_addr(sw_addr),
        .sw_bank(sw_bank),
        .sw_mux(xw_mux),
        .sw_we(sw_we),
        .btn(btn),
        .seg(seg),
        .an(an)
    );

    // Generator de ceas (100MHz)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Scenariul de testare
    initial begin
    // 1. Totul pornește de la 0
    {sw_data,sw_addr,sw_bank,sw_we} = 16'h0000;
    btn = 4'h0;
    #50;

    // 2. RESETUL - Aceasta este cheia! 
    // Punem btn = 1 (care în binar e 0001, deci btn[0] e activat)
    btn = 4'h1; 
    #100;       // Îl ținem apăsat un pic
    btn = 4'h0; // Îl eliberăm
    #200;       // Așteptăm să se propage semnalul de liniștire
    
    // ACUM liniile ar trebui să devină verzi (0000)

    // 3. Abia acum apăsăm STEP (btn[1])
    // Punem btn = 2 (care în binar e 0010, deci btn[1] e activat)
    $display("Apasam STEP...");
    btn = 4'h2; 
    #500;
    btn = 4'h0;
    
    #1000;
    $stop;
end
endmodule