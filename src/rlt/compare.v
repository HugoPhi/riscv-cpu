`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/11 20:19:03
// Design Name: 
// Module Name: compare
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


module compare(
    input [31:0]rd1,
    input [31:0]rd2,
    input [2:0]funct_b,
    output reg cmp
    );
    reg [31:0]tmp;
    reg sign1,sign2;
    always@(*)begin
        sign1=rd1[31];
        sign2=rd2[31];
        case(funct_b)
            3'b000:begin//beq
                if(rd1==rd2)begin
                    cmp<=1'b1;
                end
                else begin
                    cmp<=1'b0;
                end
            end
            3'b101:begin//bge
                if(sign1^sign2)begin//ÒìºÅ
                    if(sign1)begin//rd1<0
                        cmp=1'b0;
                    end else begin
                        cmp=1'b1;
                    end
                end else begin//Í¬ºÅ
                    if(rd1<rd2)begin
                        cmp=1'b0;
                    end else begin
                        cmp=1'b1;
                    end
                end
            end
            3'b111:begin//bgeu
                if(rd1>=rd2)begin
                    cmp<=1'b1;
                end
                else begin
                    cmp<=1'b0;
                end
            end
            3'b100:begin//blt
                if(sign1^sign2)begin//ÒìºÅ
                    if(sign1)begin//rd1<0
                        cmp=1'b1;
                    end else begin
                        cmp=1'b0;
                    end
                end else begin//Í¬ºÅ
                    if(rd1<rd2)begin
                        cmp=1'b1;
                    end else begin
                        cmp=1'b0;
                    end
                end
            end
            3'b110:begin//bltu
                if(rd1<rd2)begin
                    cmp<=1'b1;
                end
                else begin
                    cmp<=1'b0;
                end
            end
            3'b001:begin//bne
                if(rd1!=rd2)begin
                    cmp<=1'b1;
                end
                else begin
                    cmp<=1'b0;
                end
            end
            default:begin
                cmp<=1'b0;
            end
        endcase
    end
endmodule
