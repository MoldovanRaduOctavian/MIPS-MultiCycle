----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/10/2023 10:48:43 AM
-- Design Name: 
-- Module Name: control1 - Behavioral
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

entity control1 is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  opcode : in std_logic_vector(2 downto 0);
  func : in std_logic_vector(3 downto 0);
  pcWrite, memWrite, irWrite, mdrWrite, regWrite, aluOutWrite, aWrite, bWrite, memAddr, memToReg, regDst, jump, jreg, branch, aluSrcA : out std_logic;
  aluSrcB: out std_logic_vector(1 downto 0);
  aluOp : out std_logic_vector(3 downto 0)
   );
end control1;

architecture Behavioral of control1 is

signal nextState : std_logic_vector(3 downto 0) := "0000";
signal currState : std_logic_vector(3 downto 0) := "0000";
signal aluOpAux : std_logic_vector(3 downto 0) := "0000";

begin

fsm: process(currState, opcode, func)
begin

    case currState is
        when "0000" => nextState <= "0001";
        when "0001" => 
            if opcode = "000" then
                if func = "1111" then
                    nextState <= "0100";
                else
                    nextState <= "0010";
                end if;
            elsif opcode = "111" then
                nextState <= "0011";
            elsif opcode = "010" then
                nextState <= "0101";
            elsif opcode = "110" then
                nextState <= "0101";
            elsif opcode = "011" then
                nextState <= "0110";
            elsif opcode = "001" then
                nextState <= "0111";
            elsif opcode = "100" then
                nextState <= "0111";
            elsif opcode = "101" then
                nextState <= "0111";    
            end if;
        
        when "0010" => nextState <= "1000";
        when "0011" => nextState <= "0000";
        when "0100" => nextState <= "0000";
        when "0101" =>
            if opcode = "110" then
                nextState <= "1001";
            else
                nextState <= "1010";
            end if;
        when "0110" => nextState <= "1010";
        when "0111" =>
            if opcode = "100" then
                nextState <= "1011";
            elsif opcode = "101" then
                nextState <= "1100";
            elsif opcode = "001" then
                nextState <= "1010";
            end if;
        when "1000" => nextState <= "0000";
        when "1001" => nextState <= "0000";
        when "1010" => nextState <= "0000";
        when "1011" => nextState <= "1101";
        when "1100" => nextState <= "0000";
        when "1101" => nextState <= "0000"; 
        when others => nextState <= "0000";
    end case;
    
end process;

process (opcode, func, currState)
begin
    if currState = "0000" then
        aluOpAux <= "0000";
    else
        case opcode is
            when "000" => if func = "1111" then
                                aluOpAux <= "0000";
                           else
                                aluOpAux <= func;
                           end if;
            when "001" => aluOpAux <= "0000";
            when "010" => aluOpAux <= "0001";
            when "011" => aluOpAux <= "0011";
            when "100" => aluOpAux <= "0000";
            when "101" => aluOpAux <= "0000";
            when "110" => aluOpAux <= "0001";
            when "111" => aluOpAux <= "0000"; 
        end case;
    end if;

end process;

process(clk)
begin
    if rising_edge(clk) then
        if buttonEn = '1' then
            currState <= nextState;
        end if;
    end if;
end process;

control: process(currState)
begin
    
    case currState is
        when "0000" => pcWrite <= '1'; memWrite <= '0'; irWrite <= '1'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '1'; aluSrcB <= "01"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "0001" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '1'; bWrite <= '1'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "0010" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '1'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "0011" => pcWrite <= '1'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '1'; jreg <= '0'; branch <= '0';
        when "0100" => pcWrite <= '1'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '1'; branch <= '0';
        when "0101" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '1'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "10"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "0110" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '1'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "10"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "0111" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '1'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "10"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "1000" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '1'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '1'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "1001" => pcWrite <= '1'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '1';
        when "1010" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '1'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "1011" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '1'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '1'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "1100" => pcWrite <= '0'; memWrite <= '1'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '1'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when "1101" => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '1'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '1'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
        when others => pcWrite <= '0'; memWrite <= '0'; irWrite <= '0'; mdrWrite <= '0'; regWrite <= '0'; aluOutWrite <= '0'; aWrite <= '0'; bWrite <= '0'; memAddr <= '0'; memToReg <= '0'; regDst <= '0'; aluSrcA <= '0'; aluSrcB <= "00"; aluOp <= aluOpAux; jump <= '0'; jreg <= '0'; branch <= '0';
    end case;
    
end process;

end Behavioral;
