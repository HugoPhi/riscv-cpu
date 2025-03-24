`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 19:56:10
// Design Name: 
// Module Name: mux2_1
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


module mux2_1(
    input [31:0] addr1,//pc+4
    input [31:0] addr2,//pc+offset
    input opt,
    output wire [31:0] addr3
    );
//    always@(*)begin
//        case(opt)
//            1'b0:begin
//                addr3<=addr1;
//            end
//            1'b1:begin
//                addr3<=addr2;
//            end
//        endcase
//    end
    assign addr3=(opt==1'b1)?addr2:addr1;
endmodule
