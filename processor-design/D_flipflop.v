module d_flipflop (
    input wire clk,
    input wire d, 
    input wire stop, 
    output wire q  
);

    reg q_reg = 1'b0; 

    always @(posedge clk) begin
        if (!stop) begin
            q_reg <= d;
        end
    end

    assign q = q_reg;

endmodule