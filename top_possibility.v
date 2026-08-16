module top_possibility #(parameter WIDTH = 8, parameter ACC_WIDTH = 16)(
input wire clk,
input wire reset,
input wire enable,
input wire [WIDTH-1:0] seq_num_in,
input wire [WIDTH-1:0] mu_val,
input wire is_new,
output reg [WIDTH-1:0] seq_num_out,
output reg [WIDTH-1:0] P_val
);

reg [ACC_WIDTH-1:0] weighted_sum;
reg [ACC_WIDTH-1:0] sum_weights;
reg [ACC_WIDTH-1:0] quotient; // temporary result of division

always @(posedge clk or posedge reset) begin
if (reset) begin
seq_num_out <= 0;
weighted_sum <= 0;
sum_weights <= 0;
P_val <= 0;
quotient <= 0;
end else if (enable) begin
// Increment/decrement logic
if (is_new)
seq_num_out <= seq_num_in + 1;

else if (seq_num_in < 0)
seq_num_out <= seq_num_in - 1;
else
seq_num_out <= 0;

// Multiply-accumulate
weighted_sum <= weighted_sum + (seq_num_in * mu_val);
sum_weights <= sum_weights + seq_num_in;
if (sum_weights != 0)
quotient <= weighted_sum / sum_weights;
else
quotient <= 0;

// Truncate result to WIDTH bits
P_val <= quotient[WIDTH-1:0];
end
end

endmodule
