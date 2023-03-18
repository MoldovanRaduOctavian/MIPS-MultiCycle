----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 04:09:45 PM
-- Design Name: 
-- Module Name: uc - Behavioral
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

entity uc is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  opcode : in std_logic_vector(2 downto 0);
  func : in std_logic_vector(3 downto 0);
  pcWrite, memWrite, irWrite, mdrWrite, regWrite, aluOutWrite, aWrite, bWrite, memAddr, memToReg, regDst, jump, jreg, branch, aluSrcA : out std_logic;
  aluSrcB: out std_logic_vector(1 downto 0);
  aluOp : out std_logic_vector(3 downto 0)
   );
end uc;

architecture Behavioral of uc is

type microRom is array(0 to 15) of std_logic_vector(26 downto 0);
signal microProgram : microRom := (others => "000000000000000000000000000");

-- Posibil ca aceasta sa fie problema
-- 1/9/2023 modific microPc
-- signal microPc : std_logic_vector(3 downto 0) := "1111";
signal microPc : std_logic_vector(3 downto 0) := "0000";

signal microPcInc : std_logic_vector(3 downto 0) := "0000";
signal microPcNext : std_logic_vector(3 downto 0) := "0000";

signal microInstruction : std_logic_vector(26 downto 0) := "000000000000000000000000000";

signal microPcSel : std_logic_vector(1 downto 0) := "00";

signal aluOpAux : std_logic_vector(3 downto 0) := "0000";

begin

--mOp mAddr pcW memW irW mdrW regW aluOutW aW bW memAddr memToReg regDst srcA srcB aluOp j jreg branch
microProgram(0) <= b"00_0000_1_0_1_0_0_0_0_0_0_0_0_1_01_0000_0_0_0"; -- 0000
microProgram(1) <= b"10_0000_0_0_0_0_0_0_1_1_0_0_0_0_00_0000_0_0_0"; -- 0001
microProgram(2) <= b"01_1000_0_0_0_0_0_1_0_0_0_0_0_0_00_0000_0_0_0"; -- 0010
microProgram(3) <= b"01_0000_1_0_0_0_0_0_0_0_0_0_0_0_00_0000_1_0_0"; -- 0011
microProgram(4) <= b"01_0000_1_0_0_0_0_0_0_0_0_0_0_0_00_0000_0_1_0"; -- 0100
microProgram(5) <= b"10_0000_0_0_0_0_0_1_0_0_0_0_0_0_10_0001_0_0_0"; -- 0101
microProgram(6) <= b"01_1010_0_0_0_0_0_1_0_0_0_0_0_0_10_0011_0_0_0"; -- 0110
microProgram(7) <= b"10_0000_0_0_0_0_0_1_0_0_0_0_0_0_10_0000_0_0_0"; -- 0111
microProgram(8) <= b"01_0000_0_0_0_0_1_0_0_0_0_0_1_0_00_0000_0_0_0"; -- 1000
microProgram(9) <= b"01_0000_1_0_0_0_0_0_0_0_0_0_0_0_00_0001_0_0_1"; -- 1001
microProgram(10) <= b"01_0000_0_0_0_0_1_0_0_0_0_0_0_0_00_0000_0_0_0"; -- 1010
microProgram(11) <= b"01_1101_0_0_0_1_0_0_0_0_1_0_0_0_00_0000_0_0_0"; -- 1011
microProgram(12) <= b"01_0000_0_1_0_0_0_0_0_0_1_0_0_0_00_0000_0_0_0"; -- 1100
microProgram(13) <= b"01_0000_0_0_0_0_1_0_0_0_0_1_0_0_00_0000_0_0_0"; -- 0011

microPcInc <= microPc + 1;
microInstruction <= microProgram(conv_integer(microPc)); 
microPcSel <= microInstruction(26 downto 25);


process(microInstruction, microPcSel, microPcInc, microPc, opcode, func)
begin
    
    case microPcSel is
        when "00" => microPcNext <= microPcInc;
        when "01" => microPcNext <= microInstruction(24 downto 21);
        when "10" =>
            case microPc is
                when "0001" =>
                    if opcode = "000" then
                        if func = "1111" then
                            microPcNext <= "0100";
                        else
                            microPcNext <= "0010";
                        end if;
                    elsif opcode = "111" then
                        microPcNext <= "0011";
                    elsif opcode = "010" or opcode = "110" then
                        microPcNext <= "0101";
                    elsif opcode = "011" then
                        microPcNext <= "0110";
                    elsif opcode = "001" or opcode = "100" or opcode = "101" then
                        microPcNext <= "0111";
                    end if;
                when "0101" =>
                    if opcode = "110" then
                        microPcNext <= "1001";
                    else
                        microPcNext <= "1010";
                    end if; 
                when "0111" =>
                    if opcode = "100" then
                        microPcNext <= "1011";
                    elsif opcode = "101" then
                        microPcNext <= "1100";
                    elsif opcode = "001" then
                        microPcNext <= "1010";
                    end if;
                when others => microPcNext <= "0000";    
            end case;
         when others => NULL;   
    end case;

end process;

process (opcode, func, microInstruction)
begin
    case opcode is
        when "000" =>
            if func = "1111" then
                aluOpAux <= "0000";
            else
                aluOpAux <= func;
            end if;
        when "001" => aluOpAux <= "0000";
        when "010" => aluOpAux <= "0001";
        when "011" => aluOpAux <= "0011";
        when "100" => aluOpAux <= "0000";
        when "101" => aluOpAux <= "0000";
        when "110" => aluOpAux <= "0000";
        when others => aluOpAux <= "0000"; 
    end case;
end process;

process(clk)
begin
    
    if rising_edge(clk) then
        if buttonEn = '1' then
            microPc <= microPcNext;
        end if;
    end if;
    
end process;

pcWrite <= microInstruction(20);
memWrite <= microInstruction(19);
irWrite <= microInstruction(18);
mdrWrite <= microInstruction(17);
regWrite <= microInstruction(16);
aluOutWrite <= microInstruction(15);
aWrite <= microInstruction(14);
bWrite <= microInstruction(13);
memAddr <= microInstruction(12);
memToReg <= microInstruction(11);
regDst <= microInstruction(10);
aluSrcA <= microInstruction(9);
aluSrcB <= microInstruction(8 downto 7);
aluOp <= aluOpAux;
jump <= microInstruction(2);
jreg <= microInstruction(1);
branch <= microInstruction(0);


end Behavioral;
