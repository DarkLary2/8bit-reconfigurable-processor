
module alu(
    input  logic [3:0] A, B, C, D,
    input  logic [3:0] opcode,
    input  logic clk,
    input  logic rst,
    input logic mode_switch,
    output logic [3:0] out_higher,
    output logic [3:0] out_lower,
    output logic CF, BF, ZF, OF_AB, OF_CD, PF, SF
);

    logic [7:0] int_result;
    logic mode;

 
   /* always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mode <= 1'b0; 
        end else begin
            case (opcode)
                4'b1111: mode <= 1'b1; 
                4'b1110: mode <= 1'b0; 
                default: mode <= mode; 
            endcase
        end
    end

*/
    always_comb begin
        int_result = 8'b0;
        CF = 0; BF = 0;
        OF_AB = 0; OF_CD = 0;

        if (mode) begin 
            case (opcode)
                4'b0000: begin 
                    {CF, int_result} = {A, C} + {B, D};
                    OF_AB = (A[3] == B[3]) && (int_result[7] != A[3]);
                end
                4'b0001: begin 
                    {BF, int_result} = {A, C} - {B, D};
                    OF_AB = (A[3] != B[3]) && (int_result[7] != A[3]);
                end
                4'b0010: int_result = ({A, C} * {B, D}); 
                4'b0011: int_result = ({B, D} != 8'b0) ? ({A, C} / {B, D}) : 8'hFF;
                4'b0100: int_result = ({B, D} != 8'b0) ? ({A, C} % {B, D}) : 8'hFF;
                4'b0101: int_result = {A, C} & {B, D}; 
                4'b0110: int_result = {A, C} | {B, D}; 
                4'b0111: int_result = {A, C} ^ {B, D}; 
                4'b1000: int_result = ~{A, C};
                4'b1001: int_result = ~{B, D};
                4'b1010: int_result = {A, C} << 1; 
                4'b1011: int_result = {A, C} >> 1; 
                default: int_result = 8'b0;
            endcase
        end 
        else begin 
            case (opcode)
                4'b0000: begin
                    {CF, int_result[3:0]} = A + B;
                    OF_AB = (A[3] == B[3]) && (int_result[3] != A[3]);
                    {BF, int_result[7:4]} = C - D;
                    OF_CD = (C[3] != D[3]) && (int_result[7] != C[3]);
                end
                4'b0001: begin
                    {BF, int_result[3:0]} = A - B;
                    OF_AB = (A[3] != B[3]) && (int_result[3] != A[3]);
                    {CF, int_result[7:4]} = C + D;
                    OF_CD = (C[3] == D[3]) && (int_result[7] != C[3]);
                end
                4'b0010: int_result = A * B;   
                4'b0011: int_result = C * D;
                4'b0100: int_result = (B != 0) ? {A/B, A%B} : 8'hFF;
                4'b0101: int_result = (D != 0) ? {C/D, C%D} : 8'hFF;
                4'b0110: begin int_result[7:4] = A & B; int_result[3:0] = C | D; end
                4'b0111: begin int_result[7:4] = A | B; int_result[3:0] = C & D; end
                4'b1000: begin int_result[7:4] = ~(A & B); int_result[3:0] = ~(C | D); end
                4'b1001: begin int_result[7:4] = ~(A | B); int_result[3:0] = ~(C & D); end
                4'b1010: begin int_result[7:4] = (A ^ B); int_result[3:0] = ~(C ^ D); end
                4'b1011: begin int_result[7:4] = ~(A ^ B); int_result[3:0] = (C ^ D); end
                default: int_result = 8'b0;
            endcase
        end
    end

  
    assign out_higher = int_result[7:4];   
    assign out_lower  = int_result[3:0]; 
    assign ZF = (int_result == 8'b0);  
    assign SF = int_result[7];
    assign PF = ~^int_result;

endmodule