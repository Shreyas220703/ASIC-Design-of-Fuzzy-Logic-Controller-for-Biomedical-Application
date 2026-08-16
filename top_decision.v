module top_decision(
    input  [7:0] BMI_L, BMI_M, BMI_H,
    input  [7:0] GLU_L, GLU_M, GLU_H,
    input  [7:0] UREA_L, UREA_M, UREA_H,
    input  [7:0] CREA_L, CREA_M, CREA_H,
    input  [7:0] SYSBP_L, SYSBP_M, SYSBP_H,
    input  [7:0] DIABP_L, DIABP_M, DIABP_H,
    output [1:0] final_result
);
    // Comparator outputs
    wire [1:0] res_BMI, res_GLU, res_UREA, res_CREA, res_SYSBP, res_DIABP;
    wire [7:0] conf_BMI, conf_GLU, conf_UREA, conf_CREA, conf_SYSBP, conf_DIABP;

    // Instantiate comparators (using muL, muM, muH)
    comparator cmp_BMI   (.muL(BMI_L),   .muM(BMI_M),   .muH(BMI_H),   .res(res_BMI),   .conf(conf_BMI));
    comparator cmp_GLU   (.muL(GLU_L),   .muM(GLU_M),   .muH(GLU_H),   .res(res_GLU),   .conf(conf_GLU));
    comparator cmp_UREA  (.muL(UREA_L),  .muM(UREA_M),  .muH(UREA_H),  .res(res_UREA),  .conf(conf_UREA));
    comparator cmp_CREA  (.muL(CREA_L),  .muM(CREA_M),  .muH(CREA_H),  .res(res_CREA),  .conf(conf_CREA));
    comparator cmp_SYSBP (.muL(SYSBP_L), .muM(SYSBP_M), .muH(SYSBP_H), .res(res_SYSBP), .conf(conf_SYSBP));
    comparator cmp_DIABP (.muL(DIABP_L), .muM(DIABP_M), .muH(DIABP_H), .res(res_DIABP), .conf(conf_DIABP));

    // Decision module
    decision dec_logic (
        .res1(res_BMI),   .res2(res_GLU),   .res3(res_UREA),
        .res4(res_CREA),  .res5(res_SYSBP), .res6(res_DIABP),
        .conf1(conf_BMI), .conf2(conf_GLU), .conf3(conf_UREA),
        .conf4(conf_CREA),.conf5(conf_SYSBP),.conf6(conf_DIABP),
        .final_result(final_result)
    );
endmodule

