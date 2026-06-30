module rom_256x8 #(
    parameter INIT_FILE = "none"
)(
    input  wire       clk,
    input  wire       en,
    input  wire [7:0] addr, 
    output reg  [7:0] dout  
);

    reg [7:0] mem [0:255];

    initial begin
        if (INIT_FILE != "none") begin
            $readmemh(INIT_FILE, mem);
        end
        dout = 8'hBF;
    end

    always @(posedge clk) begin
        if (en) begin
            dout <= mem[addr];
        end
    end

endmodule