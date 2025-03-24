`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 19:04:46
// Design Name: 
// Module Name: mux3_1
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


module mux3_1(
    input [31:0]a,
    input [31:0]b,
    input [31:0]c,
    input [1:0]op,
    output reg [31:0]d
    );
    always@(*)begin
        case(op)
            2'b00:d<=a;
            2'b01:d<=b;
            2'b10:d<=c;
            default:d<=32'bX;
        endcase
    end
endmodule
