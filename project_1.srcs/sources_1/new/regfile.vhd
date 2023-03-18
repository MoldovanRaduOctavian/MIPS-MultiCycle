----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 02:11:20 PM
-- Design Name: 
-- Module Name: regfile - Behavioral
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

entity regfile is
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
end regfile;

architecture Behavioral of regfile is

type regMem is array(0 to 7) of std_logic_vector(15 downto 0);
signal registerData : regMem := (others => x"0000");

begin

process (clk)
begin

    if rising_edge(clk) then
        if buttonEn = '1' then
            if regWrite = '1' then
                registerData(conv_integer(unsigned(writeAddress))) <= writeData;
            end if;
        end if;
    end if;

end process;

readData1 <= registerData(conv_integer(unsigned(readAddress1)));
readData2 <= registerData(conv_integer(unsigned(readAddress2)));

debug1 <= registerData(1);
debug2 <= registerData(2);
debug3 <= registerData(3);

end Behavioral;
