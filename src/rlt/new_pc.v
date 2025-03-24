`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 19:51:25
// Design Name: 
// Module Name: new_pc
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


module new_pc(
    input clk,
    input rst,
    input [31:0] addr,//输入地址
    //input [7:0] addr,
    input hazard,//冒险保持信号
    input hazard_ld,//cachemiss下stall
    output reg inst_ce,//指令存储器读信号
    //output reg [7:0]pc
    output wire [31:0]pc//输出地址
    );
    reg flag;//检测地址选择器是否有输出信号
    //reg hazard_buff;
    reg [31:0]pc_buff;
    always@(posedge clk or posedge rst)begin
        //hazard_buff=hazard;
        if(rst)begin
            pc_buff<=32'b0;
            //pc<=8'b0;
            inst_ce<=1'b1;
            //flag<=1'b0;
        end
        else begin
//            if(flag&(!hazard))begin
//                pc_buff<=addr;
//            end
            if(hazard||hazard_ld)begin
                pc_buff<=pc_buff;
            end else begin
                pc_buff<=addr;
            end
//            else begin
//                if(!flag)begin
//                    flag<=1'b1;
//                    pc_buff<=32'b0;
//                    //pc<=8'b0;
//                end
//                else if(hazard)begin
//                    pc<=pc;
//                    //hazard_buff<=1'b0;
//                end
        end
        inst_ce<=1'b1;
    end
    assign pc=pc_buff;
endmodule
