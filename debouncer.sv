module debouncer(
    input  logic clk,
    input  logic rst,
    input  logic b,    
    output logic bo     
);

    localparam COUNT_MAX = 2000000; 
    logic [20:0] counter;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            bo <= 0;
        end else begin
            if (b == bo) begin
                // Daca intrarea este identica cu starea noastră stabila, 
                // înseamnă ca nu avem schimbari sau vibratii.
                counter <= 0;
            end else begin
                // Daca b e diferit de bo, avem o posibilă apasare/eliberare.
                // Incepem să numaram.
                if (counter < COUNT_MAX) begin
                    counter <= counter + 1;
                end else begin
                    // Daca a stat nemiscat 20ms, abia acum schimbam ieșirea.
                    bo <= b;
                    counter <= 0;
                end
            end
        end
    end

endmodule