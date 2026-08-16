module decision(
    input  [1:0] res1, res2, res3, res4, res5, res6,   // result codes
    input  [7:0] conf1, conf2, conf3, conf4, conf5, conf6, // confidence levels (0?7)
    output reg [1:0] final_result
);
    integer normal_score, moderate_score;
    reg severe_override;

    always @(*) begin
        // Initialize scores and override
        normal_score   = 0;
        moderate_score = 0;
        severe_override = 0;

        // --- Weighted accumulation with confidence ---
        case (res1)
            2'b01: normal_score   = normal_score   + conf1;
            2'b10: moderate_score = moderate_score + conf1;
            2'b11: severe_override = 1;  // any Severe triggers override
        endcase

        case (res2)
            2'b01: normal_score   = normal_score   + conf2;
            2'b10: moderate_score = moderate_score + conf2;
            2'b11: severe_override = 1;
        endcase

        case (res3)
            2'b01: normal_score   = normal_score   + conf3;
            2'b10: moderate_score = moderate_score + conf3;
            2'b11: severe_override = 1;
        endcase

        case (res4)
            2'b01: normal_score   = normal_score   + conf4;
            2'b10: moderate_score = moderate_score + conf4;
            2'b11: severe_override = 1;
        endcase

        case (res5)
            2'b01: normal_score   = normal_score   + conf5;
            2'b10: moderate_score = moderate_score + conf5;
            2'b11: severe_override = 1;
        endcase

        case (res6)
            2'b01: normal_score   = normal_score   + conf6;
            2'b10: moderate_score = moderate_score + conf6;
            2'b11: severe_override = 1;
        endcase

        // --- Final decision ---
        if (severe_override)
            final_result = 2'b11;  // override: any severe input triggers severe
        else if (moderate_score >= normal_score)
            final_result = 2'b10;
        else
            final_result = 2'b01;
    end
endmodule

