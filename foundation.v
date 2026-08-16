module foundation(
    input  wire       clk,
    input  wire       reset,    // active-high reset
    input  wire       we,
    input  wire [7:0] data_in,
    output wire [7:0] data_out,
    output wire [3:0] addr_out,
    output wire [2:0] param_sel
);

    // address counter
    wire [3:0] address;
    address_counter ac1 (
        .clk(clk),
        .reset(reset),
        .address(address)
    );

    // mod-6 counter
    wire [2:0] param_count;
    mod_6_counter mc1 (
        .clk(clk),
        .reset(reset),
        .count(param_count)
    );

    // sram: pass reset so mem is initialized on top reset
    sram #(.DATA_WIDTH(8), .ADDR_WIDTH(4)) s1 (
        .clk(clk),
        //.reset(reset),
        .we(we),
        .addr(address),
        .din(data_in),
        .dout(data_out)
    );

    assign addr_out = address;
    assign param_sel = param_count;

endmodule
