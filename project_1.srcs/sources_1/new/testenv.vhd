----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2022 02:23:02 PM
-- Design Name: 
-- Module Name: testenv - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testenv is
  Port (
  clk : in std_logic;
  buton : in std_logic;
  btn : in std_logic_vector(4 downto 0);
  sw : in std_logic_vector(15 downto 0);
  led : out std_logic_vector(15 downto 0);
  an : out std_logic_vector(3 downto 0);
  cat : out std_logic_vector(6 downto 0)
   );
end testenv;

architecture Behavioral of testenv is

component SSD is
    Port(
        digit0 : in STD_LOGIC_VECTOR(3 downto 0);
        digit1 : in STD_LOGIC_VECTOR(3 downto 0);
        digit2 : in STD_LOGIC_VECTOR(3 downto 0);
        digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        clk : in STD_LOGIC;
        cat : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

component MPG is  
    Port ( clk : in STD_LOGIC;
           buton: in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           enn: out std_logic;
           sw : in STD_LOGIC_VECTOR (15 downto 0));       
end component;

component pc is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  pcWrite : in std_logic;
  pcIn : in std_logic_vector(15 downto 0);
  pcOut : out std_logic_vector(15 downto 0)
   );
end component;

component mem is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  we : in std_logic;
  address : in std_logic_vector(15 downto 0);
  dataIn : in std_logic_vector(15 downto 0);
  dataOut : out std_logic_vector(15 downto 0) 
   );
end component;

component reg is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  rWrite : in std_logic;
  dataIn : in std_logic_vector(15 downto 0);
  dataOut : out std_logic_vector(15 downto 0)
   );
end component;

component instreg is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  irWrite : in std_logic;
  instruction : in std_logic_vector(15 downto 0);
  instr15_13 : out std_logic_vector(2 downto 0);
  instr12_10 : out std_logic_vector(2 downto 0);
  instr9_7 : out std_logic_vector(2 downto 0);
  instr6_0 : out std_logic_vector(6 downto 0);
  instr12_0 : out std_logic_vector(12 downto 0)
   );
end component;

component regfile is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  regWrite : in std_logic;
  readAddress1 : in std_logic_vector(2 downto 0);
  readAddress2 : in std_logic_vector(2 downto 0);
  writeAddress : in std_logic_vector(2 downto 0);
  writeData : in std_logic_vector(15 downto 0);
  readData1 : out std_logic_vector(15 downto 0);
  readData2 : out std_logic_vector(15 downto 0);
  debug1 : out std_logic_vector(15 downto 0);
  debug2 : out std_logic_vector(15 downto 0);
  debug3 : out std_logic_vector(15 downto 0)
   );
end component;

component alu is
  Port (
  a : in std_logic_vector(15 downto 0);
  b : in std_logic_vector(15 downto 0);
  aluOp : in std_logic_vector(3 downto 0);
  result : out std_logic_vector(15 downto 0);
  zero : out std_logic
   );
end component;

component uc is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  opcode : in std_logic_vector(2 downto 0);
  func : in std_logic_vector(3 downto 0);
  pcWrite, memWrite, irWrite, mdrWrite, regWrite, aluOutWrite, aWrite, bWrite, memAddr, memToReg, regDst, jump, jreg, branch, aluSrcA : out std_logic;
  aluSrcB: out std_logic_vector(1 downto 0);
  aluOp : out std_logic_vector(3 downto 0)
   );
end component;

component control1 is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  opcode : in std_logic_vector(2 downto 0);
  func : in std_logic_vector(3 downto 0);
  pcWrite, memWrite, irWrite, mdrWrite, regWrite, aluOutWrite, aWrite, bWrite, memAddr, memToReg, regDst, jump, jreg, branch, aluSrcA : out std_logic;
  aluSrcB: out std_logic_vector(1 downto 0);
  aluOp : out std_logic_vector(3 downto 0)
   );
end component;

-- debouncer sigs
signal buttonEnnSig : std_logic := '0';

-- pc signals
signal pcOutSig, pcInSig : std_logic_vector(15 downto 0) := x"0000";
signal pcWriteSig : std_logic := '0';

-- mem signals
signal addressSig, dataOutSig : std_logic_vector(15 downto 0) := x"0000";
signal memWriteSig : std_logic := '0';

