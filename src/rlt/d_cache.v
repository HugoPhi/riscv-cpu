`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 22:32:30
// Design Name: 
// Module Name: d_cache
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


module d_cache(
    // risc-v core
    input  wire         rst    ,  // newly add
    input  wire         clka   ,
    input  wire         wea    ,  // write
    input  wire         ena    ,  // read
    input  wire [31:0]  addra  ,
    input  wire [31:0]  dina   ,
    input  wire [2 :0]  functM ,  // ld type
    output wire [31:0]  douta  , 
    output wire         ohit      
);

// d-mem signals declear
wire [31:0] m_odata;
wire [9 :0] m_addr;
wire [0 :0] m_write;
wire [0 :0] m_read;

// Cache config
parameter  INDEX=7, OFFSET = 0;
localparam TAG=32 - INDEX - OFFSET;
localparam LINES= 1 << INDEX;


// Cache body 
// cache line: 
//    valid      tag(32 - index - offset b)           data block(32 b)                   dirty(1 b)      
//       |                      |                            |                               |
//       V                      V                            V                               V
// |  1 bits |   (32 - index - offset) bits    |          32 bits           |             1 bit
reg                 valid     [LINES-1:0];
reg  [TAG-1:0]      ctag      [LINES-1:0];
reg  [31:0]         block     [LINES-1:0];
reg                 dirty     [LINES-1:0];

integer i;
always @(*) begin
    if (rst) begin
        // initial
        for (i = 0; i < LINES; i=i+1) begin
            valid[i] <= 0;
            ctag [i] <= 0;
            block[i] <= 2;
            dirty[i] <= 0;
        end 
    end
end


// decode of input Address, generate new line info
wire [OFFSET-1:0]   offset;
wire [INDEX-1:0]    index;
wire [TAG-1:0]      tag;

//assign offset = addra[OFFSET-1 : 0];
assign index  = addra[INDEX + OFFSET - 1 : OFFSET];
assign tag    = addra[31 : INDEX + OFFSET];


// visit cache line
// load old line
//reg            c_valid;
//reg [TAG-1:0]  c_tag;
//reg [31:0]     c_block;
//reg            c_dirt;

//always @(posedge clka) begin 
//    c_valid <= valid[index];
//    c_tag   <= tag[index];
//    c_block <= block[index];
//    c_dirt  <= dirty[index];
//end

wire            c_valid;
wire [TAG-1:0]  c_tag;
wire [31:0]     c_block;
wire            c_dirt;

assign c_valid = valid[index];
assign c_tag   = ctag[index];
assign c_block = block[index];
assign c_dirt  = dirty[index];


// hit or not
wire hit, miss;
assign hit  = c_valid & (c_tag == tag) & (ena||wea); 
assign miss = ~hit;


// read & write signal 
wire read, write;
assign read  = ena;
assign write = wea;

// update memrey signal
//assign m_write = (write & hit) | (write & miss & c_dirt);
assign m_write = write & miss & c_dirt;
assign m_read  = read & miss;

assign m_addr = {c_tag, index};


// read memrey, including: 
// lb  -> signed   8  bits (extended)
// lbu -> unsigned 8  bits (extended) 
// lh  -> signed   16 bits (extended)
// lhu -> unsigned 16 bits (extended)
// lw  ->          32 bits

// assign data
wire [31:0] read_data_tmp;  // pre-return data
//assign read_data_tmp = hit ? c_block : m_odata;
assign douta = hit ? c_block : m_odata;

//always@(*) begin  // assign data to output
//    case(functM)
//        3'b000:begin  // lb
//            douta <= {{24{read_data_tmp[7]}} , read_data_tmp[7:0]};
//        end
//        3'b100:begin  // lbu
//            douta <= {24'b0                  , read_data_tmp[7:0]};
//        end
//        3'b001:begin  // lh
//            douta <= {{16{read_data_tmp[15]}}, read_data_tmp[15:0]};
//        end
//        3'b101:begin  // lhu
//            douta <= {16'b0                  , read_data_tmp[15:0]};
//        end
//        3'b010:begin  // lw
//            douta <= read_data_tmp;
//        end
//    endcase
//end

// write memrey, including:
// sw  -> 32 bits

blk_mem_gen_0 u_bram(
    .addra(m_addr),
    .clka(clka),
    .dina(dina),
    .ena(m_read),
    .wea(m_write),
    .douta(m_odata)
);


// update Cache
always @(posedge clka) begin 
    if (write) begin
        valid[index] <= 1'b1;
        ctag [index] <= tag;
        block[index] <= dina;
        if (~c_dirt) begin 
            dirty[index] <= 1'b1;
        end
    end else if (read & miss) begin
        valid[index] <= 1'b1;
        ctag [index] <= tag;
        block[index] <= m_odata;
        if (c_dirt) begin
            dirty[index] <= 1'b0;
        end
    end
end


assign ohit = hit;

endmodule