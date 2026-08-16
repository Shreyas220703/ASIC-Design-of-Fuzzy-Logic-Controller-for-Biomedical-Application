// logical right shift (simple, synthesis-friendly)
module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] shamt,
    output wire [7:0] out
);
    assign out = in >> shamt;
endmodule
