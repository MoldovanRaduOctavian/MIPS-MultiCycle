----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2022 02:50:41 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
  Port (
  a : in std_logic_vector(15 downto 0);
  b : in std_logic_vector(15 downto 0);
  aluOp : in std_logic_vector(3 downto 0);
  result : out std_logic_vector(15 downto 0);
  zero : out std_logic
   );
end alu;

architecture Behavioral of alu is

signal resultAux : std_logic_vector(15 downto 0) := x"0000";

begin

process(a, b, aluOp)
begin
    
    case aluOp is
        when "0000" => resultAux <= a + b;
        when "0001" => resultAux <= a - b;
        when "0010" => resultAux <= not a;
        when "0011" => resultAux <= a and b;
        when "0100" => resultAux <= a or b;
        when "0101" => resultAux <= a xor b;
        when "0110" => resultAux <= a nor b;
        when "1000" => resultAux <= conv_std_logic_vector(conv_integer(a) * conv_integer(b), 16);
        when "1001" => resultAux <= conv_std_logic_vector(conv_integer(a) / conv_integer(b), 16);
        when "1010" => resultAux <= conv_std_logic_vector(conv_integer(a) mod conv_integer(b), 16);
        when "1011" =>
            if conv_integer(a) < conv_integer(b) then
                resultAux <= x"0001";
            else
                resultAux <= x"0000";
            end if;
        when "1100" => resultAux <= a(14 downto 0) & '0';
        when "1101" => resultAux <= '0' & a(15 downto 1);
        when others => NULL;
    end case;
    
end process;

process(resultAux, a, b, aluOp)
begin
    if resultAux = x"0000" then
        zero <= '1';
    else
        zero <= '0';
    end if; 
end process;

result <= resultAux;

end Behavioral;
