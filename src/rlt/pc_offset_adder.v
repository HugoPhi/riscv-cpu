`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/30 15:08:37
// Design Name: 
// Module Name: pc_offset_adder
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


module pc_offset_adder(
    input [31:0]pc_out,//视为大于0数
    input [31:0]imm,//视为有符号数，且为补码表示
    output [31:0]rlt
    );
    //由于跳转指令偏移量默认instr指令为4个一组储存，因此对imm需要右移两位
    wire [31:0]imm_tmp;
    assign imm_tmp={{2{imm[31]}},imm[31:2]};
    assign rlt=pc_out+imm_tmp;
endmodule
