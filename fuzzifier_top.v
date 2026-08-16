module fuzzifier_top (
    input  wire [7:0] x,
    input  wire [2:0] shift_amt,
    output wire [7:0] muL_shifted,
    output wire [7:0] muM_shifted,
    output wire [7:0] muH_shifted
);
    wire [7:0] muL, muM, muH;

    // core fuzzifier (combinational)
    fuzzifier F1 (.x(x), .muL(muL), .muM(muM), .muH(muH));

    // shift outputs (post-processing)
    barrel_shifter B1 (.in(muL), .shamt(shift_amt), .out(muL_shifted));
    barrel_shifter B2 (.in(muM), .shamt(shift_amt), .out(muM_shifted));
    barrel_shifter B3 (.in(muH), .shamt(shift_amt), .out(muH_shifted));
endmodule