-- a and b regs signals
signal aSig, bSig : std_logic_vector(15 downto 0) := x"0000";
signal aWriteSig, bWriteSig : std_logic := '0';

-- alu signals
signal aluOperandASig, aluOperandBSig, resultSig : std_logic_vector(15 downto 0) := x"0000";
signal aluOpSig : std_logic_vector(3 downto 0) := "0000";
signal zeroSig : std_logic := '0';

-- aluOut reg signals
signal aluOutSig : std_logic_vector(15 downto 0) := x"0000";
signal aluOutWriteSig : std_logic := '0';

-- register block signals
signal writeAddrSig : std_logic_vector(2 downto 0) := "000";
signal readASig, readBSig, writeDataRegSig : std_logic_vector(15 downto 0) := x"0000";
signal regWriteSig : std_logic := '0';

-- instruction register signals
signal irWriteSig : std_logic := '0';
signal instr15_13Sig, instr12_10Sig, instr9_7Sig : std_logic_vector(2 downto 0) := "000"; 
signal instr6_0Sig : std_logic_vector(6 downto 0) := "0000000";
signal instr12_0Sig : std_logic_vector(12 downto 0) := "0000000000000";

-- memory data register signals
signal mdrSig : std_logic_vector(15 downto 0) := x"0000";
signal mdrWriteSig : std_logic := '0';

-- multiplexers signals
signal memAddrSig, memToRegSig, regDstSig, aluSrcASig : std_logic := '0';
signal aluSrcBSig : std_logic_vector(1 downto 0) := "00";
 
-- extender and func signals
-- de verificat astea
signal extImm : std_logic_vector(15 downto 0) := x"0000";
signal funcSig : std_logic_vector(3 downto 0) := "0000";
signal rdSig : std_logic_vector(2 downto 0) := "000";

-- jump and branch signals
signal jumpSig, jregSig, branchSig, branchMuxSelSig : std_logic := '0';
signal jumpMuxSig, jregMuxSig, branchMuxSig : std_logic_vector(15 downto 0) := x"0000";
signal jumpExtSig, branchSumSig : std_logic_vector(15 downto 0) := x"0000";
 
signal displaySig : std_logic_vector(15 downto 0) := x"0000";
signal debug1Sig, debug2Sig, debug3Sig : std_logic_vector(15 downto 0) := x"0000"; 

signal pcAddSig : std_logic_vector(15 downto 0) := x"0000";

begin

Debouncer: mpg port map (clk, btn(0), btn, buttonEnnSig, sw);

ProgramCounter: pc port map (clk, buttonEnnSig, pcWriteSig, pcInSig, pcOutSig);

Memory: mem port map (clk, buttonEnnSig, memWriteSig, addressSig, bSig, dataOutSig);

ArithmeticLogic: alu port map (aluOperandASig, aluOperandBSig, aluOpSig, resultSig, zeroSig);

ALUOutRegister: reg port map (clk, buttonEnnSig, aluOutWriteSig, resultSig, aluOutSig);

AReg: reg port map (clk, buttonEnnSig, aWriteSig, readASig, aSig);

BReg: reg port map (clk, buttonEnnSig, bWriteSig, readBSig, bSig);

RegisterBlock: regfile port map (clk, buttonEnnSig, regWriteSig, instr12_10Sig, instr9_7Sig, writeAddrSig, writeDataRegSig, readASig, readBSig, debug1Sig, debug2Sig, debug3Sig);

InstructionRegister: instreg port map (clk, buttonEnnSig, irWriteSig, dataOutSig, instr15_13Sig, instr12_10Sig, instr9_7Sig, instr6_0Sig, instr12_0Sig);

MemoryDataRegister: reg port map (clk, buttonEnnSig, mdrWriteSig, dataOutSig, mdrSig);

ContolUnit: uc port map (clk, buttonEnnSig, instr15_13Sig, funcSig, 
pcWriteSig, memWriteSig, irWriteSig, mdrWriteSig, regWriteSig, aluOutWriteSig, aWriteSig, bWriteSig,
memAddrSig, memToRegSig, regDstSig, jumpSig, jregSig, branchSig, aluSrcASig, aluSrcBSig, aluOpSig);

