`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 20:25:59
// Design Name: 
// Module Name: alu_control
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

module alu_control(
    input [1:0]aluop,//main控制的指令
    input [3:0]funct,//指令的function字段
    output reg [3:0]alucontrol//输出的alu控制信号
    );
    always@(*)begin
        case(aluop)
            2'b11:begin
                alucontrol<=4'b0000;//旁路
            end
            2'b10:begin
                case(funct)
                    4'b0000:begin
                        alucontrol<=4'b0001;//add操作
                    end
                    4'b1000:begin
                        alucontrol<=4'b0010;//sub操作
                    end
                    4'b0111:begin
                        alucontrol<=4'b0011;//and操作
                    end
                    4'b0110:begin
                        alucontrol<=4'b0100;//or操作
                    end
                    4'b0100:begin
                        alucontrol<=4'b0101;//xor操作
                    end
                    4'b0001:begin
                        alucontrol<=4'b0110;//sll操作
                    end
                    4'b0101:begin
                        alucontrol<=4'b0111;//srl操作
                    end
                    4'b1101:begin
                        alucontrol<=4'b1000;//sra操作
                    end
                    4'b0010:begin
                        alucontrol<=4'b1001;//sltu操作
                    end
                    4'b0011:begin
                        alucontrol<=4'b1010;//slt操作
                    end
                    4'b1010:begin
                        alucontrol<=4'b1011;
                    end
                    default:begin
                        alucontrol<=4'b1111;
                    end
                endcase
            end
            2'b01:begin
                alucontrol<=4'b0010;//sub操作
//                case(funct)
//                    4'b0000:begin
//                        alucontrol<=4'b0010;//sub操作
//                    end
//                    4'b0101:begin
//                        alucontrol<=4'b1010;//>=操作(sign)
//                    end
//                    4'b0111:begin
//                        alucontrol<=4'b1001;//>=操作(unsign)
//                    end
//                    4'b0100:begin
//                        alucontrol<=4'b1010;//<操作(sign)
//                    end
//                    4'b0110:begin
//                        alucontrol<=4'b1001;//<操作(unsign)
//                    end
//                    4'b0001:begin
//                        alucontrol<=4'b0010;//!=操作
//                    end
//                endcase
            end
            2'b00:begin
                alucontrol<=4'b0001;//add操作
            end
        endcase
    end
endmodule
