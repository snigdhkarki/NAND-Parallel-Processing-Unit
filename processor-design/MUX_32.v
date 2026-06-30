module mux_32to1(
    input wire [31:0] D,    
    input wire [4:0] S,     
    output wire Y     
);

    assign Y = D[S];

endmodule