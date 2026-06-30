module counter_8bit (
    input wire clk,   
    input wire stop,  
    output wire [7:0] count 
);
    
    reg [7:0] count_reg = 8'h00; 

    always @(posedge clk) begin
        if (!stop) begin
            count_reg <= count_reg + 1;
        end
    end

    assign count = count_reg;

endmodule