--ContolUnit: control1 port map (clk, buttonEnnSig, instr15_13Sig, funcSig, 
--pcWriteSig, memWriteSig, irWriteSig, mdrWriteSig, regWriteSig, aluOutWriteSig, aWriteSig, bWriteSig,
--memAddrSig, memToRegSig, regDstSig, jumpSig, jregSig, branchSig, aluSrcASig, aluSrcBSig, aluOpSig);

-- Multiplexer processes
MemAddrMux: process(pcOutSig, aluOutSig, memAddrSig)
begin
    case memAddrSig is
        when '0' => addressSig <= pcOutSig;
        when others => addressSig <= aluOutSig;
    end case;
end process;

MemToRegMux: process(aluOutSig, mdrSig, memToRegSig)
begin
    case memToRegSig is
        when '0' => writeDataRegSig <= aluOutSig;
        when others => writeDataRegSig <= mdrSig;
    end case;
end process;

AluSrcAMux: process(aluSrcASig, pcOutSig, aSig)
begin
    case aluSrcASig is
        when '0' => aluOperandASig <= aSig;
        when others => aluOperandASig <= pcOutSig;
    end case;
end process;

extImm <= "000000000" & instr6_0Sig;
funcSig <= instr6_0Sig(3 downto 0);
rdSig <= instr6_0Sig(6 downto 4);

AluSrcBMux: process(aluSrcBSig, extImm, bSig)
begin
    case aluSrcBSig is
        when "00" => aluOperandBSig <= bSig;
        when "01" => aluOperandBSig <= x"0001";
        when "10" => aluOperandBSig <= extImm;
        when others => NULL;
    end case;
end process;

RegDstMux: process(regDstSig, instr9_7Sig, rdSig)
begin
    case regDstSig is
        when '0' => writeAddrSig <= instr9_7Sig;
        when others => writeAddrSig <= rdSig;
    end case;
end process;

jumpExtSig <= "000" & instr12_0Sig;
-- branchSumSig <= extImm + aSig;
branchSumSig <= extImm + pcOutSig;
branchMuxSelSig <= branchSig and zeroSig;
pcAddSig <= pcOutSig + 1;

-- Facem modificari aici
--JumpMux: process(jumpSig, resultSig, jumpExtSig)
--begin
--    case jumpSig is
--        when '0' => jumpMuxSig <= resultSig;
--        when others => jumpMuxSig <= jumpExtSig;
--    end case;
--end process; 

JumpMux: process(jumpSig, pcAddSig, jumpExtSig)
begin
    case jumpSig is
        when '0' => jumpMuxSig <= pcAddSig;
        when others => jumpMuxSig <= jumpExtSig;
    end case;
end process; 

JregMux: process(jregSig, aSig, jumpMuxSig)
begin
    case jregSig is
        when '0' => jregMuxSig <= jumpMuxSig;
        when others => jregMuxSig <= aSig;
    end case;
end process;

pcInSig <= branchMuxSig;
BranchMux: process(branchMuxSelSig, branchSumSig, jregMuxSig)
begin
    case branchMuxSelSig is
        when '0' => branchMuxSig <= jregMuxSig;
        when others => branchMuxSig <= branchSumSig;
    end case;
end process;

-- Display process

dis: ssd port map (displaySig(3 downto 0), displaySig(7 downto 4), displaySig(11 downto 8), displaySig(15 downto 12), clk, cat, an);

Display: process(sw, buttonEnnSig)
begin
    case sw(7 downto 4) is
        when "0000" => displaySig <= dataOutSig;
            when "0001" => displaySig <= pcOutSig;
            when "0011" => displaySig <= aluOutSig;
            when "0100" => displaySig <= "000000000" & instr6_0Sig;
            when "1100" => displaySig <= "000000000" & instr12_0Sig(6 downto 0);
            when "1000" => displaySig <= debug1Sig;
            when "1001" => displaySig <= debug2Sig;
            when "1010" => displaySig <= debug3Sig;
            when "1011" => displaySig <= "000000000000" & aluOpSig;
            when "1110" => displaySig <= jregMuxSig;
            when "1111" => displaySig <= branchSumSig;
            when others => NULL;
    end case;
end process;

led <= "000" & pcWriteSig & memWriteSig & irWriteSig & mdrWriteSig & regWriteSig & aWriteSig & bWriteSig & memAddrSig & memToRegSig & regDstSig & jumpSig & jregSig & branchSig;

end Behavioral;
