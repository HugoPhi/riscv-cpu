`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 18:54:52
// Design Name: 
// Module Name: LAB1ALU
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


module ALU(
    input [31:0]num1,//rs1
    input [31:0]num2,//rs2
    input [3:0]alucontrol,
    output wire zero,
    output reg [31:0]rlt
    );
    assign zero=(num1-num2)?1'b0:1'b1;
    reg [31:0]tmp;
    integer i;
    always@(*)begin
        case(alucontrol)
            4'b0001:begin
                rlt=num1+num2;
            end
            4'b0010:begin
                rlt=num1-num2;
            end
            4'b0011:begin
                rlt=num1&num2;
            end
            4'b0100:begin
                rlt=num1|num2;
            end
            4'b0101:begin
                rlt=num1^num2;
            end
            4'b0110:begin
                rlt=num1<<num2;
            end
            4'b0111:begin
                rlt=num1>>num2;
            end
            4'b1000:begin
                //rlt=num1>>>num2;
//                for(i=num2;i<=0;i=i-1)begin
//                    rlt={num1[31],num1[31:1]};
//                end
                //rlt={{num2{num1[31]}},num1[31:1]};
                rlt=(num1[31]==1'b1)?~((~num1)>>num2):(num1>>num2);
            end
            4'b1001:begin
                rlt=(num1<num2)?32'b1:32'b0;
            end
            4'b1010:begin
                tmp=num1-num2;
                if(tmp<0)begin
                    rlt=32'b1;
                end
                else begin
                    rlt=32'b0;
                end
            end
            4'b0000:begin
                rlt=num2;
            end
            4'b1011:begin
                rlt=(num1<num2)?num2:num1;
            end
            default:begin
                rlt=32'bx;
            end
        endcase
    end
endmodule
