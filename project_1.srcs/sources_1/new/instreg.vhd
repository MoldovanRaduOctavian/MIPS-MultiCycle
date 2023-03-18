----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 02:30:23 PM
-- Design Name: 
-- Module Name: instreg - Behavioral
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

entity instreg is
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
end instreg;

architecture Behavioral of instreg is

signal instructionData : std_logic_vector(15 downto 0) := x"0000";

begin

--process(clk)
--begin
    
--    if falling_edge(clk) then
--        if buttonEn = '1' then
--            if irWrite = '1' then
--                instructionData <= instruction;
--            end if;
--        end if;
--    end if;
    
--end process;

--instr15_13 <= instructionData(15 downto 13);
--instr12_10 <= instructionData(12 downto 10);
--instr9_7 <= instructionData(9 downto 7);
--instr6_0 <= instructionData(6 downto 0);
--instr12_0 <= instructionData(12 downto 0);

process(clk)
begin
    if rising_edge(clk) then
        if buttonEn = '1' then
            if irWrite = '1' then
                instr15_13 <= instruction(15 downto 13);
                instr12_10 <= instruction(12 downto 10);
                instr9_7 <= instruction(9 downto 7);
                instr6_0 <= instruction(6 downto 0);
                instr12_0 <= instruction(12 downto 0);
            end if;
        end if;
    end if;
end process;

end Behavioral;
