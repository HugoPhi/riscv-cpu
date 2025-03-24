`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/15 18:33:14
// Design Name: 
// Module Name: mux2_1_control
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


module mux2_1_control(
    input [9:0]a,
    input [9:0]b,
    input op,
    output wire [9:0]c
    );
    assign c=(op==1'b0)?a:b;
endmodule
