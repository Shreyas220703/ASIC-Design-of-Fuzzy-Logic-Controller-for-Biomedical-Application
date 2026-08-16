module main_top_pipeline (
    input  wire       clk,
    input  wire       reset,
    input  wire       we,
    input  wire [7:0] data_in,
    output wire [1:0] final_result,
    output wire       final_result_valid
);

 // -------------------------
 // Stage 1: Foundation
 // -------------------------
wire [7:0] data_out;
wire [3:0] addr_out;
wire [2:0] param_sel;

foundation foundation_unit (
    .clk(clk),
    .reset(reset),
    .we(we),
    .data_in(data_in),
    .data_out(data_out),
    .addr_out(addr_out),
    .param_sel(param_sel)
);

 // -------------------------
 // Stage 2: Fuzzifier
 // -------------------------
wire [7:0] muL_s, muM_s, muH_s;

fuzzifier_top fuzz_unit (
    .x(data_out),
    .shift_amt(param_sel),
    .muL_shifted(muL_s),
    .muM_shifted(muM_s),
    .muH_shifted(muH_s)
);

 // -------------------------
 // Pipeline register
 // -------------------------
reg [7:0] muL_reg, muM_reg, muH_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        muL_reg <= 8'd0;
        muM_reg <= 8'd0;
        muH_reg <= 8'd0;
    end else begin
        muL_reg <= muL_s;
        muM_reg <= muM_s;
        muH_reg <= muH_s;
    end
end

 // -------------------------
 // Stage 3: Comparator
 // -------------------------
wire [1:0] res;
wire [7:0] conf;

comparator comp_unit (
    .muL(muL_reg),
    .muM(muM_reg),
    .muH(muH_reg),
    .res(res),
    .conf(conf)
);

 // -------------------------
 // Stage 4: Possibility 
 // -------------------------
wire [7:0] seq_num_out_wire;
wire [7:0] P_val;

top_possibility poss_unit (
    .clk(clk),
    .reset(reset),
    .enable(1'b1),
    .seq_num_in({4'b0000, addr_out}),
    .mu_val(conf),
    .is_new(res == 2'b10),
    .seq_num_out(seq_num_out_wire),
    .P_val(P_val)
);

 // -------------------------
 // Stage 5: Accumulate 6 readings
 // -------------------------
reg [7:0] L [0:5];
reg [7:0] M [0:5];
reg [7:0] H [0:5];
reg [2:0] idx;
reg       data_valid;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        idx <= 3'd0;
        data_valid <= 1'b0;

        L[0]<=0; L[1]<=0; L[2]<=0; L[3]<=0; L[4]<=0; L[5]<=0;
        M[0]<=0; M[1]<=0; M[2]<=0; M[3]<=0; M[4]<=0; M[5]<=0;
        H[0]<=0; H[1]<=0; H[2]<=0; H[3]<=0; H[4]<=0; H[5]<=0;

    end else begin
        L[idx] <= muL_reg;
        M[idx] <= muM_reg;
        H[idx] <= muH_reg;

        if (idx == 3'd5) begin
            idx <= 3'd0;
            data_valid <= 1'b1;
        end else begin
            idx <= idx + 1;
            data_valid <= 1'b0;
        end
    end
end

 // -------------------------
 // Stage 6: Decision Logic
 // -------------------------
wire [1:0] decision_out;

top_decision decision_unit (
    .BMI_L(L[0]), .BMI_M(M[0]), .BMI_H(H[0]),
    .GLU_L(L[1]), .GLU_M(M[1]), .GLU_H(H[1]),
    .UREA_L(L[2]),.UREA_M(M[2]),.UREA_H(H[2]),
    .CREA_L(L[3]),.CREA_M(M[3]),.CREA_H(H[3]),
    .SYSBP_L(L[4]),.SYSBP_M(M[4]),.SYSBP_H(H[4]),
    .DIABP_L(L[5]),.DIABP_M(M[5]),.DIABP_H(H[5]),
    .final_result(decision_out)
);

 // -------------------------
 // Final output register
 // -------------------------
reg [1:0] final_result_reg;
reg       final_valid_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        final_result_reg <= 2'b00;
        final_valid_reg  <= 1'b0;
    end else if (data_valid) begin
        final_result_reg <= decision_out;
        final_valid_reg  <= 1'b1;
    end else begin
        final_valid_reg  <= 1'b0;
    end
end

assign final_result = final_result_reg;
assign final_result_valid = final_valid_reg;

endmodule

