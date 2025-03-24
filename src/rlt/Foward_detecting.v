`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 20:14:53
// Design Name: 
// Module Name: Foward_detecting
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


module Foward_detecting(
    input [4:0]rs1_out,//ID_EX的寄存器堆输入1
    input [4:0]rs2_out,//ID_EX的寄存器堆输入2
    input [4:0]rd_outM,//EX_MEM的写入寄存器地址
    input [4:0]rd_outW,//MEM_WB的写入寄存器地址
    input reg_writeM,//EX_MEM的寄存器堆写使能
    input reg_writeW,//MEM_WB的寄存器堆写使能
    input [2:0]immsetE,//辨别sd的立即数防止前推错误
    input mem_writeE,//判断sd的数据前推
    input ALUsrcE,//判断i型指令，无前推
    output wire [1:0]forwarda,//控制ID_EX的A，决定ALU的第一个输入
    output wire [1:0]forwardb,//控制ID_EX的B，决定ALU的第二个输入
    output wire forwardc//控制B_out，sd数据前推
    );
    reg f0,f1,f2,f3,f4;
    always@(*)begin
        f0=reg_writeM&&(rd_outM!=0)&&(rd_outM==rs1_out);
        f1=reg_writeW&&(rd_outW!=0)&&(rd_outW==rs1_out);
        f2=reg_writeM&&(rd_outM!=0)&&(rd_outM==rs2_out)&&(ALUsrcE==1'b0);
        f3=reg_writeW&&(rd_outW!=0)&&(rd_outW==rs2_out)&&(ALUsrcE==1'b0);
        f4=reg_writeM&&mem_writeE&&(rd_outM==rs2_out)&&(rd_outM!=0);
    end
    assign forwarda=((f0&f1)!=1'b1)?{f1,f0}:{1'b0,f0};
    assign forwardb=((f2&f3)!=1'b1)?{f3,f2}:{1'b0,f2};
    assign forwardc=f4;
endmodule
