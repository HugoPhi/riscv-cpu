`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/27 15:38:28
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    input [31:0]addr1,
    input [31:0]addr2,
    input [31:0]addr3,
    input [31:0]addr4,
    input [1:0]pcsrc,
    output wire [31:0]addr5
    );
    assign addr5=(pcsrc==2'b11)?addr4:((pcsrc==2'b10)?addr3:((pcsrc==2'b01)?addr2:addr1));
endmodule
