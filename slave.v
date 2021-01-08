`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/19 12:22:23
// Design Name: 
// Module Name: slave
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


module slave(PCLK,PRST,PSELx,PWRITE,PADDR,PWDATA,PRDATA,PENABLE,SETUP);
    input PCLK;
    input PRST;
    input PSELx;

    input PWRITE;
    input [31:0]PADDR;
    input [31:0]PWDATA;
    output reg [31:0]PRDATA;
    output reg PENABLE;
    output reg SETUP;

    reg [31:0] mema[15:0];
    reg PSEL;    
    //初始化penable为1
    initial begin
        PENABLE = 1;
    end

    //从建立状态到传输状态
    always @(posedge PCLK)
    begin
        PSEL <= PSELx;
        if(~PRST)begin
            if (PENABLE) begin
                PENABLE <= 0;
                PSEL <= 0;
            end
            else PENABLE <= 0;
            if (PSEL&SETUP) begin
                PENABLE <= 1;
                SETUP <= 0;
            end
            else PENABLE <= 0;
            if (PSELx&(~PENABLE)) SETUP = 1;
            else SETUP = 0;
        end
        else begin
            PENABLE <= 0;
            SETUP <= 0;
        end 
    end

    //penable拉低后关断PRADATA
    always @(negedge PENABLE)begin
        PRDATA <= 32'bz;
    end

    //输出部分-读
    always @(posedge PENABLE)
    begin
        if (~PWRITE)
        begin
            if(PSEL)begin
                case (PADDR[5:0])
                6'b000000:PRDATA<=mema[0];
                6'b000100:PRDATA<=mema[1];
                6'b001000:PRDATA<=mema[2];
                6'b001100:PRDATA<=mema[3];
                6'b010000:PRDATA<=mema[4];
                6'b010100:PRDATA<=mema[5];
                6'b011000:PRDATA<=mema[6];
                6'b011100:PRDATA<=mema[7];
                6'b100000:PRDATA<=mema[8];
                6'b100100:PRDATA<=mema[9];
                6'b101000:PRDATA<=mema[10];
                6'b101100:PRDATA<=mema[11];
                6'b110000:PRDATA<=mema[12];
                6'b110100:PRDATA<=mema[13];
                6'b111000:PRDATA<=mema[14];
                6'b111100:PRDATA<=mema[15];
                default:PRDATA<=32'bz;
                endcase
            end
            else PRDATA<=32'bz;
        end
        //输出部分-写
        else if (PWRITE)
        begin
            if(PSEL)begin
                PRDATA = 32'bz;
                case (PADDR[5:0])
                    6'b000000:mema[0]<=PWDATA;
                    6'b000100:mema[1]<=PWDATA;
                    6'b001000:mema[2]<=PWDATA;
                    6'b001100:mema[3]<=PWDATA;
                    6'b010000:mema[4]<=PWDATA;
                    6'b010100:mema[5]<=PWDATA;
                    6'b011000:mema[6]<=PWDATA;
                    6'b011100:mema[7]<=PWDATA;
                    6'b100000:mema[8]<=PWDATA;
                    6'b100100:mema[9]<=PWDATA;
                    6'b101000:mema[10]<=PWDATA;
                    6'b101100:mema[11]<=PWDATA;
                    6'b110000:mema[12]<=PWDATA;
                    6'b110100:mema[13]<=PWDATA;
                    6'b111000:mema[14]<=PWDATA;
                    6'b111100:mema[15]<=PWDATA;
                endcase
            end
        end
        else PRDATA<=32'bz;
    end

endmodule
