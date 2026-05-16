module placerTest (
    input  wire a,
    output wire y
);

    // internes Signal zwischen den beiden CC_L2T4
    wire sig_1, sig_2;

    // Erste LUT
    CC_L2T4 #(
        .INIT_L00(4'h0), // LUT L00 configuration
        .INIT_L01(4'h0), // LUT L01 configuration
        .INIT_L10(4'h0)  // LUT L10 configuration
    ) l2t4_inst_0 (
        .I0(a),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0),
        .O(sig_1)
    );

    // Zweite LUT, verbunden über internes Signal
    CC_L2T4 #(
        .INIT_L00(4'hF), // Beispielkonfiguration
        .INIT_L01(4'h0),
        .INIT_L10(4'h0)
    ) l2t4_inst_1 (
        .I0(sig_1),
        .I1(1'b0),
        .I2(1'b0),
        .I3(1'b0),
        .O(y)
    );

endmodule