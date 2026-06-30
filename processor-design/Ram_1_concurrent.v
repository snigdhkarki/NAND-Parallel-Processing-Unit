module MultiPort_RAM_64x1_32P (
    input wire clk,
    input wire [32*6-1:0]   addr_in, 
    input wire [31:0]       wren_in, 
    input wire [31:0]       data_in,
    input wire [7:0]        sw,  
    output wire [7:0]       led,  
    output wire [31:0]      data_out 
);

    reg [0:0] memory [63:0]; 
    integer k;
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : Read_Ports
            wire [5:0] current_addr = addr_in[i*6 + 5 : i*6];
            assign data_out[i] = memory[current_addr];
        end
    endgenerate

    integer addr_idx; 
    integer port_idx; 
    reg write_enable_accum;
    reg data_accum;        
    reg [7:0] led_reg;

    initial begin
        memory[32] = 1'b0;
        memory[33] = 1'b0;
        memory[34] = 1'b0;
        memory[35] = 1'b0;
        memory[36] = 1'b0;
        memory[37] = 1'b0;
        memory[38] = 1'b0;
        memory[39] = 1'b0;
    end

    always @(posedge clk) begin

        

        memory[0] <= sw[0];
        memory[1] <= sw[1];
        memory[2] <= sw[2];
        memory[3] <= sw[3];
        memory[4] <= sw[4];
        memory[5] <= sw[5];
        memory[6] <= sw[6];
        memory[7] <= sw[7];

        led_reg[0] <= memory[32];
        led_reg[1] <= memory[33];
        led_reg[2] <= memory[34];
        led_reg[3] <= memory[35];
        led_reg[4] <= memory[36];
        led_reg[5] <= memory[37];
        led_reg[6] <= memory[38];
        led_reg[7] <= memory[39];

        for (addr_idx = 8; addr_idx < 64; addr_idx = addr_idx + 1) begin  //here addr_idx = 8 cuz till 7 it never changes unless FPGA port change
            write_enable_accum = 1'b0;
            data_accum = 1'b0;

            for (port_idx = 0; port_idx < 32; port_idx = port_idx + 1) begin
                if (wren_in[port_idx] && (addr_in[port_idx*6 +: 6] == addr_idx[5:0])) begin
                    write_enable_accum = 1'b1;
                    data_accum = data_accum | data_in[port_idx];
                end
            end

            if (write_enable_accum) begin
                memory[addr_idx] <= data_accum;
            end
        end
    end

    assign led = led_reg;

endmodule