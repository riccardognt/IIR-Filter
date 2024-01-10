library IEEE;
use IEEE.Std_logic_1164.all;

entity REG is
    port
    (
		CLK     :   in std_logic;                       
        RST     :   in std_logic;                       
        ENABLE  :   in  std_logic;                 
        D       :   in std_logic_vector(13 downto 0);
		Q       :   out std_logic_vector(13 downto 0)
    );
end REG;

architecture behavior of REG is

begin
		process(CLK, RST)
		begin
				if (RST = '0') then
					Q <= (others=>'0');
				elsif (CLK'event and CLK ='1' and ENABLE='1') then
					Q <= D;
				end if;
		end process;
		
end architecture;
							
