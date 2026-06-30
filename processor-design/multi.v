`timescale 1ns/1ps

module multi_core(
    input wire clk,
    input wire [7:0] sw,  
    output wire [7:0] led, 
    output wire [31:0] accumulator_outputs
);

    wire [31:0] halt_outputs;
    wire [31:0] data_out;
    wire [32*6-1:0] addr_in;
    wire [31:0] wren_in;
    wire [31:0] data_in;
    wire [255:0] flat_addrs;
    wire [255:0] flat_douts;
    wire [31:0] enables;
    
    multi_rom_system rom8(
        .clk(clk),
        .enables(enables),
        .flat_addrs(flat_addrs),
        .flat_douts(flat_douts)
    );
    
    MultiPort_RAM_64x1_32P ram1(
        .clk(clk),
        .addr_in(addr_in),
        .sw(sw),
        .led(led),
        .wren_in(wren_in),
        .data_in(data_in),
        .data_out(data_out)
    );

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : core_gen_block
            core_for_multi core_inst (
                .clk(clk),
                .cores_accumulator_outputs(accumulator_outputs[31:0]),
                .cores_halt_outputs(halt_outputs[31:0]),
                .data_out(data_out[i]),
                .data_out_rom(flat_douts[i*8+7:i*8]),
                .accumulator_output(accumulator_outputs[i]),
                .halt_output(halt_outputs[i]),
                .addr(addr_in[5+6*i:6*i]),
                .addr_rom(flat_addrs[i*8+7:i*8]),
                .data_in(data_in[i]),
                .we(wren_in[i]),
                .en_rom(enables[i])
            );
        end
    endgenerate

endmodule