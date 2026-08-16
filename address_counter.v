module address_counter(
    input  wire clk,
    input  wire reset,
    output reg [3:0] address
);
    always @(posedge clk) begin
        if (reset)
            address <= 4'd0;
        else
            address <= address + 1'b1;
    end
endmodule

