`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 19:37:10
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input clk,
    input rst,
    input reg_writeM,
    input [1:0]reg_srcM,
    output reg reg_writeW,
    output reg [1:0]reg_srcW,
    input [31:0]read_data,//数据寄存器读出的数据
    input [31:0]rlt_outM,//EX_MEM保存的alu输出
    input [4:0]rd_outM,//EX_MEM保存的写入寄存器地址
    output reg [31:0]lwd,//保存数据寄存器读出的数据
    output reg [31:0]rlt_outW,
    output reg [4:0]rd_outW,
    input [31:0]pc_4M,
    input [31:0]pc_immM,
    output reg [31:0]pc_4W,
    output reg [31:0]pc_immW,
    input hazard_ld
    );
    always@(posedge clk)begin
        if(rst)begin
            reg_writeW<=1'b0;
            reg_srcW<=2'b0;
            lwd<=32'b0;
            rlt_outW<=32'b0;
            rd_outW<=5'b0;
            pc_4W<=32'b0;
            pc_immW<=32'b0;
        end
        else if(hazard_ld)begin
            reg_writeW<=reg_writeW;
            reg_srcW<=reg_srcW;
            lwd<=lwd;
            rlt_outW<=rlt_outW;
            rd_outW<=rd_outW;
            pc_4W<=pc_4W;
            pc_immW<=pc_immW;
        end
        else begin
            reg_writeW<=reg_writeM;
            reg_srcW<=reg_srcM;
            lwd<=read_data;
            rlt_outW<=rlt_outM;
            rd_outW<=rd_outM;
            pc_4W<=pc_4M;
            pc_immW<=pc_immM;
        end
    end
endmodule
