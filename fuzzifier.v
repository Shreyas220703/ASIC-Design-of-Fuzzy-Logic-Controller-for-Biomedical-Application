module fuzzifier (
    input  wire [7:0] x,
    output reg  [7:0] muL,
    output reg  [7:0] muM,
    output reg  [7:0] muH
);
    // trapezoid corners (tweak as needed)
    localparam  L_A = 0,   L_B = 30,  L_C = 40,  L_D = 60;
    localparam  M_A = 30,  M_B = 50,  M_C = 70,  M_D = 90;
    localparam  H_A = 70,  H_B = 90,  H_C = 110, H_D = 255;

    integer tmp;
    always @(*) begin
        // --- Low ---
        if (x <= L_A)           muL = 8'd255;
        else if (x < L_B) begin
            tmp = ( (x - L_A) * 255 ) / (L_B - L_A);
            muL = tmp[7:0];
        end
        else if (x <= L_C)      muL = 8'd255;
        else if (x < L_D) begin
            tmp = ( (L_D - x) * 255 ) / (L_D - L_C);
            muL = tmp[7:0];
        end
        else                    muL = 8'd0;

        // --- Medium ---
        if (x <= M_A || x >= M_D)        muM = 8'd0;
        else if (x < M_B) begin
            tmp = ( (x - M_A) * 255 ) / (M_B - M_A);
            muM = tmp[7:0];
        end
        else if (x <= M_C)               muM = 8'd255;
        else begin
            tmp = ( (M_D - x) * 255 ) / (M_D - M_C);
            muM = tmp[7:0];
        end

        // --- High ---
        if (x <= H_A)           muH = 8'd0;
        else if (x < H_B) begin
            tmp = ( (x - H_A) * 255 ) / (H_B - H_A);
            muH = tmp[7:0];
        end
        else if (x <= H_C)      muH = 8'd255;
        else if (x < H_D) begin
            tmp = ( (H_D - x) * 255 ) / (H_D - H_C);
            muH = tmp[7:0];
        end
        else                    muH = 8'd0;
    end
endmodule


