module placerTestUart (
    input  wire clk,
    output wire uart_tx
);

    // ============================================================
    // UART baud generator
    // 10 MHz / 115200 ≈ 87
    // ============================================================

    localparam CLK_FREQ  = 10000000;
    localparam BAUD_RATE = 115200;
    localparam BAUD_DIV  = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_cnt = 0;
    reg baud_tick = 0;

    always @(posedge clk) begin
        if (baud_cnt == BAUD_DIV-1) begin
            baud_cnt  <= 0;
            baud_tick <= 1;
        end else begin
            baud_cnt  <= baud_cnt + 1;
            baud_tick <= 0;
        end
    end

    // ============================================================
    // Message ROM
    // ============================================================

    reg [7:0] message [0:13];

    initial begin
        message[0]  = "H";
        message[1]  = "e";
        message[2]  = "l";
        message[3]  = "l";
        message[4]  = "o";
        message[5]  = " ";
        message[6]  = "W";
        message[7]  = "o";
        message[8]  = "r";
        message[9]  = "l";
        message[10] = "d";
        message[11] = "!";
        message[12] = 8'h0D; // CR
        message[13] = 8'h0A; // LF
    end

    // ============================================================
    // UART transmitter
    // ============================================================

    reg [3:0] bit_idx = 0;
    reg [7:0] tx_byte = 0;
    reg [9:0] tx_shift = 10'b1111111111;
    reg [3:0] char_idx = 0;
    reg busy = 0;
    reg tx = 1'b1;

    assign uart_tx = tx;

    always @(posedge clk) begin

        if (baud_tick) begin

            if (!busy) begin
                tx_byte  <= message[char_idx];
                tx_shift <= {1'b1, message[char_idx], 1'b0};
                bit_idx  <= 0;
                busy     <= 1;

                if (char_idx == 13)
                    char_idx <= 0;
                else
                    char_idx <= char_idx + 1;

            end else begin

                tx <= tx_shift[0];
                tx_shift <= {1'b1, tx_shift[9:1]};

                if (bit_idx == 9) begin
                    busy <= 0;
                end else begin
                    bit_idx <= bit_idx + 1;
                end
            end
        end
    end

endmodule