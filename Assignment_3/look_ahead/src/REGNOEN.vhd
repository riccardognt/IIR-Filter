library IEEE;
use IEEE.Std_logic_1164.all;

entity REGNOEN is
    port
    (
		  CLK     :   in std_logic;                       
        RST     :   in std_logic;                                        
        D       :   in std_logic_vector(13 downto 0);
		  Q       :   out std_logic_vector(13 downto 0)
    );
end REGNOEN;

architecture behavior of REGNOEN is

begin

		process(CLK, RST)
		begin
				if (RST = '0') then
					Q<= (others=>'0');
				else		
					if (CLK'event and CLK ='1') then
						Q <= D;
					end if;
				end if;
		end process;
		
end architecture;
							
