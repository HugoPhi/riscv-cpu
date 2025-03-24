`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 20:14:21
// Design Name: 
// Module Name: Hazard_detecting
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


module Hazard_detecting(
    input clk,
    input cmp,
    input cache_hit,//cache是否命中
    input [4:0]rd_out,//ID_EX的rd
    input [4:0]rd_outM,//EEX/MEM的rd
    input [31:0]instr_out,//IF_ID的指令
    input mem_readE,//ID_EX的读使能,判断是否为ld指令
    input mem_readM,//EX/MEM的读使能，判断是否为ld指令
    input [2:0]funct_b,
    input branch,
    output wire hazard,//hit情况下ld-use冒险信号
    output wire hazard_ld//miss情况下ld-use冒险信号
    );
    assign hazard=(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))?1'b1:1'b0;
    assign hazard_ld=(!cache_hit)?((mem_readM&&((rd_outM==instr_out[19:15])||(rd_outM==instr_out[24:20])))?1'b1
                        :((!cache_hit&&mem_readM)?1'b1:1'b0)):1'b0;
//    always@(*)begin
//        //if(cache_hit)begin//命中，一个cycle取数据，处理策略不变
//        //对于ld-use判断在EX阶段执行，不需要提前得知cache是否命中
//            if(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))begin//发生冒险
//                hazard<=1'b1;
//            end else begin//无冒险
//                hazard<=1'b0;
//            end
//        //end
//        if(!cache_hit)begin//未命中，阻塞流水线
//            if(mem_readE&&((rd_out==instr_out[19:15])||(rd_out==instr_out[24:20])))begin//发生first冒险，插入两条nop
//                hazard_ld<=2'b1;
//            end
//            else if(mem_readM&&((rd_outM==instr_out[19:15])||(rd_outM==instr_out[24:20])))begin//发生second冒险，插入一条nop,保持EX阶段及向前所有阶段信号
//                hazard_ld<=2'b1;                
//            end else begin//无冒险
//                hazard_ld<=2'b0;
//            end
//        end
//    end
endmodule
