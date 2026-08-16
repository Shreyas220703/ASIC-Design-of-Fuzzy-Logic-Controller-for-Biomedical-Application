module mod_6_counter(
    input  wire clk,
    input  wire reset,
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (reset)
            count <= 3'd0;
        else if (count == 3'd5)
            count <= 3'd0;
        else
            count <= count + 1'b1;
    end
endmodule

