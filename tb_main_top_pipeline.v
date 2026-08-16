`timescale 1ns/1ps

module tb_main_top_pipeline;

    // -------------------------------
    // DUT I/O
    // -------------------------------
    reg        clk;
    reg        reset;
    reg        we;
    reg  [7:0] data_in;
    wire [1:0] final_result;
    wire       final_result_valid;

    // -------------------------------
    // Instantiate DUT
    // -------------------------------
    main_top_pipeline dut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .data_in(data_in),
        .final_result(final_result),
        .final_result_valid(final_result_valid)
    );

    // -------------------------------
    // Clock generation: 10ns period
    // -------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // -------------------------------
    // Stimulus
    // -------------------------------
    integer i;
    reg [7:0] patient_data [0:11];

    initial begin
        // Initialize patient data (6 parameters × 2 readings)
        // Example values for normal/moderate/severe testing
       patient_data[0] = 8'd28;  // BMI
patient_data[1] = 8'd25;  // GLU
patient_data[2] = 8'd30;  // UREA
patient_data[3] = 8'd22;  // CREA
patient_data[4] = 8'd35;  // SYSBP
patient_data[5] = 8'd147;  // DIABP


       /* patient_data[6]  = 8'd35;  // second round inputs (optional)
        patient_data[7]  = 8'd100;
        patient_data[8]  = 8'd60;
        patient_data[9]  = 8'd90;
        patient_data[10] = 8'd150;
        patient_data[11] = 8'd95;
*/
        // -------------------------------
        // Apply reset
        // -------------------------------
        reset = 1;
        we    = 0;
        data_in = 0;
        #20;
        reset = 0;
        we = 1;

        // -------------------------------
        // Feed all 6 inputs (simulate sensor readings)
        // -------------------------------
        for (i = 0; i < 6; i = i + 1) begin
            data_in = patient_data[i];
            @(posedge clk);
        end

        // wait for pipeline to process
        /*repeat (10) @(posedge clk);*/

        // next set of inputs
        /*for (i = 6; i < 12; i = i + 1) begin
            data_in = patient_data[i];
            @(posedge clk);
        end*/

        // wait to observe final result
        /*repeat (20) @(posedge clk);*/

        $display("Simulation complete.");
        $finish;
    end

    // -------------------------------
    // Waveform dump
    // -------------------------------
    initial begin
        $dumpfile("main_top_pipeline_tb.vcd");
        $dumpvars(0, tb_main_top_pipeline);
    end

    // -------------------------------
    // Monitoring
    // -------------------------------
    initial begin
        $display("Time\tAddr\tDataIn\tFinalResult\tValid");
        $monitor("%0t\t%0d\t%0d\t%b\t%b", $time, dut.addr_out, data_in, final_result, final_result_valid);
    end

endmodule

