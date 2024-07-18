library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is

signal count_in : std_logic_vector(31 downto 0):=x"00000000";
signal q1:std_logic;
signal q2:std_logic; 
signal q3:std_logic;

begin
enable<=q2 and (not q3);

process(clk)
begin
    if rising_edge(clk) then
        count_in <= count_in +1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if count_in(15 downto 0) ="1111111111111111" then
            q1 <= btn;
        end if;
    end if;
end process;

process(clk)
begin 
    if rising_edge(clk) then
       q2 <= q1;
       q3 <= q2;
    end if;
end process;


end Behavioral;
