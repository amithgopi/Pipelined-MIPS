`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2021 11:27:46 AM
// Design Name: 
// Module Name: ForwardingUnit
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

//AluOpCtrl
// 2 = Ex stage forwarding
// 3 = Mem Stage Forwarding
// 1 = Use Shamt of Immed
// 0 = Use default reg values

module ForwardingUnit(UseShamt, UseImmed, ID_Rs, ID_Rt, EX_Rw, MEM_Rw, EX_RegWrite, MEM_RegWrite, AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM);
//Define inputs and ouputs
input UseShamt, UseImmed;
input [4:0] ID_Rs, ID_Rt, EX_Rw, MEM_Rw;
input EX_RegWrite, MEM_RegWrite;
output reg [1:0] AluOpCtrlA, AluOpCtrlB;
output reg DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM;

always @* begin
    //For ALU input A
    if(UseShamt == 1'b0) begin
        if(ID_Rs == EX_Rw && EX_Rw != 0 && EX_RegWrite == 1'b1) begin
            AluOpCtrlA = 2;
        end
        else if(ID_Rs == MEM_Rw && MEM_Rw != 0 && MEM_RegWrite == 1'b1) begin
            AluOpCtrlA = 3;
        end
        else AluOpCtrlA = 0;
    end
    else AluOpCtrlA = 1;
    //For ALU input B
    if(UseImmed == 1'b0) begin
        if(ID_Rt == EX_Rw && EX_Rw != 0 && EX_RegWrite == 1'b1) begin
            AluOpCtrlB = 2;
        end
        else if(ID_Rt == MEM_Rw && MEM_Rw != 0 && MEM_RegWrite == 1'b1) begin
            AluOpCtrlB = 3;
        end
        else AluOpCtrlB = 0;
    end
    else AluOpCtrlB = 1;
    //For data memory forwarding
    if(MEM_RegWrite == 1'b1 && ID_Rt == MEM_Rw) begin           //Forward to EX
        DataMemForwardCtrl_EX = 1;
        DataMemForwardCtrl_MEM = 0;
    end
    else if(EX_RegWrite == 1'b1 && ID_Rt == EX_Rw) begin        //Forward to MEM
        DataMemForwardCtrl_EX = 0;
        DataMemForwardCtrl_MEM = 1;
   end
   else begin                                                   //Default state
        DataMemForwardCtrl_EX = 0;
        DataMemForwardCtrl_MEM = 0;
   end
    
        
end

endmodule