----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 02:26:18 PM
-- Design Name: 
-- Module Name: reg - Behavioral
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

entity reg is
  Port (
  clk : in std_logic;
  buttonEn : in std_logic;
  rWrite : in std_logic;
  dataIn : in std_logic_vector(15 downto 0);
  dataOut : out std_logic_vector(15 downto 0)
   );
end reg;

architecture Behavioral of reg is

signal auxData : std_logic_vector(15 downto 0) := x"0000";

begin

process (clk)
begin
    
    if rising_edge(clk) then
        if buttonEn = '1' then
            if rWrite = '1' then
               auxData <= dataIn; 
            end if;
        end if;
    end if;
    
end process;

dataOut <= auxData;

end Behavioral;
