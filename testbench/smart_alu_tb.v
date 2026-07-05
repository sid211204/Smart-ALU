`timescale 1ns / 1ps

module smartalu_tb;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] a;
    reg  [WIDTH-1:0] b;
    reg  [3:0] sel;

    reg signed_mode;
    reg saturation_mode;
    reg approx_mode;
    reg low_power_mode;

    wire [2*WIDTH-1:0] out;
    wire zero_flag;
    wire carry_flag;
    wire overflow_flag;
    wire div_zero_flag;

    smart_alu #(WIDTH) uut (
        .a(a),
        .b(b),
        .sel(sel),
        .signed_mode(signed_mode),
        .saturation_mode(saturation_mode),
        .approx_mode(approx_mode),
        .low_power_mode(low_power_mode),
        .out(out),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .div_zero_flag(div_zero_flag)
    );

    initial begin
        a = 0;
        b = 0;
        sel = 0;
        signed_mode = 0;
        saturation_mode = 0;
        approx_mode = 0;
        low_power_mode = 0;

        // ADD
        a = 8'd10; b = 8'd20; sel = 4'b0000;
        #10;

        // UNSIGNED ADD WITH CARRY
        a = 8'd250; b = 8'd10; sel = 4'b0000;
        #10;

        // SIGNED ADD OVERFLOW WITHOUT SATURATION
        signed_mode = 1;
        saturation_mode = 0;
        a = 8'b01111111; // +127
        b = 8'b00000001; // +1
        sel = 4'b0000;
        #10;

        // SIGNED ADD OVERFLOW WITH SATURATION
        saturation_mode = 1;
        a = 8'b01111111; // +127
        b = 8'b00000001; // +1
        sel = 4'b0000;
        #10;

        // SIGNED NEGATIVE OVERFLOW WITH SATURATION
        a = 8'b10000000; // -128
        b = 8'b11111111; // -1
        sel = 4'b0000;
        #10;

        // APPROXIMATE ADD
        signed_mode = 0;
        saturation_mode = 0;
        approx_mode = 1;
        a = 8'd15;
        b = 8'd10;
        sel = 4'b0000;
        #10;

        approx_mode = 0;

        // SUB
        a = 8'd50; b = 8'd20; sel = 4'b0001;
        #10;

        // MUL
        a = 8'd10; b = 8'd5; sel = 4'b0010;
        #10;

        // DIV
        a = 8'd40; b = 8'd5; sel = 4'b0011;
        #10;

        // DIVIDE BY ZERO
        a = 8'd40; b = 8'd0; sel = 4'b0011;
        #10;

        // BARREL LEFT SHIFT
        a = 8'b00001111;
        b = 8'd2;
        sel = 4'b0100;
        #10;

        // BARREL RIGHT SHIFT
        a = 8'b11110000;
        b = 8'd3;
        sel = 4'b0101;
        #10;

        // ROTATE LEFT
        a = 8'b10000001;
        sel = 4'b0110;
        #10;

        // ROTATE RIGHT
        a = 8'b10000001;
        sel = 4'b0111;
        #10;

        // AND
        a = 8'b10101010;
        b = 8'b11001100;
        sel = 4'b1000;
        #10;

        // OR
        sel = 4'b1001;
        #10;

        // XOR
        sel = 4'b1010;
        #10;

        // NAND
        sel = 4'b1011;
        #10;

        // NOR
        sel = 4'b1100;
        #10;

        // XNOR
        sel = 4'b1101;
        #10;

        // GREATER THAN UNSIGNED
        signed_mode = 0;
        a = 8'd20;
        b = 8'd10;
        sel = 4'b1110;
        #10;

        // GREATER THAN SIGNED
        signed_mode = 1;
        a = 8'b11111111; // -1
        b = 8'b00000001; // +1
        sel = 4'b1110;
        #10;

        // EQUAL
        a = 8'd25;
        b = 8'd25;
        sel = 4'b1111;
        #10;

        // LOW POWER MODE
        low_power_mode = 1;
        a = 8'd100;
        b = 8'd50;
        sel = 4'b0000;
        #10;

        low_power_mode = 0;

        $finish;
    end

endmodule
