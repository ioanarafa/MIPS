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

entity MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt: std_logic_vector(15 downto 0) := (others => '0');
signal Q1: std_logic := '0';
signal Q2: std_logic := '0';
signal Q3: std_logic := '0';
begin
    process(clk)                    
    begin                          
        if rising_edge(clk) then   
            cnt <= cnt + '1';     -- numarator 16b
        end if;
    end process;
    
    process(clk)                    
    begin                          
        if rising_edge(clk) then   
            if cnt = x"1111" then -- poarta AND 16:1
                Q1 <= btn; 
            end if;
            Q2 <= Q1;             -- D2 
            Q3 <= Q2;             -- D3  
        end if;
    end process;
     
    enable <= (not Q3) and Q2;   -- poarta AND 2:1 cu o intrare negata
end Behavioral;