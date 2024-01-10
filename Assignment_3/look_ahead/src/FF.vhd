library IEEE;
use IEEE.Std_logic_1164.all;

entity FF is
    port
    (
		  CLK     :   in std_logic;                       
        RST     :   in std_logic;                                         
        D       :   in std_logic;
		  Q       :   out std_logic
    );
end FF;

architecture behavior of FF is
signal data : std_logic;

begin

REGpr:
		process(CLK, RST)
		begin
				if (RST = '0') then
					data <= '0';
				else		
					if (CLK'event and CLK ='1') then
						data <= D;
					end if;
				end if;
		end process;
		
Qpr:
		process(data)
		begin
				Q <= data;
		end process;
		
end architecture;
