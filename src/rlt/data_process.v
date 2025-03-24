`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 17:56:07
// Design Name: 
// Module Name: data_process
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


module data_process(//处理cache或者内存返回的数据
    input [31:0]dina,
    input [2:0]functM,//ld指令种类判断
    output wire [31:0]douta
    );
//    reg [31:0]data;
    assign douta=(functM==3'b000)?{{24{dina[7]}},dina[7:0]}
                    :((functM==3'b100)?{24'b0,dina[7:0]}
                    :((functM==3'b001)?{{16{dina[15]}},dina[15:0]}
                    :((functM==3'b101)?{16'b0,dina[15:0]}:dina))
                    );
//    always@(functM)begin
//    case(functM)
//                3'b000:begin//lb
//                    assign data={{24{dina[7]}},dina[7:0]};
//                end
//                3'b100:begin//lbu
//                    assign data={24'b0,dina[7:0]};
//                end
//                3'b001:begin//lh
//                    assign data={{16{dina[15]}},dina[15:0]};
//                end
//                3'b101:begin//lhu
//                    assign data={16'b0,dina[15:0]};
//                end
//                3'b010:begin
//                    assign data=dina;
//                end
//            endcase
//      end
//      assign douta=data;
endmodule
