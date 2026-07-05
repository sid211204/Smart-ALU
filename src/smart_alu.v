`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 02:56:30 PM
// Design Name: 
// Module Name: smart_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module smart_alu #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [3:0] sel,

    input  wire signed_mode,
    input  wire saturation_mode,
    input  wire approx_mode,
    input  wire low_power_mode,

    output reg  [2*WIDTH-1:0] out,
    output reg zero_flag,
    output reg carry_flag,
    output reg overflow_flag,
    output reg div_zero_flag
);

    integer i;

    reg [WIDTH:0] temp;
    reg [WIDTH-1:0] add_result;
    reg [WIDTH-1:0] sat_max;
    reg [WIDTH-1:0] sat_min;

    always @(*) begin
        out = 0;
        zero_flag = 0;
        carry_flag = 0;
        overflow_flag = 0;
        div_zero_flag = 0;

        sat_max = {1'b0, {(WIDTH-1){1'b1}}};
        sat_min = {1'b1, {(WIDTH-1){1'b0}}};

        if (low_power_mode) begin
            out = 0;
        end
        else begin
            case(sel)

                // ADD
                4'b0000: begin
                    if (approx_mode) begin
                        // approximate add: lower 2 bits ignored
                        add_result = {a[WIDTH-1:2] + b[WIDTH-1:2], 2'b00};
                        out = add_result;
                    end
                    else begin
                        temp = a + b;
                        carry_flag = temp[WIDTH];
                        add_result = temp[WIDTH-1:0];

                        if (signed_mode) begin
                            overflow_flag =
                                (~a[WIDTH-1] & ~b[WIDTH-1] & add_result[WIDTH-1]) |
                                ( a[WIDTH-1] &  b[WIDTH-1] & ~add_result[WIDTH-1]);

                            if (saturation_mode && overflow_flag) begin
                                if (a[WIDTH-1] == 0 && b[WIDTH-1] == 0)
                                    out = sat_max;
                                else
                                    out = sat_min;
                            end
                            else begin
                                out = add_result;
                            end
                        end
                        else begin
                            if (saturation_mode && carry_flag)
                                out = {WIDTH{1'b1}};
                            else
                                out = add_result;
                        end
                    end
                end

                // SUB
                4'b0001: begin
                    temp = a - b;
                    out = temp[WIDTH-1:0];
                    carry_flag = temp[WIDTH];
                end

                // MUL
                4'b0010: begin
                    out = a * b;
                end

                // DIV
                4'b0011: begin
                    if (b == 0) begin
                        div_zero_flag = 1;
                        out = 0;
                    end
                    else begin
                        out = a / b;
                    end
                end

                // BARREL LEFT SHIFT
                4'b0100: begin
                    out = a << b[$clog2(WIDTH)-1:0];
                end

                // BARREL RIGHT SHIFT
                4'b0101: begin
                    out = a >> b[$clog2(WIDTH)-1:0];
                end

                // ROTATE LEFT BY 1
                4'b0110: begin
                    out = {a[WIDTH-2:0], a[WIDTH-1]};
                end

                // ROTATE RIGHT BY 1
                4'b0111: begin
                    out = {a[0], a[WIDTH-1:1]};
                end

                // AND
                4'b1000: begin
                    out = a & b;
                end

                // OR
                4'b1001: begin
                    out = a | b;
                end

                // XOR
                4'b1010: begin
                    out = a ^ b;
                end

                // NAND
                4'b1011: begin
                    out = ~(a & b);
                end

                // NOR
                4'b1100: begin
                    out = ~(a | b);
                end

                // XNOR
                4'b1101: begin
                    out = ~(a ^ b);
                end

                // GREATER THAN
                4'b1110: begin
                    if (signed_mode)
                        out = ($signed(a) > $signed(b)) ? 1 : 0;
                    else
                        out = (a > b) ? 1 : 0;
                end

                // EQUAL
                4'b1111: begin
                    out = (a == b) ? 1 : 0;
                end

                default: begin
                    out = 0;
                end

            endcase
        end

        if (out == 0)
            zero_flag = 1;
    end

endmodule
