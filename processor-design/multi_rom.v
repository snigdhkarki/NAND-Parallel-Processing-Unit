module multi_rom_system (
    input  wire clk,
    input  wire [31:0] enables,
    input  wire [255:0]  flat_addrs,
    output wire [255:0]  flat_douts
);

genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : rom_gen
        
        if (i == 0) begin
            rom_256x8 #(.INIT_FILE("rom0.mem")) rom_inst (
                .clk  (clk),
                .en   (enables[i]),
                .addr (flat_addrs[(i*8) + 7 : (i*8)]),
                .dout (flat_douts[(i*8) + 7 : (i*8)])
            );
        end 
        else if (i == 1) begin
            rom_256x8 #(.INIT_FILE("rom1.mem")) rom_inst (
                .clk  (clk),
                .en   (enables[i]),
                .addr (flat_addrs[(i*8) + 7 : (i*8)]),
                .dout (flat_douts[(i*8) + 7 : (i*8)])
            );
        end 
        else if (i == 2) begin
            rom_256x8 #(.INIT_FILE("rom2.mem")) rom_inst (
                .clk  (clk),
                .en   (enables[i]),
                .addr (flat_addrs[(i*8) + 7 : (i*8)]),
                .dout (flat_douts[(i*8) + 7 : (i*8)])
            );
        end 
        else if (i == 3) begin
            rom_256x8 #(.INIT_FILE("rom3.mem")) rom_inst (
                .clk  (clk),
                .en   (enables[i]),
                .addr (flat_addrs[(i*8) + 7 : (i*8)]),
                .dout (flat_douts[(i*8) + 7 : (i*8)])
            );
        end 
        else begin
            rom_256x8 #(.INIT_FILE("none")) rom_inst (
                .clk  (clk),
                .en   (enables[i]),
                .addr (flat_addrs[(i*8) + 7 : (i*8)]),
                .dout (flat_douts[(i*8) + 7 : (i*8)])
            );
        end
        
    end
endgenerate

endmodule