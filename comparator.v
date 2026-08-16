module comparator (
    input  [7:0] muL, muM, muH,
    output reg [1:0] res,
    output reg [7:0] conf
);
    always @(*) begin
        if (muL >= muM && muL >= muH) begin
            res  = 2'b01;
            conf = muL;
        end else if (muM >= muH) begin
            res  = 2'b10;
            conf = muM;
        end else begin
            res  = 2'b11;
            conf = muH;
        end
    end
endmodule

