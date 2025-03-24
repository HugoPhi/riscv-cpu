`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 19:24:48
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input clk,
    input rst,
    input reg_writeE,
    input [1:0]reg_srcE,
    input mem_readE,
    input mem_writeE,
    //input branchE,
    output reg reg_writeM,
    output reg [1:0]reg_srcM,
    output reg mem_readM,
    output reg mem_writeM,
    //output reg branchM,
    input [31:0]rlt,//ALU的输出
    input [31:0]B,//ID_EX的rd2输出
    input [4:0]rd_out,//ID_EX的写入寄存器地址输出
    output reg [31:0]rlt_outM,
    output reg [31:0]B_out,
    output reg [4:0]rd_outM,
    input [2:0]functE,
    output reg [2:0]functM,
    input [31:0]pc_4E,
    input [31:0]pc_immE,
    output reg [31:0]pc_4M,
    output reg [31:0]pc_immM,
    input hazard_ld
    );
    always@(posedge clk)begin
        if(rst)begin
            reg_writeM<=1'b0;
            reg_srcM<=2'b0;
            mem_readM<=1'b0;
            mem_writeM<=1'b0;
            //branchM<=1'b0;
            B_out<=32'b0;
            rlt_outM<=32'b0;
            rd_outM<=5'b0;
            functM<=3'b0;
            pc_4M<=32'b0;
            pc_immM<=32'b0;
        end
        else if(hazard_ld)begin
            reg_writeM<=reg_writeM;
            reg_srcM<=reg_srcM;
            mem_readM<=1'b0;//由于进行了两次ld，相当于第二次ld是一个nop，不读取数据，其他信号不变，保证ld的控制信号与数据同步
            mem_writeM<=mem_writeM;
            //branchM<=1'b0;
            B_out<=B_out;
            rlt_outM<=rlt_outM;
            rd_outM<=rd_outM;
            functM<=functM;
            pc_4M<=pc_4M;
            pc_immM<=pc_immM;
        end
        else begin
            reg_writeM<=reg_writeE;
            reg_srcM<=reg_srcE;
            mem_readM<=mem_readE;
            mem_writeM<=mem_writeE;
            //branchM<=branchE;
            B_out<=B;
            rlt_outM<=rlt;
            rd_outM<=rd_out;
            functM<=functE;
            pc_4M<=pc_4E;
            pc_immM<=pc_immE;
        end
    end
endmodule
