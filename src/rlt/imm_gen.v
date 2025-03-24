`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 19:06:47
// Design Name: 
// Module Name: imm_gen
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


module imm_gen(
    input [31:0]imm,
    input [2:0]immset,
    output reg [31:0]data
    );
    always@(*)begin
        case(immset)
            3'b000:begin//r,i,ld
                data={{20{imm[31]}},imm[31:20]};
            end
            3'b010:begin//sd
                data={{20{imm[31]}},imm[31:25],imm[11:7]};
            end
            3'b011:begin//b
                data={{20{imm[31]}},imm[31],imm[7],imm[30:25],imm[11:8]};
            end
            3'b101:begin//j
                data={{12{imm[31]}},imm[31],imm[19:12],imm[20],imm[30:21]};
            end
            3'b001:begin//i
                data={{20{imm[31]}},imm[31:20]};
            end
            3'b100:begin//auipc,lui
                data={imm[31:12],{12{1'b0}}};
            end
            3'b110:begin//i
                data={27'b0,imm[24:20]};
            end
            3'b111:begin//jalr
                data={{20{imm[31]}},imm[31:20]};
            end
            default:begin
                data=32'b0;
            end
        endcase
    end
    
    
endmodule
