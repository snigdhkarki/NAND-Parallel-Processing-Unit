`timescale 1ns/1ps

module core_for_multi(
    input wire clk,
    input wire [31:0] cores_accumulator_outputs,
    input wire [31:0] cores_halt_outputs,
    input wire data_out,
    input wire [7:0] data_out_rom,
    output wire accumulator_output,
    output wire halt_output,
    output wire [5:0] addr,
    output wire [7:0] addr_rom,
    output wire data_in,
    output wire we,
    output wire en_rom
);

    wire [3:0] decoder_out;
    wire [7:0] counter_out;
    wire mux_2_out;
    wire mux_32_accumulator_out;
    wire mux_32_halt_out;
    assign halt_output = (&data_out_rom[5:0]) & decoder_out[3];
    assign we = decoder_out[1];
    assign addr = data_out_rom[5:0];
    assign data_in = accumulator_output;
    assign addr_rom = counter_out;
    assign en_rom = (~decoder_out[3])|mux_32_halt_out;
    reg [7:0] ram8_DI;
    reg ram8_w;
    
    mux_32to1 mux_accumulators(
        .D(cores_accumulator_outputs[31:0]),
        .S(data_out_rom[4:0]),
        .Y(mux_32_accumulator_out)
    );

    mux_32to1 mux_halt(
        .D(cores_halt_outputs[31:0]),
        .S(data_out_rom[4:0]),
        .Y(mux_32_halt_out)
    );

    mux_2to1 mux2(
        .D0(data_out),
        .D1(mux_32_accumulator_out),
        .S(data_out_rom[5]),
        .Y(mux_2_out)
    );

    d_flipflop accumulator (
        .clk(clk),
        .d((accumulator_output & decoder_out[1]) | 
           (~decoder_out[1] & (decoder_out[2] ~^ mux_2_out)) | 
           (~accumulator_output & ~decoder_out[1] & mux_2_out)),
        .stop((~mux_32_halt_out) & decoder_out[3]),
        .q(accumulator_output)
    );

    decoder_2to4 decoder (
        .A(data_out_rom[7:6]),
        .Y(decoder_out)
    );

    counter_8bit counter (
        .clk(clk),
        .stop((~mux_32_halt_out) & decoder_out[3]),
        .count(counter_out)
    );
    
endmodule 