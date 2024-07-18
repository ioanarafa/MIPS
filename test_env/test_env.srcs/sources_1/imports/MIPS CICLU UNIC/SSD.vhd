library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( clk : in STD_LOGIC;
          digit : in STD_LOGIC_vector(31 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt: std_logic_vector(16 downto 0) := (others => '0');
signal out_mux: std_logic_vector(3 downto 0) := (others => '0');

begin
    
process(clk)                    -- numarator 17b
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
end process;

process(cnt)               -- mux 8:1 an
begin
        case cnt(16 downto 14) is
            when "000" => an <= "11111110";
            when "001" => an <= "11111101";
            when "010" => an <= "11111011";
            when "011" => an <= "11110111";
            when "100" => an <= "11101111";
            when "101" => an <= "11011111";
            when "110" => an <= "10111111";
            when others => an <= "01111111";
        end case;
end process;

process(cnt)                           -- mux 8:1 cat
    begin
        case cnt(16 downto 14) is
            when "000" => out_mux <= digit(3 downto 0);
            when "001" => out_mux <= digit(7 downto 4);
            when "010" => out_mux <= digit(11 downto 8);
            when "011" => out_mux <= digit(15 downto 12);
            when "100" => out_mux <= digit(19 downto 16);
            when "101" => out_mux <= digit(23 downto 20);
            when "110" => out_mux <= digit(27 downto 24);
            when others => out_mux <= digit(31 downto 28);
        end case;
end process;

 with out_mux select                        -- hex to 7-segment
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0
         
    
end Behavioral;